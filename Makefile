
all: test clean

test: test_deps
	@cd tests/vagrant; \
	if (vagrant status | grep -E "(running|saved|poweroff)" 1>/dev/null) then \
		vagrant up || exit 1; \
		vagrant provision || exit 1; \
	else \
		vagrant up || exit 1; \
	fi;

test_deps:
	ansible-galaxy install --force -p tests/vagrant -r tests/vagrant/roles.yml

clean:
	rm -rf tests/vagrant/ansible-city.java
	cd tests/vagrant && vagrant destroy
