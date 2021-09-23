VERSION = 2.1
PN = kodi-logger

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
INITDIR_SYSTEMD = /usr/lib/systemd/system

RM = rm
SED = sed
INSTALL = install -p
INSTALL_PROGRAM = $(INSTALL) -m755
INSTALL_DATA = $(INSTALL) -m644
INSTALL_DIR = $(INSTALL) -d
RM = rm
Q = @

common/$(PN): common/$(PN).in
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)$(SED) 's/@VERSION@/'$(VERSION)'/' common/$(PN).in > common/$(PN)

install-bin:
	$(Q)echo -e '\033[1;32mInstalling main script...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(BINDIR)"
	$(INSTALL_PROGRAM) common/$(PN) "$(DESTDIR)$(BINDIR)/$(PN)"

install-systemd:
	$(Q)echo -e '\033[1;32mInstalling systemd files...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(INITDIR_SYSTEMD)"
	$(INSTALL_DATA) init/$(PN).service "$(DESTDIR)$(INITDIR_SYSTEMD)/$(PN).service"
	$(INSTALL_DATA) init/$(PN).timer "$(DESTDIR)$(INITDIR_SYSTEMD)/$(PN).timer"

install: install-bin install-systemd

uninstall:
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(Q)$(RM) "$(DESTDIR)$(INITDIR_SYSTEMD)/$(PN).service"
	$(Q)$(RM) "$(DESTDIR)$(INITDIR_SYSTEMD)/$(PN).timer"

.PHONY: uninstall install install-systemd install-bin
