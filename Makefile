TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

ARCHS = arm64 arm64e armv7 armv7s

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = cRaZyTeXt

cRaZyTeXt_FILES = Tweak.x TextUtils.m PrefsUtils.m
cRaZyTeXt_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += crazyprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
