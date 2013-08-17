# Inherit common stuff
$(call inherit-product, vendor/illusion/config/common.mk)

PRODUCT_PACKAGE_OVERLAYS += vendor/illusion/overlay/tablet

# BT config
PRODUCT_COPY_FILES += \
    system/bluetooth/data/main.nonsmartphone.conf:system/etc/bluetooth/main.conf
