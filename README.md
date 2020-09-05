# luizribeiro's ansible settings

[![Build Status](https://travis-ci.com/luizribeiro/ansible.svg?token=Y5WyECQyFrzmKkJLsCaK&branch=master)](https://travis-ci.com/luizribeiro/ansible)
[![Dependency Status](https://img.shields.io/librariesio/release/github/luizribeiro/ansible)](https://libraries.io/github/luizribeiro/ansible)

```
$ git submodule update --init
$ pipenv install -d
$ pipenv shell
$ ansible-galaxy install -r requirements.yml
$ ansible-playbook site.yaml
```

## Setting up secrets

1. Add vault password to `vault_pass.gpg`
2. `ansible-vault create group_vars/secrets.yaml`
3. Setup `group_vars/secrets.yaml` according to `group_vars/secrets.yaml.example`

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

* Refactor
  * Break down server role
  * Move monit into its own role

* Automation
  * Setup healthchecks.io and monit automatically with API

* OSX:
  * Allow for collectd package on OSX to be built with MQTT support

* From new MacBook Setup:
  * Setup dark/light mode based on setting
  * Automatically setup default browser
  * Setup Alfred license key
  * Setup Alfred preferences directory
  * Setup Alfred hotkey
  * Maybe setup gpg first thing somehow?
  * Setup Karabiner or something that makes caps work as ctrl/escape

* Testing:
  * Add test coverage to webserver role (test nginx config)
  * Add test coverage to pihole role
  * Add test coverage to samba role

* Fun stuff
  * Setup port knocking
  * Honeypots?
