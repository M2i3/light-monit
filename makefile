#
# light-monit - A very light monitoring framework
# Copyright (c) 2015 M2i3
#

config_folder := /etc/light-monit
processes_folder := $(config_folder)/processes.d
notifiers_folder := $(config_folder)/notifiers.d
checks_folder := $(config_folder)/checks.d
state_folder := /var/lib/light-monit
test_install_container_name := light-monit-test-install

build: .copy-sample-config

install: check-prequisite build 
	cp ./light-monit /usr/bin/
	chmod +x /usr/bin/light-monit
	
	mkdir -p $(processes_folder) 
	mkdir -p $(notifiers_folder)
	mkdir -p $(checks_folder)
	
	cp -r ./sample-etc/* $(config_folder)
	
	mkdir -p $(state_folder)
	
	chown -R root:root $(config_folder)
	chown -R root:root $(state_folder)
	
test: .build-test-container
	docker run --rm -it -e PUSHOVER_TOKEN=$(PUSHOVER_TOKEN) -e PUSHOVER_USER=$(PUSHOVER_USER) light-monit-test make .real-test

test-install: .build-test-container
	echo testing with $(test_install_container_name)
	docker run --name $(test_install_container_name) -it -e PUSHOVER_TOKEN=$(PUSHOVER_TOKEN) -e PUSHOVER_USER=$(PUSHOVER_USER) light-monit-test make .real-test-install
	docker diff $(test_install_container_name)
	docker rm -f $(test_install_container_name)
	
check-prequisite:
	@command -v curl >/dev/null 2>&1 || echo "NOTICE: We need a recent version of curl if you plan to utilize the pushover notifier."

.real-test: .copy-sample-config
	@echo "9999999" > /tmp/testing-dead.pid
	@echo "1" > /tmp/testing-alive.pid
	@rm -rf /tmp/light-monit.testing
	@echo "running a first time, should return from unknown TO alive, dead, not-running and invalid-check-command"
	./light-monit  `pwd`/test/etc
	@echo "running a second time, should return nothing"
	@./light-monit  `pwd`/test/etc	

.real-test-install: install
	@echo "9999999" > /tmp/testing-dead.pid
	@echo "1" > /tmp/testing-alive.pid
	@rm -rf /var/lib/light-monit/*
	cp ./test/etc/processes.d/* $(processes_folder)/ 

	@echo "running a first time, should return from unknown TO alive, dead, not-running and invalid-check-command"
	light-monit
	@echo "running a second time, should return nothing"
	light-monit
	
	
.copy-sample-config:
	@cp ./sample-etc/checks.d/* ./test/etc/checks.d/
	@cp ./sample-etc/notifiers.d/* ./test/etc/notifiers.d/


.build-test-container:
	docker build -t light-monit-test -f=test.dockerfile ./
	
.cleanup-test-container:
	docker rmi light-monit-test