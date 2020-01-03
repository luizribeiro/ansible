# luizribeiro's ansible settings

[![Build Status](https://travis-ci.com/luizribeiro/ansible.svg?token=Y5WyECQyFrzmKkJLsCaK&branch=master)](https://travis-ci.com/luizribeiro/ansible)

```
$ ansible-playbook site.yaml
```

## Setting up secrets

1. Add vault password to `vault_pass.gpg`
2. `ansible-vault create secrets.yaml`
3. Setup `secrets.yaml` according to `example-secrets.yaml`

## TODOs

* TODO: setup all home assistant secrets
* TODO: setup nginx secrets
* TODO: setup nginx host config according to setup roles
* TODO: replace sshguard with fail2ban
* TODO: setup automated backups for home and hass
* TODO: check if I have to setup sshusers group myself
* TODO: check if I have to setup sudo and wheels group myself
* TODO: automatically setup my own user
