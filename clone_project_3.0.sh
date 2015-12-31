#!/bin/bash
##***********************************************************************##
##  Description:  This shell script is written for creating new projects ##
##                in differnt platforms and android versions             ##
##  Usage:       ./clone_project.sh  Old_Project New_Project             ##
##  Author:      pengbowei                                               ##
##  Modify:      yanzx													 ##
##  Create Date: 2015-11-10                                              ##
##  Modify Date: 2015-12-30                                              ##
##***********************************************************************##

#### use to debug
#set -x    

if [ ! "-$2" = "-" ]; then
ALPS_PATH=$PWD
OLDPROJECT=$1
NEWPROJECT=$2
NEW_FILES=" "

echo ">>> Begin to Create New Project! " `date`  
#read -p "your old project name: " OLDPROJECT
#read -p "your new project name: " NEWPROJECT
echo "your old project name: $OLDPROJECT"
echo "your new project name: $NEWPROJECT"
echo " $OLDPROJECT  =>  $NEWPROJECT " 


while read line
do
    name=`echo $line|awk -F ':=' '{print $1}'`
    value=`echo $line|awk -F ':=' '{print $2}'`
    case $name in
         "PLATFORM_VERSION ")
          Version=$value
          ;;
    esac
done  <  build/core/version_defaults.mk
echo " Android Version :$Version "

MainVersion=`echo $Version|awk -F '.' '{print $1}'`
case $MainVersion in
       4)
       ProjectDir=mediatek/config
       ProjectConfig=mediatek/config/$OLDPROJECT/ProjectConfig.mk
       ;;
       5)
       ProjectDir=device/sansen
       ProjectConfig=device/sansen/$OLDPROJECT/ProjectConfig.mk
       ;;
esac

# Test whether OLDPROJECT exist
if [ -d ${ProjectDir}/${OLDPROJECT} ]; then
  if [ -d ${ProjectDir}/${NEWPROJECT} ]; then 
    echo "Error: $NEWPROJECT is exist! "
    exit 2 
  fi
else 
  echo "Error: $OLDPROJECT not exist! "
  exit 1 
fi

Platform=`cat $ProjectConfig | grep -E 'MTK_PLATFORM=|MTK_PLATFORM =' | cut -d '=' -f 2`
Platform=`echo $Platform|tr "[A-Z]" "[a-z]" `
echo " Mediatek Platform : $Platform "
echo " "

#******* Create Project in Android 4.4 *******#

# Copy Project in Android 4.4
function CopyProject_KK()
{
  cd $ALPS_PATH
  if [ ! -d mediatek/config/$NEWPROJECT ];then

    cp -a mediatek/config/$OLDPROJECT  mediatek/config/$NEWPROJECT
       echo " mediatek/config/$NEWPROJECT  finished!"
    NEW_FILES=$NEW_FILES"
      mediatek/config/$NEWPROJECT"
    cp -a mediatek/custom/$OLDPROJECT  mediatek/custom/$NEWPROJECT
       echo " mediatek/custom/$NEWPROJECT  finished!"
    NEW_FILES=$NEW_FILES"
      mediatek/custom/$NEWPROJECT"
    cp -a mediatek/custom/common/lk/logo/$OLDPROJECT  mediatek/custom/common/lk/logo/$NEWPROJECT
       echo " mediatek/custom/common/lk/logo/$NEWPROJECT  finished!"
    NEW_FILES=$NEW_FILES"
      mediatek/custom/common/lk/logo/$NEWPROJECT"

    cp -a mediatek/media/bootanimation/bootanimation_$OLDPROJECT.zip  mediatek/media/bootanimation/bootanimation_$NEWPROJECT.zip
       echo " mediatek/media/bootanimation/bootanimation_$NEWPROJECT.zip  finished!"
    NEW_FILES=$NEW_FILES"
      mediatek/media/bootanimation/bootanimation_$NEWPROJECT.zip"
    cp -a mediatek/media/bootaudio/bootaudio_$OLDPROJECT.mp3  mediatek/media/bootaudio/bootaudio_$NEWPROJECT.mp3
       echo " mediatek/media/bootaudio/bootaudio_$NEWPROJECT.mp3  finished!"
    NEW_FILES=$NEW_FILES"
      mediatek/media/bootaudio/bootaudio_$NEWPROJECT.mp3"

    cp -a build/target/product/$OLDPROJECT.mk  build/target/product/$NEWPROJECT.mk
       echo " build/target/product/$NEWPROJECT.mk  finished!"
    NEW_FILES=$NEW_FILES"
      build/target/product/$NEWPROJECT.mk"
    cp -a bootable/bootloader/lk/project/$OLDPROJECT.mk  bootable/bootloader/lk/project/$NEWPROJECT.mk
       echo " bootable/bootloader/lk/project/$NEWPROJECT.mk  finished!"
    NEW_FILES=$NEW_FILES"
      bootable/bootloader/lk/project/$NEWPROJECT.mk"

    cp -a vendor/mediatek/$OLDPROJECT  vendor/mediatek/$NEWPROJECT
    NEW_FILES=$NEW_FILES"
      vendor/mediatek/$NEWPROJECT"
    cp -a vendor/mediatek/$NEWPROJECT/artifacts/out/target/product/$OLDPROJECT  vendor/mediatek/$NEWPROJECT/artifacts/out/target/product/$NEWPROJECT
    NEW_FILES=$NEW_FILES"
      vendor/mediatek/$NEWPROJECT/artifacts/out/target/product/$NEWPROJECT"
       echo " vendor/mediatek/$NEWPROJECT  finished!" 

    echo ">>> Copy Successfully!"

  else
    echo "$NEWPROJECT  already exists"
    exit 1     
  fi
  echo 
}

# Delete .svn files for svn commit in Android 4.4
function DeleteSvn_KK()
{
  cd $ALPS_PATH
  
  if [ -d mediatek/config/$NEWPROJECT ]; then
    cd mediatek/config/$NEWPROJECT
    find . -type d -name ".svn"|xargs rm -rf
    echo "Delete .svn under mediatek/config/$NEWPROJECT"
    cd - > /dev/null
  fi
  
  if [ -d mediatek/custom/$NEWPROJECT ]; then
    cd mediatek/custom/$NEWPROJECT
    find . -type d -name ".svn"|xargs rm -rf
    echo "Delete .svn under mediatek/custom/$NEWPROJECT"
    cd - > /dev/null
  fi

  if [ -d mediatek/custom/common/lk/logo/$NEWPROJECT ];then
     cd mediatek/custom/common/lk/logo/$NEWPROJECT
     find . -type d -name ".svn"|xargs rm -rf
     echo "Delete .svn under mediatek/custom/common/lk/logo/$NEWPROJECT"
     cd - > /dev/null
  fi

#  cd vendor/mediatek/$NEWPROJECT
#  find . -type d -name ".svn"|xargs rm -rf
#  echo "Delete .svn under vendor/mediatek/$NEWPROJECT"
#  cd $ALPS_PATH
  echo ">>> Delete .svn files Successfully!"
  echo " "
}

#******* Create Project in Android 5.0/5.1 *******#

# Usage:  deleteSvn directory 
function deleteSvn()
{
  if [ ! "" == "$1" ] 
  then 
    if [ -d $1 ] ; then
      cd $1
      echo "  Delete .svn under $1"
      find . -type d -name ".svn"|xargs rm -rf
      cd - > /dev/null
    else
      echo "  $1 is not a directory."
    fi
  else 
    echo "  No svn directory to be deleted."
  fi
}

# copy pl module
function clone_preloader() 
{
    cd $ALPS_PATH
    Preloader=bootable/bootloader/preloader/custom
    cd $Preloader

    if [ -d ${OLDPROJECT} ] && [ ! -d ${NEWPROJECT} ];then
        cp -a ${OLDPROJECT} ${NEWPROJECT}
        echo "${Preloader}/${NEWPROJECT} is created. "
        deleteSvn ${PWD}/${NEWPROJECT}
      NEW_FILES=$NEW_FILES"
      ${Preloader}/${NEWPROJECT}"
        mv ${NEWPROJECT}/${OLDPROJECT}.mk  ${NEWPROJECT}/${NEWPROJECT}.mk
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  ${NEWPROJECT}/${NEWPROJECT}.mk
        echo "$Preloader/${NEWPROJECT}/${NEWPROJECT}.mk is modified. "
    else
        echo "Error: create ${Preloader}/${NEWPROJECT} fail!"
    fi
    cd $ALPS_PATH
}

# copy lk module
function clone_lk()
{
    cd $ALPS_PATH
    Lk=bootable/bootloader/lk
    cd $Lk

    if [ -d "target/${OLDPROJECT}" ] && [ ! -d "target/${NEWPROJECT}" ];then
        cp -a target/${OLDPROJECT}  target/${NEWPROJECT}
        echo "${Lk}/target/${NEWPROJECT}  is created."
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  target/${NEWPROJECT}/include/target/cust_usb.h
        echo "  ${Lk}/target/${NEWPROJECT}/include/target/cust_usb.h is modified."
        deleteSvn ${PWD}/target/${NEWPROJECT}
      NEW_FILES=$NEW_FILES"
        ${Lk}/target/${NEWPROJECT}"

    else
        echo "Error: create ${Lk}/target/${NEWPROJECT} fail!"
    fi

    if [ -e "project/${OLDPROJECT}.mk" ] && [ ! -e "project/${NEWPROJECT}.mk" ];then
        cp project/${OLDPROJECT}.mk  project/${NEWPROJECT}.mk
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  project/${NEWPROJECT}.mk
        echo "${Lk}/project/${NEWPROJECT}.mk is created and modified."
      NEW_FILES=$NEW_FILES"
        ${Lk}/project/${NEWPROJECT}.mk"
    else
      echo "Error: create ${Lk}/project/${NEWPROJECT}.mk fail!"
    fi

    if [ -d dev/logo/full_${OLDPROJECT} ] && [ ! -d "dev/logo/full_${NEWPROJECT}" ];then 
      cp -a  dev/logo/full_${OLDPROJECT}  dev/logo/full_${NEWPROJECT}
      echo "${Lk}/dev/logo/full_${NEWPROJECT} is created"
      deleteSvn $PWD/dev/logo/full_${NEWPROJECT}
      NEW_FILES=$NEW_FILES"
        ${Lk}/dev/logo/full_${NEWPROJECT}"
    else
      echo "Error: create ${Lk}/dev/logo/full_${NEWPROJECT} fail!"
    fi

    cd $ALPS_PATH
}

# copy kernel module
function clone_kernel()
{
  cd $ALPS_PATH
  if [ "$Platform" = "mt8735" -o "$Platform" = "mt6735" -o "$Platform" = "mt6580" -o "$Platform" = "mt8321" ];then
  
    if [ "$Platform" = "mt8735" -o "$Platform" = "mt6735" ];then
	  cd kernel-3.10/arch/arm64/
      ARM=kernel-3.10/arch/arm64
    else	
      cd kernel-3.10/arch/arm/
      ARM=kernel-3.10/arch/arm
    fi
	   
	cp boot/dts/${OLDPROJECT}.dts  boot/dts/${NEWPROJECT}.dts
    echo "$ARM/boot/dts/${NEWPROJECT}.dts is created"
    NEW_FILES=$NEW_FILES"
      $ARM/boot/dts/${NEWPROJECT}.dts"
    if [ ! -e configs/${NEWPROJECT}_debug_defconfig ]; then
      cp configs/${OLDPROJECT}_defconfig  configs/${NEWPROJECT}_defconfig
      cp configs/${OLDPROJECT}_debug_defconfig  configs/${NEWPROJECT}_debug_defconfig
	  sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_defconfig
	  sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_debug_defconfig
      echo "$ARM/configs/${NEWPROJECT}_defconfig is modified"
      echo "$ARM/configs/${NEWPROJECT}_debug_defconfig is modified"
      NEW_FILES=$NEW_FILES"
        $ARM/configs/${NEWPROJECT}_defconfig
        $ARM/configs/${NEWPROJECT}_debug_defconfig"
    fi
    cd $ALPS_PATH
    
    cd kernel-3.10/drivers/misc/mediatek/mach/
    
    if [ ! -d "${Platform}/${NEWPROJECT}" ];then
        cp -a ${Platform}/${OLDPROJECT}  ${Platform}/${NEWPROJECT}
        echo "kernel-3.10/drivers/misc/mediatek/mach/${Platform}/${NEWPROJECT} is created" 
        deleteSvn $PWD/${Platform}/${NEWPROJECT}
      NEW_FILES=$NEW_FILES"
        kernel-3.10/drivers/misc/mediatek/mach/${Platform}/${NEWPROJECT}"
    else
        echo "kernel-3.10/drivers/misc/mediatek/mach/${Platform}/${NEWPROJECT} already exists!" 
    fi  
    cd $ALPS_PATH  
        
  else
    
    cd kernel-3.10/arch/arm/

    if [ ! -d "mach-${Platform}/${NEWPROJECT}" ];then
        cp -a  mach-${Platform}/${OLDPROJECT}  mach-${Platform}/${NEWPROJECT}
        echo "kernel-3.10/arch/arm/mach-${Platform}/${NEWPROJECT} is created"
        deleteSvn $PWD/mach-${Platform}/${NEWPROJECT}
      NEW_FILES=$NEW_FILES"
        kernel-3.10/arch/arm/mach-${Platform}/${NEWPROJECT}"

        cp configs/${OLDPROJECT}_defconfig  configs/${NEWPROJECT}_defconfig
        cp configs/${OLDPROJECT}_debug_defconfig  configs/${NEWPROJECT}_debug_defconfig
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_defconfig
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_debug_defconfig
        echo "kernel-3.10/arch/arm/configs/${NEWPROJECT}_defconfig is modified"
        echo "kernel-3.10/arch/arm/configs/${NEWPROJECT}_debug_defconfig is modified" 
      NEW_FILES=$NEW_FILES"
        kernel-3.10/arch/arm/configs/${NEWPROJECT}_defconfig
        kernel-3.10/arch/arm/configs/${NEWPROJECT}_debug_defconfig"
    else
        echo "kernel-3.10/arch/arm/mach-${Platform}/${NEWPROJECT} already exists !"
    fi
    cd $ALPS_PATH
   
  fi   
}

function clone_Kernel()
{
  cd $ALPS_PATH
  if [ -e kernel-3.10/arch/arm/configs/${OLDPROJECT}_debug_defconfig ]; then 
    ARM=kernel-3.10/arch/arm
  elif [ -e kernel-3.10/arch/arm64/configs/${OLDPROJECT}_debug_defconfig ]; then 
    ARM=kernel-3.10/arch/arm64
  else 
    ARM=null
    echo "Error: ${OLDPROJECT}_debug_defconfig file can not find."
  fi

  if [ "null" != "${ARM}" ]; then
    cd ${ARM}
    if [ ! -e configs/${NEWPROJECT}_debug_defconfig ]; then
      cp configs/${OLDPROJECT}_defconfig  configs/${NEWPROJECT}_defconfig
      cp configs/${OLDPROJECT}_debug_defconfig  configs/${NEWPROJECT}_debug_defconfig
	  sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_defconfig
	  sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_debug_defconfig
      echo "${ARM}/configs/${NEWPROJECT}_defconfig is modified."
      echo "${ARM}/configs/${NEWPROJECT}_debug_defconfig is modified."
      NEW_FILES=$NEW_FILES"
        ${ARM}/configs/${NEWPROJECT}_defconfig
        ${ARM}/configs/${NEWPROJECT}_debug_defconfig"
    else
      echo "Error: create ${NEWPROJECT}_debug_defconfig fail!" 
    fi

    if [ -e boot/dts/${OLDPROJECT}.dts ] && [ ! -e boot/dts/${NEWPROJECT}.dts ]; then
	  cp boot/dts/${OLDPROJECT}.dts  boot/dts/${NEWPROJECT}.dts
      echo "$ARM/boot/dts/${NEWPROJECT}.dts is created."
      NEW_FILES=$NEW_FILES"
        ${ARM}/boot/dts/${NEWPROJECT}.dts"
    fi
    cd $ALPS_PATH
  fi
 
  if [ -d ${ARM}/mach-${Platform}/${OLDPROJECT} ] && [ ! -d ${ARM}/mach-${Platform}/${NEWPROJECT} ]; then
    cd ${ARM}
    cp -a mach-${Platform}/${OLDPROJECT}  mach-${Platform}/${NEWPROJECT}
    echo "${ARM}/mach-${Platform}/${NEWPROJECT} is created."
    deleteSvn $PWD/mach-${Platform}/${NEWPROJECT}
    NEW_FILES=$NEW_FILES"
      ${ARM}/mach-${Platform}/${NEWPROJECT}"
    cd $ALPS_PATH
  else
    MACH=kernel-3.10/drivers/misc/mediatek/mach
    if [ -d ${MACH}/${Platform}/${OLDPROJECT} ] && [ ! -d ${MACH}/${Platform}/${NEWPROJECT} ]; then
      cd ${MACH}
      cp -a ${Platform}/${OLDPROJECT}  ${Platform}/${NEWPROJECT}
      echo "${MACH}/${Platform}/${NEWPROJECT} is created." 
      deleteSvn $PWD/${Platform}/${NEWPROJECT}
      NEW_FILES=$NEW_FILES"
        ${MACH}/${Platform}/${NEWPROJECT}"
      cd $ALPS_PATH
    else
      echo "Error: create kernel.../${Platform}/${NEWPROJECT} fail!" 
    fi
  fi
}

# copy  android module
function clone_android() 
{
    if [ ! -d "device/sansen/${NEWPROJECT}" ];then
        cp -a device/sansen/${OLDPROJECT}  device/sansen/${NEWPROJECT}
        echo "device/sansen/${NEWPROJECT} is created"
        deleteSvn $PWD/device/sansen/${NEWPROJECT}
      NEW_FILES=$NEW_FILES"
        device/sansen/${NEWPROJECT}"

        mv device/sansen/${NEWPROJECT}/full_${OLDPROJECT}.mk  device/sansen/${NEWPROJECT}/full_${NEWPROJECT}.mk
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  device/sansen/${NEWPROJECT}/full_${NEWPROJECT}.mk
        echo "device/sansen/${NEWPROJECT}/full_${NEWPROJECT}.mk is modified"
       #sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  device/sansen/${NEWPROJECT}/AndroidBoard.mk
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  device/sansen/${NEWPROJECT}/AndroidProducts.mk
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  device/sansen/${NEWPROJECT}/BoardConfig.mk
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  device/sansen/${NEWPROJECT}/device.mk
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  device/sansen/${NEWPROJECT}/vendorsetup.sh
    else
        echo "device/sansen/${NEWPROJECT} already exists!"
    fi

    if [ ! -d "vendor/mediatek/proprietary/custom/${NEWPROJECT}" ];then
        cp -a vendor/mediatek/proprietary/custom/${OLDPROJECT}  vendor/mediatek/proprietary/custom/${NEWPROJECT}
        # sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g  vendor/mediatek/proprietary/custom/${NEW_PROJECT}/Android.mk
        echo "vendor/mediatek/proprietary/custom/${NEWPROJECT} is created"
        deleteSvn $PWD/vendor/mediatek/proprietary/custom/${NEWPROJECT}
      NEW_FILES=$NEW_FILES"
        vendor/mediatek/proprietary/custom/${NEWPROJECT}"
    else
        echo "vendor/mediatek/proprietary/custom/${NEWPROJECT}  already exists!"
    fi
    # share libs
    # sed -i s#vendor/${COMPANY}/libs/${NEW_PROJECT}#vendor/${COMPANY}/libs/${BASE_PROJECT}#g \
    # device/${COMPANY}/${NEW_PROJECT}/device.mk
    # no share libs 
    # cp -r vendor/${COMPANY}/libs/${BASE_PROJECT} vendor/${COMPANY}/libs/${NEW_PROJECT}
    cd vendor/sansen/libs/
    ln -sf  ${OLDPROJECT} ${NEWPROJECT}
    echo "vendor/sansen/libs/$NEWPROJECT is created"
    NEW_FILES=$NEW_FILES"
      vendor/sansen/libs/${NEWPROJECT}"
    cd $ALPS_PATH
    
#    if [ "$Platform" = "mt6735" -o "$Platform" = "mt6580" ];then
    cd vendor/mediatek/proprietary/trustzone/project/
    if [ -e "${OLDPROJECT}.mk" ] ; then
       cp -a ${OLDPROJECT}.mk  ${NEWPROJECT}.mk
       sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  ${NEWPROJECT}.mk
       echo "vendor/mediatek/proprietary/trustzone/project/${NEWPROJECT}.mk is modified"
      NEW_FILES=$NEW_FILES"
        vendor/mediatek/proprietary/trustzone/project/${NEWPROJECT}.mk"
    fi
    cd $ALPS_PATH

    cd frameworks/base/data/sounds/media/
    if [ -e bootanimation/bootanimation_full_${OLDPROJECT}.zip ] ; then 
       cp -a bootanimation/bootanimation_full_${OLDPROJECT}.zip  bootanimation/bootanimation_full_${NEWPROJECT}.zip 
       echo "frameworks/base/data/sounds/media/bootanimation/bootanimation_full_${NEWPROJECT}.zip is created"
      NEW_FILES=$NEW_FILES"
        frameworks/base/data/sounds/media/bootanimation/bootanimation_full_${NEWPROJECT}.zip"
    fi
    if [ -e bootaudio/bootaudio_full_${OLDPROJECT}.mp3 ] ; then
       cp -a bootaudio/bootaudio_full_${OLDPROJECT}.mp3   bootaudio/bootaudio_full_${NEWPROJECT}.mp3
       echo "frameworks/base/data/sounds/media/bootaudio/bootaudio_full_${NEWPROJECT}.mp3 is created" 
      NEW_FILES=$NEW_FILES"
        frameworks/base/data/sounds/media/bootaudio/bootaudio_full_${NEWPROJECT}.mp3"
    fi   
    if [ -e shutanimation/shutanimation_full_${OLDPROJECT}.zip ];then
       cp -a  shutanimation/shutanimation_full_${OLDPROJECT}.zip  shutanimation/shutanimation_full_${NEWPROJECT}.zip
       echo "frameworks/base/data/sounds/media/shutanimation/shutanimation_full_${NEWPROJECT}.zip is created"
      NEW_FILES=$NEW_FILES"
        frameworks/base/data/sounds/media/shutanimation/shutanimation_full_${NEWPROJECT}.zip"
    fi
    if [ -e shutaudio/shutaudio_full_${OLDPROJECT}.mp3 ];then
       cp -a  shutaudio/shutaudio_full_${OLDPROJECT}.mp3  shutaudio/shutaudio_full_${NEWPROJECT}.mp3
       echo "frameworks/base/data/sounds/media/shutaudio/shutaudio_full_${NEWPROJECT}.mp3 is created"
      NEW_FILES=$NEW_FILES"
        frameworks/base/data/sounds/media/shutaudio/shutaudio_full_${NEWPROJECT}.mp3"
    fi
    cd $ALPS_PATH
#    fi
}


# copy project in Android 5.0/5.1
 function CopyProject_L()
{
  clone_preloader
  clone_lk
  clone_kernel
  clone_android
  echo ">>> Copy Successfully!"
  echo " "
}

# Delete .svn files for svn commit in Android 5.0/5.1
 function DeleteSvn_L()
{
  cd $ALPS_PATH
  cd  bootable/bootloader/preloader/custom/$NEWPROJECT
  find . -type d -name ".svn"|xargs rm -rf
  echo "Delete .svn under bootable/bootloader/preloader/custom/$NEWPROJECT"
  cd $ALPS_PATH

  cd  bootable/bootloader/lk/target/$NEWPROJECT
  find . -type d -name ".svn"|xargs rm -rf
  echo "Delete .svn under bootable/bootloader/lk/target/$NEWPROJECT"
  cd $ALPS_PATH

  if [ -d "kernel-3.10/arch/arm/mach-$Platform/$NEWPROJECT" ];then
     cd  kernel-3.10/arch/arm/mach-$Platform/$NEWPROJECT
     find . -type d -name ".svn"|xargs rm -rf
     echo "Delete .svn under kernel-3.10/arch/arm/mach-$Platform/$NEWPROJECT"
     cd $ALPS_PATH
  fi

  if [ -d "kernel-3.10/drivers/misc/mediatek/mach/${Platform}/${NEWPROJECT}" ];then
     cd kernel-3.10/drivers/misc/mediatek/mach/${Platform}/${NEWPROJECT}
     find . -type d -name ".svn"|xargs rm -rf
     echo "Delete .svn under kernel-3.10/drivers/misc/mediatek/mach/${Platform}/${NEWPROJECT}"
     cd $ALPS_PATH
  fi

  cd  device/sansen/$NEWPROJECT
  find . -type d -name ".svn"|xargs rm -rf
  echo "Delete .svn under device/sansen/$NEWPROJECT"
  cd $ALPS_PATH
  
  cd  vendor/mediatek/proprietary/custom/$NEWPROJECT
  find . -type d -name ".svn"|xargs rm -rf
  echo "Delete .svn under vendor/mediatek/proprietary/custom/$NEWPROJECT"
  cd $ALPS_PATH

#  cd  vendor/sansen/libs/$NEWPROJECT
#  find . -type d -name ".svn"|xargs rm -rf
#  echo "Delete .svn under vendor/sansen/libs/$NEWPROJECT"
#  cd $ALPS_PATH
  echo ">>> Delete svn files Successfully!"
  echo " "
}


# main
function main()
{
   case $MainVersion in
         4)
         CopyProject_KK
         DeleteSvn_KK
         ;;
         5)
         CopyProject_L
         #DeleteSvn_L
         ;;
   esac
  echo '$NEW_FILES='$NEW_FILES
  echo " "
}

main

else
echo "Please input two parameters as follows!"
echo "$0 Old_Project  New_Project"
fi

