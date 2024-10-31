# List of scripts
SCRIPTS = cfgetauth cflocate cfplace cfremove cfsetauth cfdelauth cfswitchauth

# Installation paths
PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

.PHONY: all help install uninstall reinstall update

all: help

help:
	@echo "Available targets:"
	@echo "  install       - Install the scripts"
	@echo "  uninstall     - Uninstall the scripts"
	@echo "  reinstall     - Uninstall and then install the scripts"
	@echo "  update        - Alias for 'reinstall'"

install: $(SCRIPTS)
	@echo "Installing scripts to $(BINDIR)"
	install -d $(BINDIR)
	for script in $(SCRIPTS); do \
		install -m 755 $$script $(BINDIR); \
	done

uninstall:
	@echo "Uninstalling scripts from $(BINDIR)"
	for script in $(SCRIPTS); do \
		rm -f $(BINDIR)/$$script; \
	done

reinstall: uninstall install

update: reinstall
