MAINTAINER = Cyunrei <cyunrei@gmail.com>
PREFIX ?= /usr
THEMES ?= $(patsubst %/index.theme,%,$(wildcard */index.theme))
BASE_THEME ?= Flat-Remix-Blue-fullPanel-Mod-by-Cyunrei
BLUR ?= 2
IS_UBUNTU ?= $(shell echo "$$(lsb_release -si 2> /dev/null)" | grep -q 'Ubuntu\|Pop' && echo true)
USER_HOME ?= $(shell eval echo ~$$SUDO_USER)
USER_THEMES_DIR = $(USER_HOME)/.themes

# !! Patch for pamac
# Pamac installs packages as root, no 'sudo' (due to pkexec), so dconf is unable
# to get the user's background. As a workaround HOME env is set to the home
# directory of the user with uid 1000, which probably will be the main user.
ifeq ($(USER_HOME),/root)
	USER_HOME = $(shell eval echo ~$(shell cut -d: -f1,3 /etc/passwd | grep -Po '.*(?=:1000)'))
endif


all: _get_login_background
	-if [ ! -z "$(LOGIN_BACKGROUND)" ] && [ "$(suffix $(LOGIN_BACKGROUND))" != ".xml" ] ; \
	then \
		if [ $(BLUR) -le 1 ] ;\
		then \
			cp -f "$(LOGIN_BACKGROUND)" src/gresource/login-background ;\
		else \
			convert -scale 10% -gaussian-blur 0x$(BLUR) -resize 1000% "$(LOGIN_BACKGROUND)" src/gresource/login-background ;\
		fi; \
	fi
	make -C src/gresource build

_get_login_background:
	$(eval SHELL:=/bin/bash)
	$(eval LOGIN_BACKGROUND ?= \
		$(shell printf "%b" "$$(\
			HOME=$(USER_HOME) dconf read /org/gnome/desktop/background/picture-uri | \
			sed -e 's/file:\/\///' -e 's/%/\\x/g' -e s/\'//g)"))
	@echo "$(LOGIN_BACKGROUND)"

build:
	$(MAKE) -C src build

install:
ifeq ($(DESTDIR),)
	mkdir -p $(PREFIX)/share/themes/
	cp -r $(THEMES) $(PREFIX)/share/themes/
	cp -r share/ $(PREFIX)/
	glib-compile-schemas $(PREFIX)/share/glib-2.0/schemas/
	mkdir -p $(PREFIX)/share/gnome-shell/theme/
	@ln -sfv $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/ $(PREFIX)/share/gnome-shell/theme/$(BASE_THEME)
    ifeq ($(IS_UBUNTU), true)
		cp src/gresource/gnome-shell-theme.gresource $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/gnome-shell-theme.gresource
		update-alternatives --install $(PREFIX)/share/gnome-shell/gdm3-theme.gresource gdm3-theme.gresource $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/gnome-shell-theme.gresource 100
    else
		mv -n $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource.old
		cp -f src/gresource/gnome-shell-theme.gresource $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource
    endif
else
	mkdir -p $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/
	cp -a Makefile $(THEMES) src share $(DESTDIR)$(PREFIX)/share/$(PKGNAME)/
endif

uninstall:
	-rm -rf $(foreach theme, $(THEMES), $(PREFIX)/share/themes/$(theme))
	-rm -f $(foreach file, $(shell find share/ -type f), $(PREFIX)/$(file))
	-rm -f $(PREFIX)/share/gnome-shell/theme/$(BASE_THEME)
ifeq ($(IS_UBUNTU), true)
	-update-alternatives --remove gdm3-theme.gresource $(PREFIX)/share/themes/$(BASE_THEME)/gnome-shell/gnome-shell-theme.gresource
else
	-mv $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource.old $(PREFIX)/share/gnome-shell/gnome-shell-theme.gresource
endif

install_user:
	mkdir -p $(USER_THEMES_DIR)
	cp -r $(BASE_THEME) $(USER_THEMES_DIR)

uninstall_user:
	rm -rf $(USER_THEMES_DIR)/$(BASE_THEME)

.PHONY: all _get_login_background build install uninstall install_user uninstall_user
