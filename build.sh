#!/bin/bash
set -e

TOP_DIR=`pwd`

get_root()
{
	for ((i = 0; i < 5; i++)); do
		PASSWD=$(whiptail --title "GNFC Build System" \
	               --passwordbox "Enter your root password. Note! Don't use root to run this scripts" 10 60 3>&1 1>&2 2>&3)
					
	        if [ $i = "4" ]; then
		        whiptail --title "Note Box" --msgbox "Error, Invalid password" 10 40 0
		        exit 0
		fi

	        sudo -k

		if sudo -lS &> /dev/null << EOF
$PASSWD
EOF
		then
			i=10
	        else
		        whiptail --title "GNFC Build System" --msgbox "Invalid password, Pls input corrent password" \
								            10 40 0 --cancel-button Exit --ok-button Retry
		fi
	done
	
	echo $PASSWD | sudo ls &> /dev/null 2>&1
}

get_root



prepare_tools()
{
	if ! hash apt-get 2>/dev/null; then
		whiptail --title "GNFC Build System" --msgbox "This scripts requires a Debian based distrbution. If you not use Debian/Ubunut, pls install:[ gcc automake make cmake curl dosfstools figlet ]"
	        exit 1
	fi
	sudo apt-get -y --no-install-recommends --fix-missing install \
	        gcc automake make cmake curl \
		dosfstools figlet 1>/dev/null
}



LIBNFC=("libnfc" "master")
LIBFREEFARE=("libfreefare" "master")
LIBNDEF=("libndef" "fix/includes")
LIBLLCP=("libllcp" "master")
GNFC=("GNFC" "master")


KINGSL_GIT="https://github.com/kingsl"

echo "$KINGSL_GIT"

PLATFORM="NFCGUI"

download_code()
{
	set -x

	PLAT_DIR="$(realpath "${TOP_DIR}")"

	LIBNFC_GIT="${KINGSL_GIT}/"${LIBNFC[0]}".git"
	LIBFREEFARE_GIT="${KINGSL_GIT}/"${LIBFREEFARE[0]}".git"
	LIBNDEF_GIT="${KINGSL_GIT}/"${LIBNDEF[0]}".git"
	LIBLLCP_GIT="${KINGSL_GIT}/"${LIBLLCP[0]}".git"
	GNFC_GIT="${KINGSL_GIT}/"${GNFC[0]}".git"

	SDK_GIT=(
		${LIBNFC_GIT}
		${LIBFREEFARE_GIT}
		${LIBNDEF_GIT}
		${LIBLLCP_GIT}
		${GNFC_GIT}
	)
																					
	SDK_BR=(
		${LIBNFC[1]}
		${LIBFREEFARE[1]}
		${LIBNDEF[1]}
		${LIBLLCP[1]}
		${GNFC[1]}
	)

	SDK_DIR=(
		libnfc
		libfreefare
		libllcp
		libndef
		GNFC
	)

	for ((i = 0; i < 5; i++))
	do
		if [ ! -d "${PLAT_DIR}/${SDK_DIR[i]}" ]; then
            		echo -e "\e[1;31m Download from : "${SDK_GIT[i]}" \e[0m"
			git clone --depth=1 "${SDK_GIT[i]}" "${PLAT_DIR}/${SDK_DIR[i]}" --branch "${SDK_BR[i]}"
        	else
            		echo -e "\e[1;31m Update from : "${SDK_GIT[i]}" \e[0m"
            		cd "${PLAT_DIR}/${SDK_DIR[i]}"
            		git pull
			cd -
	        fi


		cd "${PLAT_DIR}/${SDK_DIR[i]}"
		if [ "${SDK_DIR[i]}" = libllcp ]; then
			qmake
			make
			sudo make install
		elif [ "${SDK_DIR[i]}" = GNFC ]; then
			echo "Open QT Creator"
		else
		        	
		       	autoreconf -vis
	       		./configure --prefix=/usr
	 		make
			sudo make install		
		fi
		cd -


	done

	whiptail --title "GNFC Build System" --msgbox \
			"`figlet GNFC` Succeed to download "${PLATFORM}" build system!        Path: "${PLAT_DIR}"" 15 50 0
	clear
}

download_code

echo "You can now open you project on QT Creator"








