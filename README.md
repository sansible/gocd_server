# GO CD Server

Please see the Sansible readme for information on how to
[contribure](https://github.com/sansible/sansible)

Master: [![Build Status](https://travis-ci.org/sansible/gocd_server.svg?branch=master)](https://travis-ci.org/sansible/gocd_server)
Develop: [![Build Status](https://travis-ci.org/sansible/gocd_server.svg?branch=develop)](https://travis-ci.org/sansible/gocd_server)

* [Installation and Dependencies](#installation-and-dependencies)
* [Tags](#tags)
* [Examples](#examples)

This roles installs GO CD server, for GO CD Agent installation please
see the [Sansible GO CD Agent Role](https://github.com/sansible/gocd_agent)

For more information about GO CD please visit
[https://www.gocd.org/](https://www.gocd.org/).


## Installation and Dependencies

This role has a "java" dependency. You can let this role install Oracle
Java 8, or install it yourself and set
`sansible_gocd_server_dependencies_skip_java` to `yes`.

AWS CLI tools are also installed by default, you can turn this feature off
by setting `sansible_gocd_server_aws_install_cli` to `no`.

To install this role run `ansible-galaxy install sansible.gocd_server`
or add this to your `roles.yml`

```YAML
- name: sansible.gocd_server
  version: v2.0
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
      sansible_gocd_server_max_mem: 4096m
      sansible_gocd_server_max_perm_gen: 256m
      sansible_gocd_server_mem: 2048m
      sansible_gocd_server_min_perm_gen: 128m
      sansible_gocd_server_version: "14.4.*"
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
      sansible_gocd_server_dependencies_skip_java: yes
```

To **generate passwd file** you have to specify a dictionary of
`username: sha-passwd`

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
      sansible_gocd_server_passwd_users:
        test.user: "{SHA}iCKdyZxzuc4lU6CCoqsp4H99608="
```

To enable AWS S3 Bucket backups/restore create s3 bucket first
(s3://backup.gocd-server.my.domain).

You can also specify access and secret keys, and this role will
create `~/.aws/credentials` for you. But we strongly advise to use
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
      sansible_gocd_server_aws_access_key_id: LOREMIPSUMDOLORKV4IQ
      sansible_gocd_server_aws_backup_bucket: s3://backup.gocd-server.my.domain
      sansible_gocd_server_aws_secret_access_key: sit+Ament+Hl8V2lQpaOkLRakvGMidrkWv6F9
```
