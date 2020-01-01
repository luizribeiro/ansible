# luizribeiro's ansible settings

```
$ ansible-playbook monit.yaml --ask-become-pass --vault-id vault_pass.txt
$ ansible-playbook collectd.yaml --ask-become-pass
$ ansible-playbook fail2ban.yaml --ask-become-pass
```

Or simply:

```
$ ansible-playbook site.yaml --ask-become-pass --vault-id vault_pass.txt
```
