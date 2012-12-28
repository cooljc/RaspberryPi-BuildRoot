RASPIR_VERSION = 25dea38d1c0d6f9210f7d0786aeb03077a7c17b3
RASPIR_SITE = git://github.com/cooljc/raspir.git
RASPIR_SITE_METHOD = git
RASPIR_DEPENDENCIES = linux

RASPIR_MAKE_FLAGS = \
	HOSTCC="$(HOSTCC)" \
	HOSTCFLAGS="$(HOSTCFLAGS)" \
	ARCH=$(KERNEL_ARCH) \
	INSTALL_MOD_PATH=$(TARGET_DIR) \
	CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \
	DEPMOD=$(HOST_DIR)/usr/sbin/depmod

define RASPIR_CONFIGURE_CMDS
	$(RASPIR_MAKE_FLAGS) $(MAKE) -C $(LINUX_DIR) SUBDIRS=$(@D) clean
endef

define RASPIR_BUILD_CMDS
	$(RASPIR_MAKE_FLAGS) $(MAKE) -C $(LINUX_DIR) SUBDIRS=$(@D) modules
	# Build test tool
	$(RASPIR_MAKE_FLAGS) $(MAKE) -C $(@D)/test
endef

define RASPIR_INSTALL_TARGET_CMDS
	$(INSTALL) -m 664 $(@D)/raspir.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/drivers/media/rc/
	$(INSTALL) -m 755 $(@D)/test/raspir-test $(TARGET_DIR)/usr/bin/
#TODO: call depmod
endef

define RASPIR_UNINSTALL_TARGET_CMDS

endef

$(eval $(generic-package))