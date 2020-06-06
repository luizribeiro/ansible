ANSIBLE_INVENTORY=$(ansible-inventory --list)

list_hosts() {
  local group="$1"
  local hosts=($(jq -r ".$group.hosts // [] | .[]" <<< $ANSIBLE_INVENTORY))
  local children=($(
    jq -r ".$group.children // [] | .[]" <<< $ANSIBLE_INVENTORY
  ))
  for child in "${children[@]}"; do
    local children_hosts=($(list_hosts "$child"))
    hosts=("${hosts[@]}" "${children_hosts[@]}")
  done

  echo "${hosts[@]}"
}

num_hosts() {
  local hosts=($(list_hosts "$1"))
  echo "${#hosts}"
}

get_user() {
  local host="$1"
  ansible-inventory --list \
    | jq -r "._meta.hostvars[\"$host\"].ansible_user // \"$USER\""
}
