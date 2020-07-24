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

To install this role run `ansible-galaxy install sansible.gocd_server`
or add this to your `roles.yml`

```YAML
- name: sansible.gocd_server
  version: v3.0
```

and run `ansible-galaxy install -p ./roles -r roles.yml`.

The `sansible.users_and_groups` role is required to use this
role.


## Tags

This role uses two tags: **build** and **configure**

* `build` - Installs Go CD server and all it's dependencies.
* `configure` - Configure and ensures that the service is running.


## Examples

Please see [defaults/main.yml](defaults/main.yml) and [vars/main.yml](vars/main.yml)
for available settings and defaults.

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

Adding some additional system properties/startup options and some plugins, you must
start from 105 for additional properties:

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
      sansible_gocd_server_plugins:
        - "https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v1.3.5/github-pr-poller-1.3.5.jar"
        - "https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/1.6-73/github-pr-status-1.6-73.jar"
        - "https://github.com/gocd-contrib/script-executor-task/releases/download/0.3/script-executor-0.3.0.jar"
      sansible_gocd_server_properties:
        "wrapper.java.additional.105": "-Dmail.smtp.starttls.enable=true"
        "wrapper.java.additional.106": "-Dgo.plugin.build.status.go-server=http://gocd-server:8153"
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
