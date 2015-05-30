# GO CD Server

This roles installs GO CD server.

For more information about GO CD please visit [go.cd/](http://www.go.cd/).




## Example Playbook

To simply install GO CD server:

```YAML
- name: Install GO CD Server
  hosts: sandbox

  roles:
    - gocd_server
```

A bit more advanced playbook to install on a box with more then 4GB ram:

```YAML
- name: Install GO CD Server
  hosts: sandbox

  vars:
    gocd_server:
      version: "14.4.*"
      server_max_mem: 4096m
      server_max_perm_gen: 256m
      server_mem: 2048m
      server_min_perm_gen: 128m

  roles:
    - gocd_server
```
