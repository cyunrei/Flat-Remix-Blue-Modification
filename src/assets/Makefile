THEMES_ASSETS_DIR ?= $(patsubst %/index.theme,%/gnome-shell/assets/,$(wildcard ../../*/index.theme))
DEFAULT_THEME_COLOR = \#2777ff

.PHONY: build

build:
	rm -rf $(THEMES_ASSETS_DIR)
	mkdir -p $(THEMES_ASSETS_DIR)
	$(foreach theme_assets_dir, $(THEMES_ASSETS_DIR), cp *.svg $(theme_assets_dir) &&) true
	for theme_assets_dir in $(THEMES_ASSETS_DIR) ; \
	do \
		case $$theme_assets_dir in \
			*Flat-Remix-Blue*) \
				variant_color=\#2777ff ;; \
		esac ; \
		sed -i "s/$(DEFAULT_THEME_COLOR)/$$variant_color/" $$theme_assets_dir/* ; \
	done
