# Inherit common stuff
$(call inherit-product, vendor/illusion/config/common.mk)

# BT config
PRODUCT_COPY_FILES += \
    system/bluetooth/data/main.conf:system/etc/bluetooth/main.conf
