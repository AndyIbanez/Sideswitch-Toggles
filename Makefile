ARCHS = armv7
include theos/makefiles/common.mk

TWEAK_NAME = Cydeswitch
Cydeswitch_FILES = Tweak.xm

SUBPROJECTS = cydeswitchsettings
include theos/makefiles/aggregate.mk

include $(THEOS_MAKE_PATH)/tweak.mk
