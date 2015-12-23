#!/bin/bash
##***********************************************************************##
##  Description:  This shell script is written for creating new projects ##
##                in differnt platforms and android versions             ##
##  Usage:       ./NewPrj_All.sh  [Old_Project] [New_Project]            ##
##  Author:      pengbowei                                               ##
##  Modify:      yanzx													 ##
##  Date:        2015-11-10                                              ##
##  Modify Date: 2015-11-25                                              ##
##***********************************************************************##

if [ ! "-$2" = "-" ]; then
ALPS_PATH=$PWD
OLDPROJECT=$1
NEWPROJECT=$2
# For Android 4.4/5.0/5.1
echo ">>> Begin to Create New Project! " `date`  
#read -p "your old project name: " OLDPROJECT
#read -p "your new project name: " NEWPROJECT
echo "your old project name: $OLDPROJECT"
echo "your new project name: $NEWPROJECT"
echo " $OLDPROJECT  =>  $NEWPROJECT " 

cd $ALPS_PATH


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

Version=`echo $Version|awk -F '.' '{print $1}'`
case $Version in
       4)
       Platform_Path=mediatek/config/$OLDPROJECT/ProjectConfig.mk
       ;;
       5)
       Platform_Path=device/sansen/$OLDPROJECT/ProjectConfig.mk
       ;;
esac

Platform=`cat $Platform_Path | grep -E 'MTK_PLATFORM=|MTK_PLATFORM =' | cut -d '=' -f 2`
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
    cp -a mediatek/custom/$OLDPROJECT  mediatek/custom/$NEWPROJECT
       echo " mediatek/custom/$NEWPROJECT  finished!"
    cp -a mediatek/custom/common/lk/logo/$OLDPROJECT  mediatek/custom/common/lk/logo/$NEWPROJECT
       echo " mediatek/custom/common/lk/logo/$NEWPROJECT  finished!"

    cp -a mediatek/media/bootanimation/bootanimation_$OLDPROJECT.zip  mediatek/media/bootanimation/bootanimation_$NEWPROJECT.zip
       echo " mediatek/media/bootanimation/bootanimation_$NEWPROJECT.zip  finished!"
    cp -a mediatek/media/bootaudio/bootaudio_$OLDPROJECT.mp3  mediatek/media/bootaudio/bootaudio_$NEWPROJECT.mp3
       echo " mediatek/media/bootaudio/bootaudio_$NEWPROJECT.mp3  finished!"

    cp -a build/target/product/$OLDPROJECT.mk  build/target/product/$NEWPROJECT.mk
       echo " build/target/product/$NEWPROJECT.mk  finished!"
    cp -a bootable/bootloader/lk/project/$OLDPROJECT.mk  bootable/bootloader/lk/project/$NEWPROJECT.mk
       echo " bootable/bootloader/lk/project/$NEWPROJECT.mk  finished!"

    cp -a vendor/mediatek/$OLDPROJECT  vendor/mediatek/$NEWPROJECT
    cp -a vendor/mediatek/$NEWPROJECT/artifacts/out/target/product/$OLDPROJECT  vendor/mediatek/$NEWPROJECT/artifacts/out/target/product/$NEWPROJECT
       echo " vendor/mediatek/$NEWPROJECT  finished!" 

    echo ">>> Copy Successfully!"

  else
     echo "$NEWPROJECT  already exists"
  fi
  echo 
}

# Delete .svn files for svn commit in Android 4.4
function DeleteSvn_KK()
{
  cd $ALPS_PATH
  
  cd mediatek/config/$NEWPROJECT
  find . -type d -name ".svn"|xargs rm -rf
  echo "Delete .svn under mediatek/config/$NEWPROJECT"
  cd - > /dev/null
  
  cd mediatek/custom/$NEWPROJECT
  find . -type d -name ".svn"|xargs rm -rf
  echo "Delete .svn under mediatek/custom/$NEWPROJECT"
  cd - > /dev/null
  
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
    cd bootable/bootloader/preloader/custom/

    if [ ! -d ${NEWPROJECT} ];then
        cp -a ${OLDPROJECT} ${NEWPROJECT}
        echo "bootable/bootloader/preloader/custom/${NEWPROJECT} is created "
        deleteSvn $PWD/${NEWPROJECT}
 
        mv ${NEWPROJECT}/${OLDPROJECT}.mk  ${NEWPROJECT}/${NEWPROJECT}.mk
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  ${NEWPROJECT}/${NEWPROJECT}.mk
        echo "bootable/bootloader/preloader/custom/${NEWPROJECT}/${NEWPROJECT}.mk is modified "
    else
        echo "bootable/bootloader/preloader/custom/${NEWPROJECT}  already exists!"
    fi
    cd $ALPS_PATH
}

# copy lk module
function clone_lk()
{
    cd $ALPS_PATH
    cd bootable/bootloader/lk

    if [ ! -d "target/${NEWPROJECT}" ];then     
        cp -a target/${OLDPROJECT}  target/${NEWPROJECT}
        echo "bootable/bootloader/lk/target/"${NEWPROJECT}"  is created"
        deleteSvn $PWD/target/${NEWPROJECT}

        cp project/${OLDPROJECT}.mk  project/${NEWPROJECT}.mk      
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  target/${NEWPROJECT}/include/target/cust_usb.h
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  project/${NEWPROJECT}.mk
        echo "bootable/bootloader/lk/project/${NEWPROJECT}.mk is modified"
    else
        echo "bootable/bootloader/lk/target/${NEWPROJECT}  already exists !"
    fi

    if [ "$Platform" = "mt8735" -o "$Platform" = "mt6735" -o "$Platform" = "mt8321" -o "$Platform" = "mt6580" ];then
       if [ ! -d "dev/logo/full_${NEWPROJECT}" ];then 
           cp -a  dev/logo/full_${OLDPROJECT}  dev/logo/full_${NEWPROJECT}
           echo "bootable/bootloader/lk/dev/logo/full_${NEWPROJECT} is created"
           deleteSvn $PWD/dev/logo/full_${NEWPROJECT}

       else
          echo "bootable/bootloader/lk/dev/logo/full_${NEWPROJECT} already exists !"
       fi
    fi 
    cd $ALPS_PATH
}

# copy kernel module
function clone_kernel()
{

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
    cp configs/${OLDPROJECT}_defconfig  configs/${NEWPROJECT}_defconfig
	cp configs/${OLDPROJECT}_debug_defconfig  configs/${NEWPROJECT}_debug_defconfig
	sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_defconfig
	sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_debug_defconfig
    echo "$ARM/configs/${NEWPROJECT}_defconfig is modified"
    echo "$ARM/configs/${NEWPROJECT}_debug_defconfig is modified"	
    cd $ALPS_PATH
    
    cd kernel-3.10/drivers/misc/mediatek/mach/
    
    if [ ! -d "${Platform}/${NEWPROJECT}" ];then
        cp -a ${Platform}/${OLDPROJECT}  ${Platform}/${NEWPROJECT}
        echo "kernel-3.10/drivers/misc/mediatek/mach/${Platform}/${NEWPROJECT} is created" 
        deleteSvn $PWD/${Platform}/${NEWPROJECT}
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

        cp configs/${OLDPROJECT}_defconfig  configs/${NEWPROJECT}_defconfig
        cp configs/${OLDPROJECT}_debug_defconfig  configs/${NEWPROJECT}_debug_defconfig
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_defconfig
        sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  configs/${NEWPROJECT}_debug_defconfig
        echo "kernel-3.10/arch/arm/configs/${NEWPROJECT}_defconfig is modified"
        echo "kernel-3.10/arch/arm/configs/${NEWPROJECT}_debug_defconfig is modified" 
    else
        echo "kernel-3.10/arch/arm/mach-${Platform}/${NEWPROJECT} already exists !"
    fi
    cd $ALPS_PATH
   
  fi   
}

# copy  android module
function clone_android() 
{
    if [ ! -d "device/sansen/${NEWPROJECT}" ];then
        cp -a device/sansen/${OLDPROJECT}  device/sansen/${NEWPROJECT}
        echo "device/sansen/${NEWPROJECT} is created"
        deleteSvn $PWD/device/sansen/${NEWPROJECT}

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
    cd $ALPS_PATH
    
    if [ "$Platform" = "mt6735" -o "$Platform" = "mt6580" ];then
       cd vendor/mediatek/proprietary/trustzone/project/
       cp -a ${OLDPROJECT}.mk  ${NEWPROJECT}.mk
       sed -i s/${OLDPROJECT}/${NEWPROJECT}/g  ${NEWPROJECT}.mk
       echo "vendor/mediatek/proprietary/trustzone/project/${NEWPROJECT}.mk is modified"
       cd $ALPS_PATH
       
       cd frameworks/base/data/sounds/media/
       cp -a bootanimation/bootanimation_full_${OLDPROJECT}.zip  bootanimation/bootanimation_full_${NEWPROJECT}.zip 
       cp -a bootaudio/bootaudio_full_${OLDPROJECT}.mp3   bootaudio/bootaudio_full_${NEWPROJECT}.mp3
       echo "frameworks/base/data/sounds/media/bootanimation/bootanimation_full_${NEWPROJECT}.zip is created"
       echo "frameworks/base/data/sounds/media/bootaudio/bootaudio_full_${NEWPROJECT}.mp3 is created"    

       if [ -f shutanimation/shutanimation_full_${OLDPROJECT}.zip ];then
          cp -a  shutanimation/shutanimation_full_${OLDPROJECT}.zip  shutanimation/shutanimation_full_${NEWPROJECT}.zip
          echo "frameworks/base/data/sounds/media/shutanimation/shutanimation_full_${NEWPROJECT}.zip is created"
       fi
       if [ -f shutaudio/shutaudio_full_${OLDPROJECT}.mp3 ];then
          cp -a  shutaudio/shutaudio_full_${OLDPROJECT}.mp3  shutaudio/shutaudio_full_${NEWPROJECT}.mp3
          echo "frameworks/base/data/sounds/media/shutaudio/shutaudio_full_${NEWPROJECT}.mp3 is created"
       fi
       cd $ALPS_PATH
    fi
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
   case $Version in
         4)
         CopyProject_KK
         DeleteSvn_KK
         ;;
         5)
         CopyProject_L
         #DeleteSvn_L
         ;;
   esac
}

main

else
echo "Please input two parameters as follows!"
echo "$0 Old_Project  New_Project"
fi

