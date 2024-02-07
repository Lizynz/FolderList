export ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = folderlistprefs

folderlistprefs_FILES = FLPRootListController.m
folderlistprefs_INSTALL_PATH = /Library/PreferenceBundles
folderlistprefs_FRAMEWORKS = UIKit
folderlistprefs_PRIVATE_FRAMEWORKS = Preferences
folderlistprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/folderlistprefs.plist$(ECHO_END)
