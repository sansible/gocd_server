# GO CD Server

* [ansible.cfg](#ansible-cfg)
* [Dependencies](#dependencies)
* [Tags](#tags)
* [Examples](#examples)

This roles installs GO CD server.

For more information about GO CD please visit [go.cd/](http://www.go.cd/).




## ansible.cfg

This role is designed to work with merge "hash_behaviour". Make sure your
ansible.cfg contains these settings

```INI
[defaults]
hash_behaviour = merge
```




## Dependencies

To install dependencies, add this to your roles.yml

```YAML
---

- name: ansible-city.gocd_server
  src: git+git@github.com:ansible-city/gocd_server.git
  version: origin/master # or any other tag/branch
```

and run `ansible-galaxy install -p . -r roles.yml`




## Tags

This role uses two tags: **build** and **configure**

* `build` - Installs Go CD server and all it's dependencies.
* `configure` - Configure and ensures that the service is running.




## Examples

To simply install GO CD server:

```YAML
- name: Install GO CD Server
  hosts: sandbox

  pre_tasks:
    - name: Update apt
      sudo: yes
      command: apt-get update
      tags:
        - build

  roles:
    - gocd_server
```

A bit more advanced playbook to install on a box with more then 4GB ram:

```YAML
- name: Install GO CD Server
  hosts: sandbox

  pre_tasks:
    - name: Update apt
      sudo: yes
      command: apt-get update
      tags:
        - build

  roles:
    - role: ansible-city.gocd_server
      gocd_server:
        version: "14.4.*"
        server_max_mem: 4096m
        server_max_perm_gen: 256m
        server_mem: 2048m
        server_min_perm_gen: 128m
```

**Skip Java** installation, if you want to use your own Java role

```YAML
- name: Install GO CD Server
  hosts: sandbox

  pre_tasks:
    - name: Update apt
      sudo: yes
      command: apt-get update
      tags:
        - build

  roles:
    - role: my-own.java
    - role: ansible-city.gocd_server
      gocd_server:
        dependencies:
          skip_java: yes
```

To **generate passwd file** you have to specify a dictionary of
`username:sha-passwd`

```YAML
- name: Install GO CD Server
  hosts: sandbox

  pre_tasks:
    - name: Update apt
      sudo: yes
      command: apt-get update
      tags:
        - build

  roles:
    - role: ansible-city.gocd_server
      gocd_server:
        passwd_users:
          test.user: "{SHA}iCKdyZxzuc4lU6CCoqsp4H99608="
```
