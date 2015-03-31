test: copy-sample-config
	echo "0" > /tmp/testing-dead.pid
	echo "1" > /tmp/testing-alive.pid
	rm -rf /tmp/light-monit.testing
	echo "running a first time, should return from unknown TO alive, dead, not-running and invalid-check-command"
	./light-monit  `pwd`/test/etc
	echo "running a second time, should return nothing"
	./light-monit  `pwd`/test/etc
	
build: copy-sample-config
	
copy-sample-config:
	cp ./sample-etc/checks.d/* ./test/etc/checks.d/
	cp ./sample-etc/notifiers.d/* ./test/etc/notifiers.d/