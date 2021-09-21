SCSS=sassc
BASE_THEME ?= ../../Flat-Remix-Blue-fullPanel-Mod-by-Cyunrei

.PHONY: build clean

build:
	cp $(BASE_THEME)/gnome-shell/gnome-shell.css gnome-shell.css
	cp ../sass/gnome-shell-sass/upstream/pad-osd.css .
	sed "s/assets/resource:\/\/\/org\/gnome\/shell\/theme/g" -i *.css
	glib-compile-resources gnome-shell-theme.gresource.xml

clean:
	rm *.css
