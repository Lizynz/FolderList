export ARCHS = arm64 arm64e
GO_EASY_ON_ME = 1
PACKAGE_VERSION = 1.0

TARGET = iphone:clang:14.2
THEOS_LAYOUT_DIR_NAME = layout-rootless
THEOS_PACKAGE_SCHEME = rootless

export SYSROOT = $(THEOS)/sdks/iPhoneOS14.2.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FolderList

FolderList_FILES = Tweak.xm FLIconEntry.m FLTableViewCell.m
FolderList_CFLAGS = -O3 -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += folderlistprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
