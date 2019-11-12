######################################
#
# wolf-shaper
#
######################################

WOLF_SHAPER_VERSION = d0b46c9ece642488efed3cd255df22516966b334
WOLF_SHAPER_SITE = $(call github,pdesaulniers,wolf-shaper,$(WOLF_SHAPER_VERSION))
WOLF_SHAPER_BUNDLES = wolf-shaper.lv2

WOLF_SHAPER_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) BUILD_LV2=true HAVE_DGL=false NOOPT=true -C $(@D)

# needed for git submodules
define WOLF_SHAPER_EXTRACT_CMDS
	rm -rf $(@D)
	git clone --recursive git://github.com/pdesaulniers/wolf-shaper $(@D)
	(cd $(@D) && \
		git reset --hard $(WOLF_SHAPER_VERSION) && \
		git submodule update)
	touch $(@D)/.stamp_downloaded
endef

define WOLF_SHAPER_BUILD_CMDS
	$(WOLF_SHAPER_TARGET_MAKE)
endef

define WOLF_SHAPER_INSTALL_TARGET_CMDS
	cp -r $(@D)/bin/*.lv2 $(TARGET_DIR)/usr/lib/lv2/
endef

$(eval $(generic-package))
