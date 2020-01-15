# GNFC Setup Script

Simple Bash script to install GNFC dependencies on a \*nix system. Script based on Orange Pi Build system script available on [https://github.com/orangepi-xunlong/OrangePi_Build](https://github.com/orangepi-xunlong/OrangePi_Build)

Clone this  repository and run the build script to download the source code for GNFC and its dependencies:
      
```
git clone https://github.com/kingsl/GNFCScript.git
```
      
After downloading this repo, change dir to (you may want to change the dir name to something more meaningful to you)
      
```
cd GNFCScript
```

Run the script by typing:
```
./build.sh
```

The script will clone all the dependencies, build them and install them on your system. You will then be able to open GNFC project with QT Creator.

Good luck!
