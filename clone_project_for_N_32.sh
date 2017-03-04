#!/bin/bash
#
# Version 1.0
# this file is use for clone newproject form baseproject.(code controled by git,if controled by svn,you should delete .svn files else) 
# Android 7.0
# under alps and execute: 
# ./clone_project_for_N.sh  BASE_PROJECT NEW_PROJECT
#
if [ "-$2" = "-" ]; then
    echo "[01] Error: need two parameters"
    exit 1
fi

ALPS=$PWD
BASE_PROJECT=$1
NEW_PROJECT=$2
NEW_FILES=" "

if [ ! -f build/core/version_defaults.mk ];then
    echo "[02] Error: can not read android version"
    echo "please try again in alps directory"
    exit 2
fi

# read android version from file
while read line
do
    name=`echo $line|awk -F ':=' '{print $1}'`
    value=`echo $line|awk -F ':=' '{print $2}'`
    case $name in
	"PLATFORM_VERSION ") Version=$value; break;;
    esac
done  < build/core/version_defaults.mk

if [ ${Version} != "7.0" ]; then
    echo "[03] Error: android version need 7.0"
    exit 3
fi

echo ">>>>>> Begin to Clone Project <<<<<<"
echo  `date`
echo
echo "Android Version: $Version"

COMPANY=mikimobile
KERNEL=kernel-3.18
LK=vendor/mediatek/proprietary/bootable/bootloader/lk
PRELOADER=vendor/mediatek/proprietary/bootable/bootloader/preloader
PROJECTDIR=device/mikimobile
HAL=vendor/mediatek/proprietary/custom

echo "Base project: $BASE_PROJECT"
echo "New project: $NEW_PROJECT"
echo "$BASE_PROJECT  ==>  $NEW_PROJECT" 

# Test whether BASE PROJECT and NEW PROJECT exist or not
if [ -d ${PROJECTDIR}/${BASE_PROJECT} ]; then
  if [ -d ${PROJECTDIR}/${NEW_PROJECT} ]; then 
    echo "[04] Error: ${NEW_PROJECT} is exist"
    exit 4
  fi
else 
  echo "[04] Error: ${BASE_PROJECT} is not exist"
  exit 4
fi

echo "Clone preloader:"
if [ -d ${PRELOADER}/custom/${NEW_PROJECT} ]; then
    echo "Warning: preloader of ${NEW_PROJECT} is exist"
    echo "Skip preloader"
else
    cp -r ${PRELOADER}/custom/${BASE_PROJECT} ${PRELOADER}/custom/${NEW_PROJECT}
    echo "Create   ${PRELOADER}/custom/${NEW_PROJECT}"
    NEW_FILES="${NEW_FILES} ${PRELOADER}/custom/${NEW_PROJECT}"
    mv ${PRELOADER}/custom/${NEW_PROJECT}/${BASE_PROJECT}.mk ${PRELOADER}/custom/${NEW_PROJECT}/${NEW_PROJECT}.mk
    sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${PRELOADER}/custom/${NEW_PROJECT}/${NEW_PROJECT}.mk
fi

echo "Clone lk"
if [ -d ${LK}/target/${NEW_PROJECT} ]; then
    echo "Warning: lk of ${NEW_PROJECT} is exit"
    echo "Skip lk"
else
    cp -r ${LK}/target/${BASE_PROJECT} ${LK}/target/${NEW_PROJECT}
    echo "Create  ${LK}/target/${NEW_PROJECT}"
    NEW_FILES="${NEW_FILES} ${LK}/target/${NEW_PROJECT}"
    sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${LK}/target/${NEW_PROJECT}/include/target/cust_usb.h
    cp ${LK}/project/${BASE_PROJECT}.mk ${LK}/project/${NEW_PROJECT}.mk
    echo "Create  ${LK}/project/${NEW_PROJECT}.mk"
    NEW_FILES="${NEW_FILES} ${LK}/project/${NEW_PROJECT}.mk"
    sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${LK}/project/${NEW_PROJECT}.mk
fi

echo "Clone kernel"
if [ -f ${KERNEL}/arch/arm/configs/${NEW_PROJECT}_defconfig ]; then
    echo "Warning: kernel of ${NEW_PROJECT} is exit"
    echo "Skip kernel"
else
    #cp -r kernel-3.18/drivers/misc/mediatek/mach/mt6735/${BASE_PROJECT} kernel-3.18/drivers/misc/mediatek/mach/mt6735/${NEW_PROJECT}
    cp ${KERNEL}/arch/arm/configs/${BASE_PROJECT}_defconfig ${KERNEL}/arch/arm/configs/${NEW_PROJECT}_defconfig
    cp ${KERNEL}/arch/arm/configs/${BASE_PROJECT}_debug_defconfig ${KERNEL}/arch/arm/configs/${NEW_PROJECT}_debug_defconfig
    echo "Create  ${KERNEL}/arch/arm/configs/${NEW_PROJECT}_defconfig"
    echo "Create  ${KERNEL}/arch/arm/configs/${NEW_PROJECT}_debug_defconfig"
    NEW_FILES="${NEW_FILES} ${KERNEL}/arch/arm/configs/${NEW_PROJECT}_debug_defconfig ${KERNEL}/arch/arm/configs/${NEW_PROJECT}_defconfig"
    sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${KERNEL}/arch/arm/configs/${NEW_PROJECT}_defconfig
    sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${KERNEL}/arch/arm/configs/${NEW_PROJECT}_debug_defconfig
    cp ${KERNEL}/arch/arm/boot/dts/${BASE_PROJECT}.dts ${KERNEL}/arch/arm/boot/dts/${NEW_PROJECT}.dts
    cp ${KERNEL}/arch/arm/boot/dts/${BASE_PROJECT}_bat_setting.dtsi ${KERNEL}/arch/arm/boot/dts/${NEW_PROJECT}_bat_setting.dtsi
    echo "Create  ${KERNEL}/arch/arm/boot/dts/${NEW_PROJECT}.dts"
    echo "Create  ${KERNEL}/arch/arm/boot/dts/${NEW_PROJECT}_bat_setting.dtsi"
    NEW_FILES="${NEW_FILES} ${KERNEL}/arch/arm/boot/dts/${NEW_PROJECT}_bat_setting.dtsi ${KERNEL}/arch/arm/boot/dts/${NEW_PROJECT}.dts"
    sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${KERNEL}/arch/arm/boot/dts/${NEW_PROJECT}.dts
    cp ${KERNEL}/drivers/misc/mediatek/dws/mt6735/${BASE_PROJECT}.dws ${KERNEL}/drivers/misc/mediatek/dws/mt6735/${NEW_PROJECT}.dws
    echo "Create  ${KERNEL}/drivers/misc/mediatek/dws/mt6735/${NEW_PROJECT}.dws"
    NEW_FILES="${NEW_FILES} ${KERNEL}/drivers/misc/mediatek/dws/mt6735/${NEW_PROJECT}.dws"
    if [ -e ${KERNEL}/drivers/misc/mediatek/imgsensor/src/mt6735m/camera_project/${BASE_PROJECT} ]; then
	cp -ra ${KERNEL}/drivers/misc/mediatek/imgsensor/src/mt6735m/camera_project/${BASE_PROJECT} ${KERNEL}/drivers/misc/mediatek/imgsensor/src/mt6735m/camera_project/${NEW_PROJECT}
	echo "Create ${KERNEL}/drivers/misc/mediatek/imgsensor/src/mt6735m/camera_project/${NEW_PROJECT}"
	NEW_FILES="${NEW_FILES} ${KERNEL}/drivers/misc/mediatek/imgsensor/src/mt6735m/camera_project/${NEW_PROJECT}"
    fi
    if [ -e ${KERNEL}/drivers/misc/mediatek/flashlight/src/mt6735/${BASE_PROJECT} ]; then
	cp -ra ${KERNEL}/drivers/misc/mediatek/flashlight/src/mt6735/${BASE_PROJECT} ${KERNEL}/drivers/misc/mediatek/flashlight/src/mt6735/${NEW_PROJECT}
	echo "Create ${KERNEL}/drivers/misc/mediatek/flashlight/src/mt6735/${NEW_PROJECT}"
	NEW_FILES="${NEW_FILES} ${KERNEL}/drivers/misc/mediatek/flashlight/src/mt6735/${NEW_PROJECT}"
    fi
fi

echo "Clone android"
cp -r ${PROJECTDIR}/${BASE_PROJECT} ${PROJECTDIR}/${NEW_PROJECT}
echo "Create  ${PROJECTDIR}/${NEW_PROJECT}"
NEW_FILES="${NEW_FILES} ${PROJECTDIR}/${NEW_PROJECT}"
mv ${PROJECTDIR}/${NEW_PROJECT}/full_${BASE_PROJECT}.mk ${PROJECTDIR}/${NEW_PROJECT}/full_${NEW_PROJECT}.mk
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${PROJECTDIR}/${NEW_PROJECT}/AndroidProducts.mk
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${PROJECTDIR}/${NEW_PROJECT}/BoardConfig.mk
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${PROJECTDIR}/${NEW_PROJECT}/device.mk
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${PROJECTDIR}/${NEW_PROJECT}/full_${NEW_PROJECT}.mk
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${PROJECTDIR}/${NEW_PROJECT}/vendorsetup.sh

cp -r ${HAL}/${BASE_PROJECT} ${HAL}/${NEW_PROJECT}
echo "Create  ${HAL}/${NEW_PROJECT}"
NEW_FILES="${NEW_FILES}  ${HAL}/${NEW_PROJECT}"
sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${HAL}/${NEW_PROJECT}/Android.mk

cp vendor/mediatek/proprietary/trustzone/custom/build/project/${BASE_PROJECT}.mk vendor/mediatek/proprietary/trustzone/custom/build/project/${NEW_PROJECT}.mk
echo "Create  vendor/mediatek/proprietary/trustzone/custom/build/project/${NEW_PROJECT}.mk"
NEW_FILES="${NEW_FILES} vendor/mediatek/proprietary/trustzone/custom/build/project/${NEW_PROJECT}.mk"
#cp md32/md32/project/${BASE_PROJECT}.mk md32/md32/project/${NEW_PROJECT}.mk

ln -sf ${BASE_PROJECT} vendor/mikimobile/libs/${NEW_PROJECT}
echo "Create  vendor/mikimobile/libs/${NEW_PROJECT}"
NEW_FILES="${NEW_FILES} vendor/mikimobile/libs/${NEW_PROJECT}"

echo 
#echo '$NEW_FILES= '$NEW_FILES
#echo
echo `date`
echo ">>>>>> Copy Done <<<<<<"

