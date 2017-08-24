PROJECT = cowboy_test
PROJECT_DESCRIPTION = Cowboy Test
PROJECT_VERSION = 0.1.0

DEPS = cowboy lager

include erlang.mk

ERLC_OPTS += +'{parse_transform, lager_transform}'


selfcert: certs/iosport.co.uk.key certs/iosport.co.uk.cert

certs/iosport.co.uk.key certs/iosport.co.uk.cert: certs
	openssl req \
		-new \
		-newkey rsa:4096 \
		-days 365 \
		-nodes \
		-x509 \
		-subj "/C=UK/O=ioSport/CN=*.iosport.co.uk" \
		-keyout certs/iosport.co.uk.key \
		-out certs/iosport.co.uk.cert

certs:
	mkdir certs

TSUNG=tsung-1.6.0

$(TSUNG)/bin/tsung: $(TSUNG)/.dummy
	cd $(TSUNG) && ./configure --prefix=`pwd` && $(MAKE) && $(MAKE) install

$(TSUNG)/.dummy: $(TSUNG).tar.gz
	tar xzf $(TSUNG).tar.gz && touch $(TSUNG)/.dummy

$(TSUNG).tar.gz:
	curl -O  http://tsung.erlang-projects.org/dist/$(TSUNG).tar.gz

run-tsung: $(TSUNG)/bin/tsung tsung/tsung.xml
	$(TSUNG)/bin/tsung -f tsung/tsung.xml -l tsung/log start
	@ L=`ls -r tsung/log |head -1` ;\
		echo Generating report in tsung/log/$$L && \
		cd tsung/log/$$L && \
		../../../$(TSUNG)/lib/tsung/bin/tsung_stats.pl --dygraph --title "Tsung $$L" && \
		cd ../.. && \
		rm -f latest && ln -vs log/$$L latest && \
		echo open tsung/latest/report.html
