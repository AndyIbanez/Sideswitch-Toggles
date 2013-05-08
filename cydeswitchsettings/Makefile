ARCHS = armv7
include theos/makefiles/common.mk

BUNDLE_NAME = CydeswitchSettings
CydeswitchSettings_FILES = CydeswitchSettings.mm
CydeswitchSettings_INSTALL_PATH = /Library/PreferenceBundles
CydeswitchSettings_FRAMEWORKS = UIKit
CydeswitchSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CydeswitchSettings.plist$(ECHO_END)
