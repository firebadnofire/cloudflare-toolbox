all:
	@echo RUN \'make install\' to install the scripts
	@echo RUN \'make uninstall\' or \'make deinstall\' to uninstall the scripts
	@echo RUN \'make reinstall\' or \'make update\' to update after running \'git pull\'

install:
	install -m 555 cfgetauth /usr/local/bin
	install -m 555 cflocate /usr/local/bin
	install -m 555 cfplace /usr/local/bin
	install -m 555 cfremove /usr/local/bin
	install -m 555 cfsetauth /usr/local/bin
	install -m 555 cfdelauth /usr/local/bin

deinstall:
	rm /usr/local/bin/cfgetauth
	rm /usr/local/bin/cflocate
	rm /usr/local/bin/cfplace
	rm /usr/local/bin/cfremove
	rm /usr/local/bin/cfsetauth
	rm /usr/local/bin/cfdelauth

uninstall:
	rm /usr/local/bin/cfgetauth
	rm /usr/local/bin/cflocate
	rm /usr/local/bin/cfplace
	rm /usr/local/bin/cfremove
	rm /usr/local/bin/cfsetauth
	rm /usr/local/bin/cfdelauth

reinstall:
	rm /usr/local/bin/cfgetauth
	rm /usr/local/bin/cflocate
	rm /usr/local/bin/cfplace
	rm /usr/local/bin/cfremove
	rm /usr/local/bin/cfsetauth
	rm /usr/local/bin/cfdelauth
	install -m 555 cfgetauth /usr/local/bin
	install -m 555 cflocate /usr/local/bin
	install -m 555 cfplace /usr/local/bin
	install -m 555 cfremove /usr/local/bin
	install -m 555 cfsetauth /usr/local/bin
	install -m 555 cfdelauth /usr/local/bin

update:
	rm /usr/local/bin/cfgetauth
	rm /usr/local/bin/cflocate
	rm /usr/local/bin/cfplace
	rm /usr/local/bin/cfremove
	rm /usr/local/bin/cfsetauth
	rm /usr/local/bin/cfdelauth
	install -m 555 cfgetauth /usr/local/bin
	install -m 555 cflocate /usr/local/bin
	install -m 555 cfplace /usr/local/bin
	install -m 555 cfremove /usr/local/bin
	install -m 555 cfsetauth /usr/local/bin
	install -m 555 cfdelauth /usr/local/bin
