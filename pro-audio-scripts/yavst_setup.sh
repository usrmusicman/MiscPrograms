#!/bin/sh

# Path for the YaVST bundle
BUNDLE_PATH="$HOME/.plugins/YaVST"
WINE_VER=9.21
YABRIDGE_VER=5.1.1

if [[ "$#" == "1" ]]; then
    if [[ "$1" == "install" ]]; then
        # Make YaVST bundle directory and wine installation directory
        mkdir -p $BUNDLE_PATH

        # Make the yabridge directory
        mkdir -p $HOME/.local/share/yabridge

        # Download and install Yabridge
        wget https://github.com/robbert-vdh/yabridge/releases/download/${YABRIDGE_VER}/yabridge-${YABRIDGE_VER}.tar.gz
        tar -xvzf ${PWD}/yabridge-${YABRIDGE_VER}.tar.gz
        cp -rvf ${PWD}/yabridge/* $HOME/.local/share/yabridge

        # Download and unzip wine
        wget https://github.com/Kron4ek/Wine-Builds/releases/download/${WINE_VER}/wine-${WINE_VER}-staging-tkg-amd64-wow64.tar.xz
        tar -xvJf ${PWD}/wine-${WINE_VER}-staging-tkg-amd64-wow64.tar.xz
        cp -rvf ${PWD}/wine-${WINE_VER}-staging-tkg-amd64-wow64/* $BUNDLE_PATH

        # Create Link to Yabridge directory
        ln -sf $HOME/.local/share/yabridge $BUNDLE_PATH


    elif [[ "$1" == "setenv" ]]; then
        echo "" >> $HOME/.bashrc
        echo "## Setup Yabridge VST Environment (For Bazzite and other immutable distros)" >> $HOME/.bashrc
        echo "declare -r BUNDLE_PATH=\"$BUNDLE_PATH\"" >> $HOME/.bashrc
        echo "export YAVST_PATH=\"\$BUNDLE_PATH\"" >> $HOME/.bashrc
        echo "export WINEVERPATH=\"\$YAVST_PATH\"" >> $HOME/.bashrc
        echo "export PATH=\"\$YAVST_PATH/bin:\$PATH\"" >> $HOME/.bashrc
        echo "export WINESERVER=\"\$YAVST_PATH/bin/wineserver\"" >> $HOME/.bashrc
        echo "export WINELOADER=\"\$YAVST_PATH/bin/wine\"" >> $HOME/.bashrc
        echo "export WINEDLLPATH=\"\$YAVST_PATH/lib/wine/fakedlls\"" >> $HOME/.bashrc
        echo "export LD_LIBRARY_PATH=\"\$YAVST_PATH/lib:\$LD_LIBRARY_PATH\"" >> $HOME/.bashrc

    elif [[ "$1" == "uninstall" ]]; then
        rm -rvf $BUNDLE_PATH
        rm -rvf $HOME/.local/share/yabridge

    else
        echo "Usage: yavst_setup.sh <argument>"
        echo "install - Installs the bundle"
        echo "setenv - Creates the relevant environment variables in $HOME/.bashrc"
        echo "uninstall - Uninstalls the bundle"

    fi

else
    echo "Please type in a valid argument for this script"

fi
