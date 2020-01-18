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
