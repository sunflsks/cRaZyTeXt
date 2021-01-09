TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

ARCHS = armv7 armv7s arm64 arm64e
BUNDLE_NAME = crazyprefs

crazyprefs_FILES = CRPRootListController.m
crazyprefs_FRAMEWORKS = UIKit
crazyprefs_PRIVATE_FRAMEWORKS = Preferences
crazyprefs_INSTALL_PATH = /Library/PreferenceBundles
crazyprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
