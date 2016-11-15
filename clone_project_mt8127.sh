#!/bin/bash
#
# Version 2.0
# this file is use for clone newproject form baseproject.(code controled by git,if controled by svn,you should delete .svn files else) 
# Android 6.0
# under alps and execute: 
# ./clone_8735m_android6_git.sh miki73_3909 zigo73_3909
#
BASE_PROJECT=$1
NEW_PROJECT=$2
COMPANY=mikimobile

#clone preloader
cp -r vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/${BASE_PROJECT} vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/${NEW_PROJECT}
mv vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/${NEW_PROJECT}/${BASE_PROJECT}.mk vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/${NEW_PROJECT}/${NEW_PROJECT}.mk
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g vendor/mediatek/proprietary/bootable/bootloader/preloader/custom/${NEW_PROJECT}/${NEW_PROJECT}.mk

#clone lk
cp vendor/mediatek/proprietary/bootable/bootloader/lk/project/${BASE_PROJECT}.mk vendor/mediatek/proprietary/bootable/bootloader/lk/project/${NEW_PROJECT}.mk
cp -r vendor/mediatek/proprietary/bootable/bootloader/lk/target/${BASE_PROJECT} vendor/mediatek/proprietary/bootable/bootloader/lk/target/${NEW_PROJECT}
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g vendor/mediatek/proprietary/bootable/bootloader/lk/project/${NEW_PROJECT}.mk
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g vendor/mediatek/proprietary/bootable/bootloader/lk/target/${NEW_PROJECT}/include/target/cust_usb.h
cp -r vendor/mediatek/proprietary/bootable/bootloader/lk/dev/logo/full_${BASE_PROJECT} vendor/mediatek/proprietary/bootable/bootloader/lk/dev/logo/full_${NEW_PROJECT}

#clone kernel
cp kernel-3.18/arch/arm/configs/${BASE_PROJECT}_defconfig kernel-3.18/arch/arm/configs/${NEW_PROJECT}_defconfig
cp kernel-3.18/arch/arm/configs/${BASE_PROJECT}_debug_defconfig kernel-3.18/arch/arm/configs/${NEW_PROJECT}_debug_defconfig
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g kernel-3.18/arch/arm/configs/${NEW_PROJECT}_defconfig
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g kernel-3.18/arch/arm/configs/${NEW_PROJECT}_debug_defconfig
cp kernel-3.18/arch/arm/boot/dts/${BASE_PROJECT}.dts kernel-3.18/arch/arm/boot/dts/${NEW_PROJECT}.dts
cp kernel-3.18/arch/arm/boot/dts/${BASE_PROJECT}_bat_setting.dtsi kernel-3.18/arch/arm/boot/dts/${NEW_PROJECT}_bat_setting.dtsi
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g kernel-3.18/arch/arm/boot/dts/${NEW_PROJECT}.dts
cp -r kernel-3.18/drivers/misc/mediatek/imgsensor/src/mt8127/camera_hw/camera_project/${BASE_PROJECT} kernel-3.18/drivers/misc/mediatek/imgsensor/src/mt8127/camera_hw/camera_project/${NEW_PROJECT}

#clone android
cp -r device/${COMPANY}/${BASE_PROJECT} device/${COMPANY}/${NEW_PROJECT}
mv device/${COMPANY}/${NEW_PROJECT}/full_${BASE_PROJECT}.mk device/${COMPANY}/${NEW_PROJECT}/full_${NEW_PROJECT}.mk
cp -r vendor/mediatek/proprietary/custom/${BASE_PROJECT} vendor/mediatek/proprietary/custom/${NEW_PROJECT}
# cp vendor/mediatek/proprietary/trustzone/custom/build/project/${BASE_PROJECT}.mk vendor/mediatek/proprietary/trustzone/custom/build/project/${NEW_PROJECT}.mk
#cp md32/md32/project/${BASE_PROJECT}.mk md32/md32/project/${NEW_PROJECT}.mk
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g device/${COMPANY}/${NEW_PROJECT}/*.*
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g vendor/mediatek/proprietary/custom/${NEW_PROJECT}/Android.mk

cd vendor/${COMPANY}/libs/
ln -sf ${BASE_PROJECT} ${NEW_PROJECT}
cd -

#clone bootanimation
cp frameworks/base/data/sounds/media/bootanimation/bootanimation_full_${BASE_PROJECT}.zip frameworks/base/data/sounds/media/bootanimation/bootanimation_full_${NEW_PROJECT}.zip
