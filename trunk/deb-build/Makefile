DIR_ORIGIN = ../src
DIR_BASE_INSTALL = /opt/script-crypt

all: install

install:
	PS4="CMD:\${0}:pid=\${$}: "
	set -x
	test -d $(DESTDIR)/usr/bin/ || install --directory --owner=root --group=root --mode=755 --verbose $(DESTDIR)/usr/bin/
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/ConfFileSetGet.py $(DESTDIR)/usr/bin/conf-file-get-set
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/TooLongNames.py $(DESTDIR)/usr/bin/too-long-names

clean:
	echo "INFO:${0}:pid=${$}: Nothing to be done for cleanup after this DEB package build."
