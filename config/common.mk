PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1 \
    persist.sys.root_access=1 

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/illusion/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/illusion/prebuilt/common/bin/50-illusion.sh:system/addon.d/50-illusion.sh \
    vendor/illusion/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/illusion/prebuilt/common/etc/backup.conf:system/etc/backup.conf

# ILLUSION-specific init file
PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/etc/init.local.rc:root/init.illusion.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so

# Compcache/Zram support
PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/bin/compcache:system/bin/compcache \
    vendor/illusion/prebuilt/common/bin/handle_compcache:system/bin/handle_compcache

# Audio Config for DSPManager
PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/vendor/etc/audio_effects.conf:system/vendor/etc/audio_effects.conf
#LOCAL ILLUSION CHANGES  - END

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/illusion/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/illusion/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/illusion/prebuilt/common/bin/sysinit:system/bin/sysinit

# Prebuilt packages
PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/app/Blue.apk:system/app/Blue.apk
PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/app/NovaLauncher.apk:system/app/NovaLauncher.apk

# Embed SuperUser
SUPERUSER_EMBEDDED := true

# Required packages
PRODUCT_PACKAGES += \
    Focal \
    Development \
    LatinIME \
    SpareParts \
    Superuser \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    HoloSpiralWallpaper \
    NoiseField \
    Galaxy4 \
    LiveWallpapersPicker \
    PhaseBeam

# Extra Optional packages
PRODUCT_PACKAGES += \
    audio_effects.conf \
    CMAccount \
    DSPManager \
    FileManager \
    HALO \
    LatinIME \
    libcyanogen-dsp \
    LockClock \
    RoundR \
    VoicePlus

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra tools
PRODUCT_PACKAGES += \
    AndroidASync \
    openvpn \
    e2fsck \
    exfat \
    gson \
    ion \
    mke2fs \
    tune2fs

PRODUCT_PACKAGE_OVERLAYS += vendor/illusion/overlay/common

# T-Mobile theme engine
include vendor/illusion/config/themes_common.mk

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/illusion/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

PRODUCT_COPY_FILES += \
    vendor/illusion/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif

# version
RELEASE = false
ILLUSION_VERSION_MAJOR = 2
ILLUSION_VERSION_MINOR = 5
ILLUSION_VERSION_MAINTENANCE = beta

# state
ifeq ($(RELEASE),true)
    ILLUSION_VERSION_STATE := OFFICIAL
    ILLUSION_VERSION := $(TARGET_PRODUCT)-$(ILLUSION_VERSION_MAJOR).$(ILLUSION_VERSION_MINOR).$(ILLUSION_VERSION_MAINTENANCE)-$(ILLUSION_VERSION_STATE)
else
    ILLUSION_VERSION_STATE := UNOFFICIAL
    ILLUSION_VERSION := $(TARGET_PRODUCT)-$(ILLUSION_VERSION_MAJOR).$(ILLUSION_VERSION_MINOR).$(ILLUSION_VERSION_MAINTENANCE)-$(ILLUSION_VERSION_STATE)
endif

# product
PRODUCT_PROPERTY_OVERRIDES += \
    ro.illusion.version=$(ILLUSION_VERSION) \
    ro.modversion=$(ILLUSION_VERSION)

-include vendor/illusion/sepolicy/sepolicy.mk
