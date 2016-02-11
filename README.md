# GO CD Server

Master: [![Build Status](https://travis-ci.org/sansible/gocd_server.svg?branch=master)](https://travis-ci.org/sansible/gocd_server)  
Develop: [![Build Status](https://travis-ci.org/sansible/gocd_server.svg?branch=develop)](https://travis-ci.org/sansible/gocd_server)

* [ansible.cfg](#ansible-cfg)
* [Installation and Dependencies](#installation-and-dependencies)
* [Tags](#tags)
* [Examples](#examples)
* [Development & Testing](#development---testing)

This roles installs GO CD server.

For more information about GO CD please visit [go.cd/](http://www.go.cd/).




## ansible.cfg

This role is designed to work with merge "hash_behaviour". Make sure your
ansible.cfg contains these settings

```INI
[defaults]
hash_behaviour = merge
```




## Installation and Dependencies

This role has a "java" dependency. You can let this role install Oracle
Java 7, or install it yourself and set `gocd_server.dependencies.skip_java`
to `yes`.

To install this role run `ansible-galaxy install sansible.gocd_server`
or add this to your `roles.yml`

```YAML
- name: sansible.gocd_server
  version: v1.0
```

and run `ansible-galaxy install -p ./roles -r roles.yml`




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
      become: yes
      command: apt-get update
      tags:
        - build

  roles:
    - name: sansible.gocd_server
```

A bit more advanced playbook to install on a box with more then 4GB ram:

```YAML
- name: Install GO CD Server
  hosts: sandbox

  pre_tasks:
    - name: Update apt
      become: yes
      command: apt-get update
      tags:
        - build

  roles:
    - role: sansible.gocd_server
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
      become: yes
      command: apt-get update
      tags:
        - build

  roles:
    - name: my-own.java
    - name: sansible.gocd_server
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
      become: yes
      command: apt-get update
      tags:
        - build

  roles:
    - name: sansible.gocd_server
      gocd_server:
        passwd_users:
          test.user: "{SHA}iCKdyZxzuc4lU6CCoqsp4H99608="
```

To enable AWS S3 Bucket backups/restore create s3 bucket first
(s3://backup.gocd-server.my.domain).

You can also specify access and secret keys, and this role will
create ~/.aws/credentials for you. But we strongly advise to use
"IAM Instance Profiles".

```YAML
- name: Install GO CD Server
  hosts: sandbox

  pre_tasks:
    - name: Update apt
      become: yes
      apt:
        cache_valid_time: 1800
        update_cache: yes
      tags:
        - build

  roles:
    - name: sansible.gocd_server
      gocd_server:
        aws:
          backup_bucket: s3://backup.gocd-server.my.domain
          access_key_id: LOREMIPSUMDOLORKV4IQ
          secret_access_key: sit+Ament+Hl8V2lQpaOkLRakvGMidrkWv6F9
```




## Development & Testing

If you want to work on this role, please start with running
`make watch`. This will watch for any file changes and re-provision
vagrant box.

If you want to test the AWS backup/restore script locally you need
to create a file `/tests/vagrant/local_vars.yml` with

```YAML
---

gocd_server:
  aws:
    backup_bucket: s3://backup.gocd-server.my.domain
    access_key_id: LOREMIPSUMDOLORKV4IQ
    secret_access_key: sit+Ament+Hl8V2lQpaOkLRakvGMidrkWv6F9

```
