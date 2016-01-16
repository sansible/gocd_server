
all: test clean

test: test_deps vagrant_up

integration_test: clean integration_test_deps vagrant_up clean

test_deps:
	rm -rf tests/vagrant/ansible-city.gocd_server
	ln -s ../.. tests/vagrant/ansible-city.gocd_server
	ansible-galaxy install --force -p tests/vagrant -r tests/vagrant/local_requirements.yml

integration_test:
	ansible-galaxy install --force -p tests/vagrant -r tests/vagrant/integration_requirements.yml

vagrant_up:
	@cd tests/vagrant; \
	if (vagrant status | grep -E "(running|saved|poweroff)" 1>/dev/null) then \
		vagrant up || exit 1; \
		vagrant provision || exit 1; \
	else \
		vagrant up || exit 1; \
	fi;

clean:
	rm -rf tests/vagrant/ansible-city.*
	cd tests/vagrant && vagrant destroy
