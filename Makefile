
.DEFAULT_GOAL := help
.PHONY: help

all: test vagrant_halt clean

all: test clean

## Run tests on any file change
watch: test_deps
	while sleep 1; do \
		find defaults/ handlers/ meta/ tasks/ templates/ tests/vagrant/test.yml \
		| entr -d make test; \
	done

## Run tests
test: test_deps vagrant_up

## Install test dependencies
test_deps:
	rm -rf tests/vagrant/sansible.gocd_server
	ln -s ../.. tests/vagrant/sansible.gocd_server
	ansible-galaxy install --force -p tests/vagrant -r tests/vagrant/local_requirements.yml

## Start and (re)provisiom Vagrant test box
vagrant:
	cd tests/vagrant && vagrant up --no-provision
	cd tests/vagrant && vagrant provision

## Execute simple Vagrant command
# Example: make vagrant_ssh
#          make vagrant_halt
vagrant_%:
	cd tests/vagrant && vagrant $(subst vagrant_,,$@)

## Lint role
# You need to install ansible-lint
lint:
	find defaults/ meta/ tasks/ templates/ -name "*.yml" | xargs -I{} ansible-lint {}

## Clean up
clean:
	rm -rf tests/vagrant/sansible.*
	cd tests/vagrant && vagrant destroy

## Prints this help
help:
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)
