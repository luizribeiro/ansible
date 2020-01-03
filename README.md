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

* TODO: check if I have to setup sshusers group myself
* TODO: automatically setup my own user
* TODO: setup automated backups for home and hass
* TODO: replace sshguard with fail2ban
* TODO: find a way to validate nginx conf.d files
* TODO: find a way to validate monit conf.d files
