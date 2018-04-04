import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_installed_packages(host):
    packages = [
        'apt-transport-https', 'cron', 'git', 'go-server', 'python-pip',
        'net-tools', 'openjdk-8-jdk', 'tree', 'unzip',
    ]
    for package in packages:
        assert host.package(package).is_installed

    pip_packages = host.pip_package.get_packages()
    assert 'awscli' in pip_packages
    assert 'boto' in pip_packages


def test_files(host):
    directories = [
        '/home/go/.aws/', '/home/go/bin/',
        '/home/go/work/go-server/artifacts/pipelines/',
        '/home/go/work/go-server/plugins/external/',
    ]
    for directory in directories:
        assert host.file(directory).is_directory

    configs = [
        '/etc/default/go-server', '/home/go/.bashrc', '/home/go/.ssh/config',
        '/home/go/passwd',
    ]
    for config in configs:
        assert host.file(config).is_file


def test_listening(host):
    assert host.socket('tcp://0.0.0.0:8153').is_listening
    assert host.socket('tcp://0.0.0.0:8154').is_listening


def test_process(host):
    go_server = host.process.get(user='go', comm='java')
    mem_settings = [
        '-Xms256m', '-Xmx512m', '-XX:PermSize=128m', '-XX:MaxPermSize=128m',
    ]
    for setting in mem_settings:
        assert setting in go_server.args
