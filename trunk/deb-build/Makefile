DIR_ORIGIN = ../src
DIR_BASE_INSTALL = /opt/script-crypt

all: install

install:
	PS4="CMD:\${0}:pid=\${$}: "
	set -x
	test -d $(DESTDIR)/usr/bin/       || install --directory --owner=root --group=root --mode=755 --verbose   $(DESTDIR)/usr/bin/
	test -d $(DESTDIR)/etc/profile.d/ || install --directory --owner=root --group=root --mode=755 --verbose   $(DESTDIR)/etc/profile.d/
	test -d $(DESTDIR)/etc/init.d/    || install --directory --owner=root --group=root --mode=755 --verbose   $(DESTDIR)/etc/init.d/
	test -d $(DESTDIR)/etc/rc3.d/     || install --directory --owner=root --group=root --mode=755 --verbose   $(DESTDIR)/etc/rc3.d/
	test -d $(DESTDIR)/home/.opt/     || install --directory --owner=root --group=root --mode=755 --verbose   $(DESTDIR)/home/.opt/
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/ConfFileSetGet.py $(DESTDIR)/usr/bin/conf-file-get-set
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/TooLongNames.py $(DESTDIR)/usr/bin/too-long-names
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/rename-APK-by-versions.sh $(DESTDIR)/usr/bin/rename-apk-by-versions
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/upgrade-ubu.py $(DESTDIR)/usr/bin/upgrade-ubu
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/if-speed $(DESTDIR)/usr/bin/if-speed
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/sys-suspend-on-lid.py $(DESTDIR)/usr/bin/sys-suspend-on-lid
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/encrypt-for-emailing $(DESTDIR)/usr/bin/encrypt-for-emailing
	install --owner=root --group=root --mode=644 --verbose $(DIR_ORIGIN)/settings/custom-exec-path.sh   $(DESTDIR)/etc/profile.d/custom-exec-path.sh
	install --owner=root --group=root --mode=755 --verbose $(DIR_ORIGIN)/settings/sys-suspend-on-lid.sh $(DESTDIR)/etc/init.d/sys-suspend-on-lid
	ln -s /etc/init.d/sys-suspend-on-lid $(DESTDIR)/etc/rc3.d/S07sys-suspend-on-lid

clean:
	echo "INFO:${0}:pid=${$}: Nothing to be done for cleanup after this DEB package build."
