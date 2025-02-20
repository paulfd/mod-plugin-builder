######################################
#
# juce
#
######################################

JUCE_VERSION = 18e46d57249931ee929047bfd5978f3a1ab40dc1
JUCE_VERSION_PROJECT = JUCE-6.0.7
JUCE_SITE = $(call github,DISTRHO,juce,$(JUCE_VERSION))
JUCE_DEPENDENCIES = host-juce freetype
JUCE_INSTALL_STAGING = YES
HOST_JUCE_DEPENDENCIES = host-cmake host-freetype host-xlib_libX11

# this custom configure follows the same rules as buildroot, with these exceptions:
# - CMAKE_FIND_ROOT_PATH_MODE_PROGRAM="ONLY" (buildroot uses "NEVER")
# - CMAKE_MAKE_PROGRAM="/usr/bin/make" (not needed in buildroot, only for juce)
# - PKG_CONFIG related env vars (buildroot unsets them for the build)
define HOST_JUCE_CONFIGURE_CMDS
	(mkdir -p $(@D) && cd $(@D) && rm -f CMakeCache.txt && \
		env PKG_CONFIG_SYSROOT_DIR="$(HOST_DIR)" PKG_CONFIG_PATH="$(HOST_DIR)/usr/lib/pkgconfig" \
		$(HOST_DIR)/usr/bin/cmake $(@D) \
		-DCMAKE_INSTALL_PREFIX=$(HOST_DIR)/usr \
		-DCMAKE_INSTALL_SO_NO_EXE=0 \
		-DCMAKE_FIND_ROOT_PATH="$(HOST_DIR)" \
		-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM="ONLY" \
		-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE="ONLY" \
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE="ONLY" \
		-DCMAKE_MAKE_PROGRAM="/usr/bin/make" \
		-DCMAKE_C_COMPILER="$(HOSTCC)" \
		-DCMAKE_CXX_COMPILER="$(HOSTCXX)" \
		-DCMAKE_CXX_FLAGS="-I$(HOST_DIR)/usr/include -DJUCE_USE_XCURSOR=0 -DJUCE_USE_XINERAMA=0 -DJUCE_USE_XRANDR=0 -DJUCE_USE_XSHM=0" \
		-DJUCE_BUILD_HELPER_TOOLS=ON \
		-DJUCE_INSTALL_DESTINATION=lib/cmake/JUCE \
	)
endef

define HOST_JUCE_POST_INSTALL_JUCEAIDE
	$(INSTALL) -m 755 $(@D)/extras/Build/juceaide/juceaide_artefacts/juceaide $(HOST_DIR)/usr/bin/
	$(INSTALL) -m 644 $(@D)/extras/Build/CMake/lv2_ttl_generator.c $(HOST_DIR)/usr/lib/cmake/JUCE/
	$(INSTALL) -m 644 $($(PKG)_PKGDIR)/toolchainfile.cmake $(HOST_DIR)/usr/lib/cmake/JUCE/
endef

define JUCE_INSTALL_STAGING_CMDS
	install -d $(STAGING_DIR)/usr/include
	install -d $(STAGING_DIR)/usr/lib/cmake
	cp $(HOST_DIR)/usr/bin/juceaide $(STAGING_DIR)/usr/bin/
	cp -r $(HOST_DIR)/usr/include/$(JUCE_VERSION_PROJECT) $(STAGING_DIR)/usr/include/
	cp -r $(HOST_DIR)/usr/lib/cmake/JUCE $(STAGING_DIR)/usr/lib/cmake/
	sed -i -e 's|/host/|/staging/|' $(STAGING_DIR)/usr/lib/cmake/JUCE/JUCEConfig.cmake
	sed -i -e 's|juce::juceaide|juceaide|' $(STAGING_DIR)/usr/lib/cmake/JUCE/*.cmake
endef

HOST_JUCE_POST_INSTALL_HOOKS += HOST_JUCE_POST_INSTALL_JUCEAIDE

$(eval $(generic-package))
$(eval $(host-cmake-package))
