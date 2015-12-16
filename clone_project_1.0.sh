#!/bin/bash
#
# 
#

if [ ! "-$2" = "-" ]; then
  BASE_PROJECT=$1
  NEW_PROJECT=$2
  PALTFORM=mt8127 
  #COMPANY=mediatek
  COMPANY=sansen
  echo "base project:" ${BASE_PROJECT}
  echo "new project :" ${NEW_PROJECT}
  echo "PALTFORM    :" ${PALTFORM}
  echo "COMPANY     :" ${COMPANY}


#############################################
# preloader 
############################################
  function clone_preloader() 
  {
	cd bootable/bootloader/preloader/custom/

	if [ ! -d ${NEW_PROJECT} ];then
		cp -rf ${BASE_PROJECT} ${NEW_PROJECT}
		mv ${NEW_PROJECT}/${BASE_PROJECT}.mk ${NEW_PROJECT}/${NEW_PROJECT}.mk
		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g ${NEW_PROJECT}/${NEW_PROJECT}.mk
		echo "create"$PWD"/"${NEW_PROJECT}"done!!!!!!"
	else 
		echo $PWD/${NEW_PROJECT}" is already create !!!!!!"
	fi

	cd -
  }

#############################################
# lk 
############################################
  function clone_lk()
  {
	cd bootable/bootloader/lk

	if [ ! -d "target/${NEW_PROJECT}" ];then
		cp project/${BASE_PROJECT}.mk project/${NEW_PROJECT}.mk
		cp -rf target/${BASE_PROJECT} target/${NEW_PROJECT}
		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g project/${NEW_PROJECT}.mk
		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g target/${NEW_PROJECT}/include/target/cust_usb.h
		echo "create"$PWD"/target/"${NEW_PROJECT}"done!!!!!!"
	else
		echo $PWD"/target/"${NEW_PROJECT}" is already create !!!!!!"
	fi

	cd -
  }

###############################################
#kernel					      #	
###############################################
  function clone_kernel()
  {
	cd kernel-3.10/arch/arm/

	if [ ! -d "mach-${PALTFORM}/${NEW_PROJECT}" ];then
		cp -rf mach-${PALTFORM}/${BASE_PROJECT} mach-${PALTFORM}/${NEW_PROJECT}
		cp configs/${BASE_PROJECT}_defconfig configs/${NEW_PROJECT}_defconfig
		cp configs/${BASE_PROJECT}_debug_defconfig configs/${NEW_PROJECT}_debug_defconfig
		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g configs/${NEW_PROJECT}_defconfig
		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g configs/${NEW_PROJECT}_debug_defconfig
		echo "create"$PWD"mach-"${PALTFORM}"/"${NEW_PROJECT}"done!!!!!!"
	else
		echo $PWD"mach-"${PALTFORM}"/"${NEW_PROJECT}"is already create !!!!!!"
	fi

	cd -
  }
##############################################
# android                                    #
##############################################
  function clone_android() 
  {
	if [ ! -d "device/${COMPANY}/${NEW_PROJECT}" ];then
		cp -r device/${COMPANY}/${BASE_PROJECT} device/${COMPANY}/${NEW_PROJECT}
		mv device/${COMPANY}/${NEW_PROJECT}/full_${BASE_PROJECT}.mk \
			device/${COMPANY}/${NEW_PROJECT}/full_${NEW_PROJECT}.mk

		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g device/${COMPANY}/${NEW_PROJECT}/AndroidBoard.mk
		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g device/${COMPANY}/${NEW_PROJECT}/AndroidProducts.mk
		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g device/${COMPANY}/${NEW_PROJECT}/BoardConfig.mk
		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g device/${COMPANY}/${NEW_PROJECT}/device.mk
		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g device/${COMPANY}/${NEW_PROJECT}/full_${NEW_PROJECT}.mk

		sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g device/${COMPANY}/${NEW_PROJECT}/vendorsetup.sh
		echo $PWD"device/"${COMPANY}"/"${NEW_PROJECT}" create done !!!!!!"
	else
		echo $PWD"device/"${COMPANY}"/"${NEW_PROJECT}" is already create !!!!!!"
	fi


	if [ ! -d "vendor/mediatek/proprietary/custom/${NEW_PROJECT}" ];then
		cp -r vendor/mediatek/proprietary/custom/${BASE_PROJECT} \
					vendor/mediatek/proprietary/custom/${NEW_PROJECT} 

#sed -i s/${BASE_PROJECT}/${NEW_PROJECT}/g \

##############################################
#	vendor/mediatek/proprietary/custom/${NEW_PROJECT}/Android.mk
   
		echo $PWD"vendor/mediatek/proprietary/custom/"${NEW_PROJECT} " create done !!!!!"
	else
		echo $PWD"vendor/mediatek/proprietary/custom/"${NEW_PROJECT} " is already create !!!!!"
	fi
# share libs
#sed -i s#vendor/${COMPANY}/libs/${NEW_PROJECT}#vendor/${COMPANY}/libs/${BASE_PROJECT}#g \
#	device/${COMPANY}/${NEW_PROJECT}/device.mk
#no share libs 
#cp -r vendor/${COMPANY}/libs/${BASE_PROJECT} vendor/${COMPANY}/libs/${NEW_PROJECT}
	cd vendor/${COMPANY}/libs/
	ln -sf ${BASE_PROJECT} ${NEW_PROJECT}   
	cd -
	echo "clone android end ......"

  }

  function main()
  {
	clone_preloader
	clone_lk
	clone_kernel
	clone_android
  } 


# run function main() 
  main

else 
  echo ./clone_project.sh BASE_PROJECT NEW_PROJECT
fi 
