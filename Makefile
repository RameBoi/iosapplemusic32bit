# SDK folder version Theos should use (the workflow sets MC_SDK automatically)
MC_SDK ?= 9.3
TARGET := iphone:clang:$(MC_SDK):8.0
ARCHS = armv7
DEBUG = 0
FINALPACKAGE = 1
INSTALL_TARGET_PROCESSES = MusicClone

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = MusicClone

MusicClone_FILES = main.m AppDelegate.m Theme.m Library.m Player.m \
	RootViewController.m SidebarViewController.m AlbumGridViewController.m \
	TrackListViewController.m GroupListViewController.m \
	MiniPlayerView.m NowPlayingViewController.m PlaceholderViewController.m
MusicClone_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore MediaPlayer AVFoundation
MusicClone_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

# Xcode 15+ uses a new linker that dropped 32-bit iOS; workflow sets LD_CLASSIC=1 for it
ifeq ($(LD_CLASSIC),1)
MusicClone_LDFLAGS += -ld_classic
endif

include $(THEOS_MAKE_PATH)/application.mk
