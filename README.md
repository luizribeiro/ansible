# luizribeiro's ansible settings

![CI](https://github.com/luizribeiro/ansible/workflows/CI/badge.svg)

```
$ git submodule update --init
$ poetry install
$ poetry shell
$ ansible-galaxy install -r requirements.yml
$ ansible-playbook site.yaml
```

## Setting up secrets

1. Add vault password to `vault_pass.gpg`
2. `ansible-vault create group_vars/secrets.yaml`
3. Setup `group_vars/secrets.yaml` according to `group_vars/secrets.yaml.example`

## OSX

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install ansible
$ ./grissom.yaml
```

## Bootstrapping a Raspberry Pi

1. Unmount the SD card: `diskutil unmountDisk /dev/diskN`
2. Copy the image: `sudo dd bs=1m if=path_of_our_image.img of=/dev/rdiskN; sync` (note that it is `rdisk`)
3. `touch /Volumes/boot/ssh` to enable ssh access
4. Add the following to `/Volumes/boot/wpa_supplicant.conf`:

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
 ssid="<Name of your wireless LAN>"
 psk="<Password for your wireless LAN>"
}
```

Unmount the SD card, connect the Pi to the network and run this to bootstrap it:

```
$ ./scripts/pi-bootstrap -l iot-mariner -e playbook=iot-mariner.yaml
```

## TODOs

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
  * Add test coverage to samba role
