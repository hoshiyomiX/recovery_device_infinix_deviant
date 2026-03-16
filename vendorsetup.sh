#!/bin/bash

# ============================================
# LOCALE & DEVICE CONFIGURATION
# ============================================

export LC_ALL="C"
export TARGET_DEVICE_ALT="X695D,X695,Infinix-X695D,Infinix-X695"
export FOX_TARGET_DEVICES="X695C,deviant,Infinix-X695C"

# ============================================
# PARTITION CONFIGURATION
# ============================================

export FOX_RECOVERY_BOOT_PARTITION="/dev/block/platform/bootdevice/by-name/boot"
export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/by-name/system"
export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/by-name/vendor"
export FOX_RECOVERY_SYSTEM_EXT_PARTITION="/dev/block/by-name/system_ext"
export FOX_RECOVERY_PRODUCT_PARTITION="/dev/block/by-name/product"

# ============================================
# DEVICE PARTITION SETUP
# ============================================

export FOX_AB_DEVICE=1
export FOX_VIRTUAL_AB_DEVICE=1
export BOARD_USES_METADATA_PARTITION=1
export OF_DYNAMIC_PARTITION_SUPPORT=1
export TW_USE_FSCRYPT_POLICY=1
export BOARD_USES_RECOVERY_AS_BOOT=1
export TARGET_NO_RECOVERY=1
export OF_QUICK_BACKUP_RESTORE=1
export OF_PATCH_BOOTIMAGE=false

# ============================================
# SIZE REDUCTION (32MB Boot Partition)
# ============================================

export FOX_DRASTIC_SIZE_REDUCTION=1

# Disable vendor-specific features
export FOX_NO_SAMSUNG_SPECIAL=true
export FOX_NO_MIUI_SPECIAL=true
export FOX_NO_MIUI_PATCH=true

# Language & Theme (minimal)
export FOX_DEFAULT_LANGUAGE="en"
export FOX_ENABLE_MULTILANG=0
export FOX_THEME="FOX_THEME_DEFAULT"

# ============================================
# ESSENTIAL FEATURES
# ============================================

# Magisk support (required for boot patching)
export OF_USE_MAGISKBOOT=1
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=0
export OF_NEW_MAGISKBOOT=1
export FOX_BUILD_MAGISK=0

# Recovery image builder
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1

# AVB & Treble
export OF_PATCH_AVB20=1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1

# Encryption & Decryption (CRITICAL)
export OF_DISABLE_FORCED_ENCRYPTION=1
export OF_DISABLE_DM_VERITY_FORCED_ENCRYPTION=1
export OF_SKIP_FBE_DECRYPTION_SDKVERSION=31
export OF_DONT_PATCH_ENCRYPTED_DEVICE=true
export OF_SUPPORT_HW_ENCRYPTION=1
export OF_SUPPORT_FBE_DECRYPT=1
export OF_SUPPORT_FBE_V2=true
export OF_FIX_DECRYPTION_ON_DATA_MEDIA=1

# Security
export FOX_BUGGED_AOSP_ARB_WORKAROUND="1546300800"
export OF_KEEP_DM_VERITY=1

# Logging (keep for debugging)
export TW_INCLUDE_LOGD=true

# Legacy props & Screen
export TW_NO_LEGACY_PROPS=true
export TW_NO_SCREEN_BLANK=true

# ============================================
# BUILD METADATA
# ============================================

export FOX_BUILD_TYPE="Unofficial-Minimal"
export FOX_VARIANT="XOS-V590"
export OF_MAINTAINER="excaliburXD"

# ============================================
# UI CONFIGURATION
# ============================================

export OF_USE_GREEN_LED=0
export OF_FLASHLIGHT_ENABLE=0
export OF_ALLOW_DISABLE_NAVBAR=0
export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1

# Screen layout
export OF_SCREEN_H=2400
export OF_STATUS_H=100
export OF_STATUS_INDENT_LEFT=52
export OF_STATUS_INDENT_RIGHT=52
export OF_CLOCK_POS=1

# ============================================
# BACKUP CONFIGURATION
# ============================================

export OF_QUICK_BACKUP_LIST="/boot;/data;"
export OF_RUN_POST_FORMAT_PROCESS=1
export OF_SKIP_ORANGEFOX_PROCESS=1
