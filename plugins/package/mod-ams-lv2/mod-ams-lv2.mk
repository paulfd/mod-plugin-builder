######################################
#
# mod-ams-lv2
#
######################################

MOD_AMS_LV2_VERSION = fb021b0773fcb10984ab4b20c0402742f21308e1
MOD_AMS_LV2_SITE = $(call github,moddevices,ams-lv2,$(MOD_AMS_LV2_VERSION))
MOD_AMS_LV2_DEPENDENCIES = fftw lvtk-1
MOD_AMS_LV2_BUNDLES = mod-ams.lv2

MOD_AMS_LV2_TARGET_WAF = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(HOST_DIR)/usr/bin/python ./waf

define MOD_AMS_LV2_CONFIGURE_CMDS
        (cd $(@D); $(MOD_AMS_LV2_TARGET_WAF) configure --prefix=/usr)
endef

define MOD_AMS_LV2_BUILD_CMDS
        (cd $(@D); $(MOD_AMS_LV2_TARGET_WAF) build -j $(PARALLEL_JOBS))
endef

define MOD_AMS_LV2_INSTALL_TARGET_CMDS
        (cd $(@D); $(MOD_AMS_LV2_TARGET_WAF) install --destdir=$(TARGET_DIR))
endef

$(eval $(generic-package))
