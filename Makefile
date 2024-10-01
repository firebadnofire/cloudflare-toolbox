all:
	@echo RUN \'make install\' to install the scripts
	@echo RUN \'make uninstall\' or \'make deinstall\' to uninstall the scripts

install:
	install -m 555 cfgetauth /usr/local/bin
	install -m 555 cflocate /usr/local/bin
	install -m 555 cfplace /usr/local/bin
	install -m 555 cfremove /usr/local/bin
	install -m 555 cfsetauth /usr/local/bin

deinstall:
	rm /usr/local/bin/cfgetauth
	rm /usr/local/bin/cflocate
	rm /usr/local/bin/cfplace
	rm /usr/local/bin/cfremove
	rm /usr/local/bin/cfsetauth

uninstall:
        rm /usr/local/bin/cfgetauth
        rm /usr/local/bin/cflocate
        rm /usr/local/bin/cfplace
        rm /usr/local/bin/cfremove
        rm /usr/local/bin/cfsetauth
