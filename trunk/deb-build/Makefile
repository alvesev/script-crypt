#!/usr/bin/make -f

DIR_ORIGIN = ../src
DIR_BASE_INSTALL = /opt/script-crypt

all: install

install:
	bash installer.sh "${DIR_ORIGIN}" "${DIR_BASE_INSTALL}" $(DESTDIR)
clean:
	echo "INFO:${0}:pid=${$}: Nothing to be done for cleanup after this DEB package build."
