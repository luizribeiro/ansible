ANSIBLE_INVENTORY=$(ansible-inventory --list)

_list_hosts_impl() {
  local group="$1"
  local hosts=($(echo "$ANSIBLE_INVENTORY" | jq -r ".[\"$group\"].hosts // [] | .[]"))
  local children=($(
    echo "$ANSIBLE_INVENTORY" | jq -r ".[\"$group\"].children // [] | .[]"
  ))
  for child in "${children[@]}"; do
    local children_hosts=($(list_hosts "$child"))
    hosts=("${hosts[@]}" "${children_hosts[@]}")
  done

  echo "${hosts[@]}"
}

list_hosts() {
  local group="$1"
  local all_hosts=($(
    echo "$ANSIBLE_INVENTORY" | jq -r "._meta.hostvars | keys // [] | .[]"
  ))
  local hosts=($(_list_hosts_impl "$1"))

  if [[ "${all_hosts[@]}" =~ "${group}" ]]; then
    # group is actually a host, so add it to the list of hosts
    hosts=("${hosts[@]}" "$group")
  fi

  echo "${hosts[@]}"
}

num_hosts() {
  local hosts=($(list_hosts "$1"))
  echo "${#hosts}"
}

get_user() {
  local host="$1"
  echo "$ANSIBLE_INVENTORY" \
    | jq -r "._meta.hostvars[\"$host\"].ansible_user // \"$USER\""
}

get_host() {
  local host="$1"
  echo "$ANSIBLE_INVENTORY" \
    | jq -r "._meta.hostvars[\"$host\"].ansible_host // \"$host\""
}
