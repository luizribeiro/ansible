# luizribeiro's ansible settings

[![Build Status](https://travis-ci.com/luizribeiro/ansible.svg?token=Y5WyECQyFrzmKkJLsCaK&branch=master)](https://travis-ci.com/luizribeiro/ansible)

```
$ git submodule update --init
$ ansible-playbook site.yaml
```

## Setting up secrets

1. Add vault password to `vault_pass.gpg`
2. `ansible-vault create secrets.yaml`
3. Setup `secrets.yaml` according to `example-secrets.yaml`

## Upgrading all packages

```
$ ansible-playbook site.yaml --tags upgrade
```

Note that this does not restart all upgraded services yet.

## OSX

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install ansible
$ ./grissom.yaml
```

## TODOs

* TODO: enable nightly router backups
* TODO: allow for collectd package on OSX to be built with MQTT support
* TODO: find a way to validate nginx conf.d files
* TODO: find a way to validate monit conf.d files
* TODO: restart services automatically upon upgrade
