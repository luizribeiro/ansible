# luizribeiro's openwrt settings

[![Build Status](https://travis-ci.com/luizribeiro/ansible-openwrt.svg?branch=master)](https://travis-ci.com/luizribeiro/ansible-openwrt)

```
$ git submodule update --init
$ ./openwrt.yaml
```

## Setting up secrets

1. Add vault password to `vault_pass.gpg`
2. `ansible-vault create secrets.yaml`
3. Setup `secrets.yaml` according to `example-secrets.yaml`

## TODOs

* TODO: enable services currently under /etc/rc.d
* TODO: split config files into their own copy task (per service so we can restart them)
* TODO: connect config files to handlers that restart services when needed
* TODO: setup patches for MQTT on luci-app-statistics
* TODO: tasks to check differences between local and remote files
