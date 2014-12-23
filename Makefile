
bin/_: var/submakefile var/ttr
	mkdir -p var/src
	mkdir -p bin
	$(MAKE) -f var/submakefile

var/submakefile: src/build-submakefile.pl
	mkdir -p var
	perl src/build-submakefile.pl > var/submakefile

#var/_make: var/ttr
#	$(CURDIR)/_make.sh

var/ttr: ttools/bin/ttr
	mkdir -p var
	cp ttools/bin/ttr var/ttr

ttools/bin/ttr: ttools/make.sh
	cd ttools; ./make.sh

ttools/make.sh:
	if [ -e ttools ]; then rm -rv ttools; fi
	git clone 'https://github.com/hydrocul/ttools.git' ttools

clean:
	-rm -rv bin var ttools

mostlyclean:
	-rm -rv bin var


