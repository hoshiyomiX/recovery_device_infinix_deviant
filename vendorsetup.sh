#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2025 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

FDEVICE="deviant"
#set -o xtrace

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
	export TW_DEFAULT_LANGUAGE="en"
	export LC_ALL="C"
	export ALLOW_MISSING_DEPENDENCIES=true

	# Partition paths
	export FOX_RECOVERY_INSTALL_PARTITION="/dev/block/platform/bootdevice/by-name/recovery"
	export FOX_RECOVERY_BOOT_PARTITION="/dev/block/platform/bootdevice/by-name/boot"

	# A/B device
	export FOX_AB_DEVICE=1
	export FOX_VIRTUAL_AB_DEVICE=1
	export BOARD_USES_RECOVERY_AS_BOOT=1
	export TARGET_NO_RECOVERY=1

	# Alternate Codenames
	export TARGET_DEVICE_ALT="X695C,X695D,X695,Infinix-X695C,Infinix-X695D"

	# OrangeFox Settings
	export OF_USE_GREEN_LED=0
	export OF_FLASHLIGHT_ENABLE=0
	export OF_HIDE_NOTCH=1
	export OF_DISABLE_OTA_MENU=1
	export OF_ALLOW_DISABLE_NAVBAR=0
	export OF_QUICK_BACKUP_RESTORE=1
	export OF_PATCH_BOOTIMAGE=false

	# Magiskboot
	export OF_USE_MAGISKBOOT=1
	export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
	export OF_NEW_MAGISKBOOT=1

	# Encryption
	export OF_DISABLE_FORCED_ENCRYPTION=1
	export OF_DISABLE_DM_VERITY_FORCED_ENCRYPTION=1
	export OF_SKIP_FBE_DECRYPTION_SDKVERSION=31
	export OF_DONT_PATCH_ENCRYPTED_DEVICE=true
	export OF_SUPPORT_HW_ENCRYPTION=1
	export OF_SUPPORT_FBE_DECRYPT=1
	export OF_SUPPORT_FBE_V2=true
	export OF_FIX_DECRYPTION_ON_DATA_MEDIA=1

	# AVB & OTA
	export OF_PATCH_AVB20=1
	export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
	export OF_KEEP_DM_VERITY=1
	export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
	export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1

	# Tools
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_USE_NANO_EDITOR=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_ENABLE_APP_MANAGER=1

	# Build info
	export FOX_VERSION="R11.3"
	export FOX_BUILD_TYPE="unofficial"
	export FOX_VARIANT="XOS-V590"
	export OF_MAINTAINER="excaliburXD"

	# Screen Settings
	export OF_SCREEN_H=2400
	export OF_STATUS_H=100
	export OF_STATUS_INDENT_LEFT=52
	export OF_STATUS_INDENT_RIGHT=52
	export OF_CLOCK_POS=1

	# Backup
	export OF_QUICK_BACKUP_LIST="/boot;/data;"
	export OF_SKIP_MULTIUSER_FOLDERS_BACKUP="1"
	export OF_RUN_POST_FORMAT_PROCESS=1

	# Backup
	export OF_QUICK_BACKUP_LIST="/boot;/data;"
	export OF_SKIP_MULTIUSER_FOLDERS_BACKUP="1"
	export OF_RUN_POST_FORMAT_PROCESS=1
	export OF_SKIP_ORANGEFOX_PROCESS=1

	# Dynamic partitions
	export OF_DYNAMIC_PARTITION_SUPPORT=1
	export TW_USE_FSCRYPT_POLICY=1
	export BOARD_USES_METADATA_PARTITION=1

	# ARB workaround
	export FOX_BUGGED_AOSP_ARB_WORKAROUND="1546300800"

	# OrangeFox 12.1 specific
	export FOX_REPLACE_TOOLBOX_GETPROP=1
	export OF_NO_LEGACY_FILES=1
	export OF_FORCE_PREBUILT_KERNEL=1

	# log
	if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
		export | grep "FOX" >> $FOX_BUILD_LOG_FILE
		export | grep "OF_" >> $FOX_BUILD_LOG_FILE
		export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
		export | grep "TW_" >> $FOX_BUILD_LOG_FILE
	fi
fi
#
