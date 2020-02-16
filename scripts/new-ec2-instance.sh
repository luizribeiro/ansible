#!/usr/bin/env ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook
# TODO: figure out a way to fetch ssh host fingerprint to known_hosts
---
- hosts: localhost
  connection: local
  gather_facts: false
  vars_files:
    - ../secrets.yaml
  environment:
    AWS_ACCESS_KEY: "{{ aws_access_key }}"
    AWS_SECRET_KEY: "{{ aws_secret_key }}"
  tasks:
    - name: Create ec2 instance
      ec2:
        # from https://www.uplinklabs.net/projects/arch-linux-on-ec2/
        image: ami-0470431e11a734fd9
        instance_type: "{{ instance_type | default('t3a.nano') }}"
        region: us-east-2
        key_name: GPG
        wait: true
      register: ec2
    - name: Add instance to hosts file
      lineinfile:
        path: ../hosts
        regexp: "{{ item.public_dns_name }}"
        line: "{{ item.public_dns_name }}"
        insertafter: "\\[ec2\\]"
      with_items: "{{ ec2.instances }}"
    - name: Add new instance to launched in-memory launched hosts group
      add_host:
        hostname: "{{ item.public_dns_name }}"
        groupname: launched
      with_items: "{{ ec2.instances }}"

- hosts: launched
  gather_facts: false
  remote_user: arch
  tasks:
    - name: Wait for host to become reachable
      wait_for_connection:

- hosts: launched
  remote_user: arch
  vars_files:
    - ../secrets.yaml
  become: true
  tasks:
    - name: Upgrade system
      pacman:
        update_cache: true
        upgrade: true
    - name: Reboot machine
      reboot:
    - name: Wait for host to become reachable again
      wait_for_connection:

- import_playbook: ../ec2.yaml
  vars:
    custom_hosts: launched
    custom_remote_user: arch
