ARCHS = armv7
include theos/makefiles/common.mk

TWEAK_NAME = Sideswitch
Sideswitch_FILES = Tweak.xm

SUBPROJECTS = sideswitchsettings
include theos/makefiles/aggregate.mk

include $(THEOS_MAKE_PATH)/tweak.mk
