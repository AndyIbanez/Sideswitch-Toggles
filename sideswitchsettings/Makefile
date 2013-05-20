ARCHS = armv7
include theos/makefiles/common.mk

BUNDLE_NAME = SideSwitchSettings
SideSwitchSettings_FILES = SideSwitchSettings.mm
SideSwitchSettings_INSTALL_PATH = /Library/PreferenceBundles
SideSwitchSettings_FRAMEWORKS = UIKit
SideSwitchSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CydeswitchSettings.plist$(ECHO_END)
