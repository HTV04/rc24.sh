#!/usr/bin/env bash

# rc24.sh v1.0 beta 1
# By HTV04 and SketchMaster2001

# Print with word wrap
rc24print () {
	printf "${1}" | fold -s -w $(tput cols)
}

# Print title
rc24title () {
	rc24print "${rc24_str}====${1}"
	printf "=%.0s" $(seq 1 $(($(tput cols) - (${#1} + 4))))
	rc24print "\n\n"
}

# Print subtitle
rc24subtitle () {
	rc24print "\055---${1}"
	printf "\055%.0s" $(seq 1 $(($(tput cols) - (${#1} + 4))))
	rc24print "\n${2}\n"
	printf "\055%.0s" $(seq 1 $(tput cols))
	rc24print "\n\n"
}

#Get the certificates from the repo

cetkget() {
	curl --create-dirs -s -o $(dirname ${0})/Files/Patcher/${1}/${2}/cetk $FilesHostedOn/RC24_Patcher/${1}/${2}/cetk
} >> rc24output.txt 2>&1

# Get file from RiiConnect24 website and save it to output
rc24get () {
	curl --create-dirs -f -k -L -o ${2} -S -s https://patcher.rc24.xyz/update/RiiConnect24-Patcher/v1/${1}
} >> rc24output.txt 2>&1

# Patch IOS
rc24patchios () {
	mkdir -p Temp/Working/Wii/IOS${1}
	
	./Sharpii nusd -ios ${1} -v ${2} -o Temp/Working/Wii/IOS${1}/Temp.wad -wad
	./Sharpii wad -u Temp/Working/Wii/IOS${1}/Temp.wad Temp/Working/Wii/IOS${1}
	
	xdelta3 -d -f -s Temp/Working/Wii/IOS${1}/00000006.app Temp/Files/Patcher/Wii/IOS${1}/00000006.delta Temp/Working/Wii/IOS${1}/00000006_patched.app
	
	mv -f Temp/Working/Wii/IOS${1}/00000006_patched.app Temp/Working/Wii/IOS${1}/00000006.app
	
	./Sharpii wad -p Temp/Working/Wii/IOS${1} "${out_path}/WAD/IOS${1}(Wii Only).wad" -f
	
	./Sharpii ios "${out_path}/WAD/IOS${1}(Wii Only).wad" -fs -es -np -vp
} >> rc24output.txt 2>&1

# Patch title
rc24patchtitle () {
	mkdir -p Temp/Working/${1}
	if [ -f Files/Patcher/${1}/${region}/cetk ]
	then
		cp Files/Patcher/${1}/${region}/cetk Temp/Working/${1}
	fi
	
	./Sharpii nusd -id ${2}${region_hex} -v ${3} -o Temp/Working/${1} -wad
	./Sharpii wad -u Temp/Working/${1}/${2}${region_hex}v${3}.wad Temp/Working/${1}
	
	xdelta3 -d -f -s Temp/Working/${1}/${4}.app Temp/Files/Patcher/${1}/${region}/${4}.delta Temp/Working/${1}/${4}_patched.app
	
	mv -f Temp/Working/${1}/${4}_patched.app Temp/Working/${1}/${4}.app
	
	./Sharpii wad -p Temp/Working/${1} "${out_path}/WAD/${5} (${region}).wad" -f
} >> rc24output.txt 2>&1

# Patch title with two patch files
rc24patchtitle2 () {
	mkdir -p Temp/Working/${1}
	if [ -f Files/Patcher/${1}/${region}/cetk ]
	then
		cp Files/Patcher/${1}/${region}/cetk Temp/Working/${1}
	fi
	
	./Sharpii nusd -id ${2}${region_hex} -v ${3} -o Temp/Working/${1} -wad
	./Sharpii wad -u Temp/Working/${1}/${2}${region_hex}v${3}.wad Temp/Working/${1}
	
	xdelta3 -d -f -s Temp/Working/${1}/${4}.app Temp/Files/Patcher/${1}/${region}/${4}.delta Temp/Working/${1}/${4}_patched.app
	xdelta3 -d -f -s Temp/Working/${1}/${5}.app Temp/Files/Patcher/${1}/${region}/${5}.delta Temp/Working/${1}/${5}_patched.app
	
	mv -f Temp/Working/${1}/${4}_patched.app Temp/Working/${1}/${4}.app
	mv -f Temp/Working/${1}/${5}_patched.app Temp/Working/${1}/${5}.app
	
	./Sharpii wad -p Temp/Working/${1} "${out_path}/WAD/${6} (${region}).wad" -f
} >> rc24output.txt 2>&1

# Patch title with vWii attributes
rc24patchtitlevwii () {
	mkdir -p Temp/Working/${1}
	
	./Sharpii nusd -id ${2}${region_hex} -v ${3} -o Temp/Working/${1} -wad
	./Sharpii wad -u Temp/Working/${1}/${2}${region_hex}v${3}.wad Temp/Working/${1}
	
	xdelta3 -d -f -s Temp/Working/${1}/${4}.app Temp/Files/Patcher/${1}/${4}.delta Temp/Working/${1}/${4}_patched.app
	
	mv -f Temp/Working/${1}/${4}_patched.app Temp/Working/${1}/${4}.app
	
	./Sharpii wad -p Temp/Working/${1} "${out_path}/WAD/${5} vWii ${region}.wad" -f
} >> rc24output.txt 2>&1



# Try to detect SD card by looking for "apps" directory in root (to do: fix for Linux)
rc24detectsd () {
	for i in /Volumes/*/
	do
		if [[ -d $i/apps ]]
		then
			out_path="$i"
		fi
	done
}

# Change the output path manually
rc24changeoutpath () {
    clear
    
	rc24title "Change Output Path"
	
	rc24print "Current output path: $out_path\n\n"
    
	read -p "Type in the new path to store files (e.g. /Volumes/Wii): " out_path
}



# Choose device to patch (to do: remove "prepare" from Wii and vWii options after uninstall mode added)
rc24device () {
	while true
	do
		clear
		
		rc24title "Choose Device"
		rc24print "Welcome to rc24.sh!\nWith this program, you can patch your Wii or Wii U for use with RiiConnect24.\n\nSo, what device are we patching today?\n\n1. Wii\n2. vWii (Wii U)\n\n"
		
		read -p "Choose an option: " choice
		case ${choice} in
			1)
				rc24_device=wii
				
				rc24wiiprepare
				
				break
				;;
			2)
				rc24_device=vwii
				
				rc24vwiiprepare
				
				break
				;;
		esac
	done
}

# rc24.sh credits
rc24credits () {
	clear
	
	rc24title "rc24.sh Credits"
	rc24print "Credits:\n    - HTV04 and SketchMaster2001: rc24.sh developers\n    - TheShadowEevee, person66, and leathl: Sharpii-NetCore, Sharpii, and libWiiSharp developers\n    - KcrPL and Larsenv: RiiConnect24 founders, original RiiConnect24 Patcher developers\n    - And you!\n\nSource code: https://github.com/HTV04/rc24.sh\nRiiConnect24 website: https://rc24.xyz/\n\nrc24.sh and RiiConnect24 are made by Wii fans, for Wii fans!\n\n"
	
	read -n 1 -p "Press any key to return to the main menu."
}

# Refresh patcher screen (updates screen after patcher phase is completed)
rc24refresh () {
	clear
	
	if [ ${rc24_device} = wii ]
	then
		rc24title "Installing RiiConnect24 (Wii)"
	elif [ ${rc24_device} = vwii ]
	then
		rc24title "Installing RiiConnect24 (vWii)"
	fi
	rc24print "Now patching. This may take a few minutes, depending on your internet speed.\n\n"
	
	if [ ${patch[0]} = 1 ]
	then
		if [ ${patched[0]} = 1 ]
		then
			rc24print "[X] System Patches\n"
		else
			rc24print "[ ] System Patches\n"
		fi
	fi
	if [ ${patch[1]} = 1 ]
	then
		if [ ${patched[1]} = 1 ]
		then
			rc24print "[X] Forecast and News Channels\n"
		else
			rc24print "[ ] Forecast and News Channels\n"
		fi
	fi
	if [ ${patch[2]} = 1 ]
	then
		if [ ${patched[2]} = 1 ]
		then
			rc24print "[X] Check Mii Out/Mii Contest Channel\n"
		else
			rc24print "[ ] Check Mii Out/Mii Contest Channel\n"
		fi
	fi
	if [ ${patch[3]} = 1 ]
	then
		if [ ${patched[3]} = 1 ]
		then
			rc24print "[X] Everybody Votes Channel\n"
		else
			rc24print "[ ] Everybody Votes Channel\n"
		fi
	fi
	if [ ${patch[4]} = 1 ]
	then
		if [ ${patched[4]} = 1 ]
		then
			rc24print "[X] Nintendo Channel\n"
		else
			rc24print "[ ] Nintendo Channel\n"
		fi
	fi
	
	rc24subtitle "Fun Fact" "${rc24_facts[${RANDOM} % ${#rc24_facts[@]}]}"
}

# Patcher finish message
rc24finish () {
	clear
	
	rm -rf Temp
	
	rc24title "Complete"
	rc24print "rc24.sh has succesfully completed the requested operation.\n\nOutput has been saved to \"rc24output.txt,\" in case you need it.\n\n"
	
	read -n 1 -p "Press any key to return to the main menu."
}

# Choose region
rc24region () {
	while true
	do
		clear
		
		rc24title "Choose Region"
		rc24print "What region is your device from?\n1. Europe (PAL)\n2. Japan (NTSC-J)\n3. USA (NTSC-U)\n\n"
		
		read -p "Choose an option: " choice
		case ${choice} in
			1)
				region=EUR
				region_hex=50
				
				break
				;;
			2)
				region=JPN
				region_hex=4a
				
				break
				;;
			3)
				region=USA
				region_hex=45

				break
				;;
		esac
	done
}

# Custom patch options
rc24custom () {
	patch=(1 1 0 0 0)
	apps=1
	
	while true
	do
		clear
		
		if [ ${rc24_device} = wii ]
		then
			rc24title "Custom Install (Wii)"
		elif [ ${rc24_device} = vwii ]
		then
			rc24title "Custom Install (vWii)"
		fi
		rc24print "The recommended options for a new RiiConnect24 install are toggled on by default.\n\n"
		
		if [ ${patch[0]} = 1 ]
		then
			rc24print "1. [X] System Patches (Required, only toggle off if already installed!)\n"
		else
			rc24print "1. [ ] System Patches (Required, only toggle off if already installed!)\n"
		fi
		if [ ${patch[1]} = 1 ]
		then
			rc24print "2. [X] Forecast and News Channels\n"
		else
			rc24print "2. [ ] Forecast and News Channels\n"
		fi
		if [ ${patch[2]} = 1 ]
		then
			rc24print "3. [X] Check Mii Out/Mii Contest Channel\n"
		else
			rc24print "3. [ ] Check Mii Out/Mii Contest Channel\n"
		fi
		if [ ${patch[3]} = 1 ]
		then
			rc24print "4. [X] Everybody Votes Channel\n"
		else
			rc24print "4. [ ] Everybody Votes Channel\n"
		fi
		if [ ${patch[4]} = 1 ]
		then
			rc24print "5. [X] Nintendo Channel\n\n"
		else
			rc24print "5. [ ] Nintendo Channel\n\n"
		fi
		
		if [ ${apps} = 1 ]
		then
			rc24print "6. [X] Download Utilities (Required, only toggle off if already installed!)\n\n"
		else
			rc24print "6. [ ] Download Utilities (Required, only toggle off if already installed!)\n\n"
		fi
		
		rc24print "7. Continue\n\n"
		
		read -n 1 -p "Type the number of an option to toggle it:" choice
		case ${choice} in
			1)
				patch[0]=$((1 - ${patch[0]}))
				;;
			2)
				patch[1]=$((1 - ${patch[1]}))
				;;
			3)
				patch[2]=$((1 - ${patch[2]}))
				;;
			4)
				patch[3]=$((1 - ${patch[3]}))
				;;
			5)
				patch[4]=$((1 - ${patch[4]}))
				;;
			
			6)
				apps=$((1 - ${apps}))
				;;
			
			7)
				break
				;;
		esac
	done
}



# Choose Wii patcher mode (currently unused)
rc24wii () {
	while true
	do
		clear
		
		rc24title "Patcher Mode (Wii)"
		rc24print "1. Install RiiConnect24 on your Wii\n   - The patcher will guide you through process of installing RiiConnect24.\n\n2. Uninstall RiiConnect24 from your Wii\n   - This will help you uninstall RiiConnect24 from your Wii.\n\n"
		
		read -p "Choose an option: " choice
		case ${choice} in
			1)
				rc24wiiprepare
				break
				;;
		esac
	done
}

# Prepare Wii patch
rc24wiiprepare () {
	while true
	do
		clear
		
		rc24title "Preparing to Install RiiConnect24 (Wii)"
		rc24print "Choose instalation type:\n1. Express (Recommended)\n  - This will patch every channel for later use on your Wii. This includes:\n    - Check Mii Out Channel/Mii Contest Channel\n    - Everybody Votes Channel\n    - Forecast Channel\n    - News Channel\n    - Nintendo Channel\n    - Wii Mail\n\n2. Custom\n   - You will be asked what you want to patch.\n\n3. Back\n\n"
		
		read -p "Choose an option: " choice
		case ${choice} in
			1)
				rc24region
				patch=(1 1 1 1 1)
				apps=1
				rc24wiipatch
				rc24finish
				break
				;;
			2)
				rc24region
				rc24custom
				rc24wiipatch
				rc24finish
				break
				;;
			3)
				break
				;;
		esac
	done
}

# Wii patching process
rc24wiipatch () {
	patched=(0 0 0 0 0 0)
	rc24refresh
	
	$dwn_sharpii
	chmod +x Sharpii
	mkdir -p "${out_path}/WAD"
	mkdir -p "${out_path}/apps"

	if [ ${patch[0]} = 1 ]
	then
		rc24get IOSPatcher/00000006-31.delta Temp/Files/Patcher/Wii/IOS31/00000006.delta
		rc24get IOSPatcher/00000006-80.delta Temp/Files/Patcher/Wii/IOS80/00000006.delta
		
		rc24patchios 31 3608
		rc24patchios 80 6944
		
		patched[0]=1
		rc24refresh
	fi
	if [ ${patch[1]} = 1 ]
	then
		if [ ${region} = EUR ]
		then
			rc24get NewsChannelPatcher/URL_Patches/Europe/00000001_Forecast.delta Temp/Files/Patcher/Wii/FC/${region}/00000001.delta
			rc24get NewsChannelPatcher/URL_Patches/Europe/00000001_News.delta Temp/Files/Patcher/Wii/NC/${region}/00000001.delta
		elif [ ${region} = JPN ]
		then
			rc24get NewsChannelPatcher/URL_Patches/Japan/00000001_Forecast.delta Temp/Files/Patcher/Wii/FC/${region}/00000001.delta
			rc24get NewsChannelPatcher/URL_Patches/Japan/00000001_News.delta Temp/Files/Patcher/Wii/NC/${region}/00000001.delta
		elif [ ${region} = USA ]
		then
			rc24get NewsChannelPatcher/URL_Patches/USA/00000001_Forecast.delta Temp/Files/Patcher/Wii/FC/${region}/00000001.delta
			rc24get NewsChannelPatcher/URL_Patches/USA/00000001_News.delta Temp/Files/Patcher/Wii/NC/${region}/00000001.delta
		fi
		
		rc24patchtitle Wii/FC 00010002484146 7 00000001 "Forecast Channel"
		rc24patchtitle Wii/NC 00010002484147 7 00000001 "News Channel"
		
		patched[1]=1
		rc24refresh
	fi
	if [ ${patch[2]} = 1 ]
	then
		if [ ${region} = EUR ]
		then
			cetkget CMOC EUR
			rc24get CMOCPatcher/patch/00000001_Europe.delta Temp/Files/Patcher/CMOC/EUR/00000001.delta
			rc24get CMOCPatcher/patch/00000004_Europe.delta Temp/Files/Patcher/CMOC/EUR/00000004.delta
		elif [ ${region} = JPN ]
		then
			rc24get CMOCPatcher/patch/00000001_Japan.delta Temp/Files/Patcher/CMOC/JPN/00000001.delta
			rc24get CMOCPatcher/patch/00000004_Japan.delta Temp/Files/Patcher/CMOC/JPN/00000004.delta
		elif [ ${region} = USA ]
		then
			cetkget CMOC USA
			rc24get CMOCPatcher/patch/00000001_USA.delta Temp/Files/Patcher/CMOC/USA/00000001.delta
			rc24get CMOCPatcher/patch/00000004_USA.delta Temp/Files/Patcher/CMOC/USA/00000004.delta
		fi
		
		if [ ${region} = EUR ]
		then
			rc24patchtitle2 CMOC 00010001484150 512 00000001 00000004 "Mii Contest Channel"
		else
			rc24patchtitle2 CMOC 00010001484150 512 00000001 00000004 "Check Mii Out Channel"
		fi
		
		patched[2]=1
		rc24refresh
	fi
	if [ ${patch[3]} = 1 ]
	then
		if [ ${region} = EUR ]
		then
			cetkget EVC EUR
			rc24get EVCPatcher/patch/Europe.delta Temp/Files/Patcher/EVC/EUR/00000001.delta
		elif [ ${region} = JPN ]
		then
			rc24get EVCPatcher/patch/JPN.delta Temp/Files/Patcher/EVC/JPN/00000001.delta
		elif [ ${region} = USA ]
		then
			cetkget EVC USA
			curl --create-dirs -s -o $(dirname ${0})/Files/Patcher/EVC/$region/cetk $FilesHostedOn/RC24_Patcher/EVC/${region}/cetk
			rc24get EVCPatcher/patch/USA.delta Temp/Files/Patcher/EVC/USA/00000001.delta
		fi
		
		rc24patchtitle EVC 0001000148414a 512 00000001 "Everybody Votes Channel"
		
		patched[3]=1
		rc24refresh
	fi
	if [ ${patch[4]} = 1 ]
	then
		curl --create-dirs -s -o $(dirname ${0})/Files/Patcher/NC/$region/cetk $FilesHostedOn/RC24_Patcher/NC/${region}/cetk
		
		if [ ${region} = EUR ]
		then
			cetkget NC EUR
			rc24get NCPatcher/patch/Europe.delta Temp/Files/Patcher/NC/EUR/00000001.delta
		elif [ ${region} = JPN ]
		then
			rc24get NCPatcher/patch/JPN.delta Temp/Files/Patcher/NC/JPN/00000001.delta
		elif [ ${region} = USA ]
		then
			cetkget NC USA
			rc24get NCPatcher/patch/USA.delta Temp/Files/Patcher/NC/USA/00000001.delta
		fi
		
		rc24patchtitle NC 00010001484154 1792 00000001 "Nintendo Channel"
		
		patched[4]=1
		rc24refresh
	fi
	
	if [ ${apps} = 1 ]
	then
		rc24get apps/Mail-Patcher/boot.dol "${out_path}/apps/Mail-Patcher/boot.dol"
		rc24get apps/Mail-Patcher/icon.png "${out_path}/apps/Mail-Patcher/icon.png"
		rc24get apps/Mail-Patcher/meta.xml "${out_path}/apps/Mail-Patcher/meta.xml"
		rc24get apps/WiiModLite/boot.dol "${out_path}/apps/WiiModLite/boot.dol"
		rc24get apps/WiiModLite/icon.png "${out_path}/apps/WiiModLite/icon.png"
		rc24get apps/WiiModLite/meta.xml "${out_path}/apps/WiiModLite/meta.xml"
	fi

	rm -rf Files
}



# Choose vWii patcher mode (currently unused)
rc24vwii () {
	while true
	do
		clear
		
		rc24title "Patcher Mode (vWii)"
		rc24print "1. Install RiiConnect24 on your vWii\n   - The patcher will guide you through process of installing RiiConnect24.\n\n2. Uninstall RiiConnect24 from your vWii\n   - This will help you uninstall RiiConnect24 from your vWii.\n\n"
		
		read -p "Choose an option: " choice
		case ${choice} in
			1)
				rc24vwiiprepare
				break
				;;
		esac
	done
}

# Prepare vWii patch
rc24vwiiprepare () {
	while true
	do
		clear
		
		rc24title "Preparing to Install RiiConnect24 (vWii)"
		rc24print "Choose instalation type:\n1. Express (Recommended)\n  - This will patch every channel for later use on your vWii. This includes:\n    - Check Mii Out Channel/Mii Contest Channel\n    - Everybody Votes Channel\n    - Forecast Channel\n    - News Channel\n    - Nintendo Channel\n\n2. Custom\n   - You will be asked what you want to patch.\n\n3. Back\n\n"
		
		read -p "Choose an option: " choice
		case ${choice} in
			1)
				rc24region
				patch=(1 1 1 1 1)
				apps=1
				rc24vwiipatch
				rc24finish
				break
				;;
			2)
				rc24region
				rc24custom
				rc24vwiipatch
				rc24finish
				break
				;;
			3)
				break
				;;
		esac
	done
}

# vWii patching process
rc24vwiipatch () {
	patched=(0 0 0 0 0 0)
	rc24refresh
	
	$dwn_sharpii
	chmod +x Sharpii
	mkdir -p "${out_path}/WAD"
	mkdir -p "${out_path}/apps"
	
	if [ ${patch[0]} = 1 ]
	then
		rc24get IOSPatcher/IOS31_vwii.wad "${out_path}/WAD/IOS31_vWii_Only.wad"
		
		patched[0]=1
		rc24refresh
	fi
	if [ ${patch[1]} = 1 ]
	then
		rc24get NewsChannelPatcher/00000001.delta Temp/Files/Patcher/vWii/NC/00000001.delta
		rc24get NewsChannelPatcher/URL_Patches_WiiU/00000001_Forecast_All.delta Temp/Files/Patcher/vWii/FC/00000001.delta
		
		rc24patchtitlevwii vWii/FC 00010002484146 7 00000001 "Forecast Channel"
		rc24patchtitlevwii vWii/NC 00010002484147 7 00000001 "News Channel"
		
		patched[1]=1
		rc24refresh
	fi
	if [ ${patch[2]} = 1 ]
	then
		if [ ${region} = EUR ]
		then
			cetkget CMOC EUR
			rc24get CMOCPatcher/patch/00000001_Europe.delta Temp/Files/Patcher/CMOC/EUR/00000001.delta
			rc24get CMOCPatcher/patch/00000004_Europe.delta Temp/Files/Patcher/CMOC/EUR/00000004.delta
		elif [ ${region} = JPN ]
		then
			rc24get CMOCPatcher/patch/00000001_Japan.delta Temp/Files/Patcher/CMOC/JPN/00000001.delta
			rc24get CMOCPatcher/patch/00000004_Japan.delta Temp/Files/Patcher/CMOC/JPN/00000004.delta
		elif [ ${region} = USA ]
		then
			cetkget CMOC USA
			rc24get CMOCPatcher/patch/00000001_USA.delta Temp/Files/Patcher/CMOC/USA/00000001.delta
			rc24get CMOCPatcher/patch/00000004_USA.delta Temp/Files/Patcher/CMOC/USA/00000004.delta
		fi
		
		if [ ${region} = EUR ]
		then
			rc24patchtitle2 CMOC 00010001484150 512 00000001 00000004 "Mii Contest Channel"
		else
			rc24patchtitle2 CMOC 00010001484150 512 00000001 00000004 "Check Mii Out Channel"
		fi
		
		patched[2]=1
		rc24refresh
	fi
	if [ ${patch[3]} = 1 ]
	then
		curl --create-dirs -s -o $(dirname ${0})/Files/Patcher/${1}/$region/cetk $FilesHostedOn/RC24_Patcher/${1}/${region}/cetk
		
		if [ ${region} = EUR ]
		then
			cetkget EVC EUR
			rc24get EVCPatcher/patch/Europe.delta Temp/Files/Patcher/EVC/EUR/00000001.delta
		elif [ ${region} = JPN ]
		then
			rc24get EVCPatcher/patch/JPN.delta Temp/Files/Patcher/EVC/JPN/00000001.delta
		elif [ ${region} = USA ]
		then
			cetkget EVC USA
			rc24get EVCPatcher/patch/USA.delta Temp/Files/Patcher/EVC/USA/00000001.delta
		fi
	
		rc24patchtitle EVC 0001000148414a 512 00000001 "Everybody Votes Channel"
		
		patched[3]=1
		rc24refresh
	fi
	if [ ${patch[4]} = 1 ]
	then
		curl --create-dirs -s -o $(dirname ${0})/Files/Patcher/${1}/$region/cetk $FilesHostedOn/RC24_Patcher/${1}/${region}/cetk
		
		if [ ${region} = EUR ]
		then
			cetkget NC EUR
			rc24get NCPatcher/patch/Europe.delta Temp/Files/Patcher/NC/EUR/00000001.delta
		elif [ ${region} = JPN ]
		then
			rc24get NCPatcher/patch/JPN.delta Temp/Files/Patcher/NC/JPN/00000001.delta
		elif [ ${region} = USA ]
		then
			cetkget NC USA
			rc24get NCPatcher/patch/USA.delta Temp/Files/Patcher/NC/USA/00000001.delta
		fi
	
		rc24patchtitle NC 00010001484154 1792 00000001 "Nintendo Channel"
		
		patched[4]=1
		rc24refresh
	fi
	
	if [ ${apps} = 1 ]
	then
		rc24get apps/ConnectMii_WAD/ConnectMii.wad "${out_path}/WAD/ConnectMii.wad"
		rc24get apps/ww-43db-patcher/boot.dol "${out_path}/apps/ww-43db-patcher/boot.dol"
		rc24get apps/ww-43db-patcher/icon.png "${out_path}/apps/ww-43db-patcher/icon.png"
		rc24get apps/ww-43db-patcher/meta.xml "${out_path}/apps/ww-43db-patcher/meta.xml"
		rc24get apps/WiiModLite/boot.dol "${out_path}/apps/WiiModLite/boot.dol"
		rc24get apps/WiiModLite/icon.png "${out_path}/apps/WiiModLite/icon.png"
		rc24get apps/WiiModLite/meta.xml "${out_path}/apps/WiiModLite/meta.xml"
	fi

	rm -rf Files
}



# Setup
clear

cd $(dirname ${0})

rm -rf Temp

beta=1
ver="v1.0 beta 1"

rc24_facts=("Did you know that the Wii was the best selling game-console of 2006?" "RiiConnect24 originally started out as \"CustomConnect24!\"" "Did you the RiiConnect24 logo was made by NeoRame, the same person who made the Wiimmfi logo?" "The Wii was codenamed \"Revolution\" during its development stage." "Did you know the letters in the Wii model number \"RVL\" stands for the Wii's codename, \"Revolution\"?" "The music used in many of the Wii's channels (including the Wii Shop, Mii, Check Mii Out, and Forecast Channels) was composed by Kazumi Totaka." "The Internet Channel once costed 500 Wii Points, but was later made freeware." "It's possible to use candles as a Wii Sensor Bar." "The blinking blue light that indicates a system message has been received is actually synced to the bird call of the Japanese bush warbler." "Wii Sports is the most sold game on the Wii. It sold 82.85 million copies." "Did you know that most of the scripts used to make RiiConnect24 work are written in Python?" "Thanks to Spotlight for making RiiConnect24's mail system secure!" "Did you know that RiiConnect24 has a Discord server where you can stay updated about the project status?" "The Everybody Votes Channel was originally an idea about sending quizzes and questions daily to Wii consoles." "The News Channel developers had an idea at some point about making a dad's Mii the news caster in the channel, but it probably didn't make the cut because some articles aren't appropriate for kids." "The Everybody Votes Channel was originally called the \"Questionnaire Channel\", then \"Citizens Vote Channel.\"" "The Forecast Channel has a \"laundry index\" to show how appropriate it is to dry your clothes outside, and a \"pollen count\" in the Japanese version." "During the development of the Forecast Channel, Nintendo of America's department got hit by a thunderstorm, and the developers of the channel in Japan lost contact with them." "The News Channel has an alternate slide show song that plays at night." "During E3 2006, Satoru Iwata said WiiConnect24 uses as much power as a miniature lightbulb while the console is in Standby mode." "The effect used when rapidly zooming in and out of photos on the Photo Channel was implemented into the News Channel to zoom in and out of text." "The help cats in the News Channel and the Photo Channel are brother and sister (the one in the News Channel being male, and the Photo Channel being a younger female)." "The Japanese version of the Forecast Channel does not show the current forecast." "The Forecast Channel, News Channel and the Photo Channel were made by nearly the same team." "The first worldwide Everybody Votes Channel question about if you like dogs or cats more got more than 500,000 votes." "The night song that plays when viewing the local forecast in the Forecast Channel was made before the day song, that was requested to make people not feel sleepy when it was played during the day." "The globe used in the Forecast and News Channels is based on imagery from NASA, and the same globe was used in Mario Kart Wii." "You can press the RESET button while the Wii is in Standby mode to turn off the blue light that glows when you receive a message.")

# Run checks
clear

rc24_str="rc24.sh ${ver}\nBy HTV04 and SketchMaster2001\n\n"

rc24print "${rc24_str}Now loading...\n\n"

rc24print "${rc24_str}==rc24.sh Patcher Output==\n\n" > rc24output.txt

if ! command -v curl >> rc24output.txt 2>&1
then
	rc24print "\"curl\" command not found! Please install the \"curl\" package using your package manager.\n\n"
	exit
fi
if ! command -v xdelta3 >> rc24output.txt 2>&1
then
	rc24print "\"xdelta3\" command not found! Please install the \"xdelta3\" package using your package manager.\n\n"
	exit
fi

if ! ping -c 1 -q -W 1 google.com >> rc24output.txt 2>&1
then
	rc24print "Unable to connect to internet! Please check your internet connection.\n\n"
	exit
fi

if ! ping -c 1 -q -W 1 nus.cdn.shop.wii.com >> rc24output.txt 2>&1
then
	rc24print "Warning: The NUS is either offline, or your device is unable to connect to it. The patcher will continue, but it may not function properly.\n\n"
	
	read -n 1 -p "Press any key to continue."
fi

#System Detection

case $(uname -m),$(uname) in
	x86_64,Darwin) sys="(macOS)" ;;
	x86_64,*) sys="(linux-x64)" ;;
	arm,*) sys="(linux-arm)" ;;
esac

#Download Files

FilesHostedOn=https://raw.githubusercontent.com/SketchMaster2001/SketchRepo/main
dwn_sharpii="curl -s -o $(dirname ${0})/sharpii $FilesHostedOn/RC24_Patcher/Sharpii/sharpii"$sys""

# SD card setup
clear

rc24title "Detecting SD Card"

rc24print "Looking for SD card (drive with \"apps\" folder in root)..."

out_path=Copy-to-SD
rc24detectsd

case ${out_path} in
	Copy-to-SD)
		rc24print "Looks like an SD Card wasn't found in your system.\n\nPlease choose the \"Change Path\" option to set your SD card or other destination path manually, otherwise you will have to copy them later from the \"Copy-to-SD\" folder, stored in the same directory as rc24.sh.\n\n" 
		;;
	*)
		rc24print "Successfully detected your SD Card: \"${out_path}\"\n\nEverything will be automatically downloaded and installed onto your SD card!\n\n" | fold -s -w "$(tput cols)"
		;;
esac

read -n 1 -p "Press any key to continue."



# Main menu
while true
do
	clear
	
	rc24title "Main Menu"
	if [ ${beta} = 1 ]
	then
		rc24subtitle "BETA Warning" "This version of rc24.sh is currently in beta. This means that you may experience bugs and encounter issues that would normally not be present in a stable version. If you encounter any bugs, please report them here:\n\nhttps://github.com/HTV04/rc24.sh/issues"
	fi
	rc24print "\"RiiConnect\" your Wii!\n\n1. Start\n   - Start patching.\n2. Credits\n   - See who made this possible!\n\n3. Exit\n\n"
	
	read -p "Choose an $out_path option (by typing its number and pressing return): " choice
	
	case ${choice} in
		1)
			rc24device
			;;
		2)
			rc24credits
			;;
		3)
			clear
			
			rc24print "Thank you for using this patcher! If you encountered any issues, please report them here:\n\nhttps://github.com/HTV04/rc24.sh/issues\n\n"
			
			exit
			;;
	esac
done


