#!/bin/sh

# Number of Arguments
if [[ "$#" == "1" ]]; then

    # Make Plugin Directories
    if [[ "$1" == "makedirs" ]]; then
        # Make amp plugin directories
        mkdir -p ${PWD}/{AmpLocker,MixLocker}
        # Make 5db5 plugin directories
        mkdir -p ${PWD}/{Channel551,DoubleTake,EchoVerb,Head\ Crusher,RM-2}/Presets

    # Amp Locker Plugin
    elif [[ "$1" == "amplocker" ]]; then
        if [ ! -d "${HOME}/Audio Assault/PluginData/Audio Assault/AmpLockerData" ]; then
            mkdir -p ${HOME}/Audio\ Assault/PluginData/Audio\ Assault
            ln -sf ${PWD}/AmpLocker/AmpLockerData ${HOME}/Audio\ Assault/PluginData/Audio\ Assault/AmpLockerData
        else
            rm -r ${HOME}/Audio\ Assault/PluginData/Audio\ Assault/AmpLockerData
            ln -sf ${PWD}/AmpLocker/AmpLockerData ${HOME}/Audio\ Assault/PluginData/Audio\ Assault/AmpLockerData
        fi

    # Channel 551 Plugin
    elif [[ "$1" == "channel551" ]]; then
        if [ ! -d "${HOME}/.config/5db5/PluginData/Channel551/Presets" ]; then
            mkdir -p ${HOME}/.config/5db5/PluginData/Channel551
            ln -sf ${PWD}/Channel551/Presets ${HOME}/.config/5db5/PluginData/Channel551/Presets
        else
            rm -r ${HOME}/.config/5db5/PluginData/Channel551/Presets
            ln -sf ${PWD}/Channel551/Presets ${HOME}/.config/5db5/PluginData/Channel551/Presets
        fi

    # Double Take Plugin
    elif [[ "$1" == "doubletake" ]]; then
        if [ ! -d "${HOME}/.config/5db5/PluginData/DoubleTake/Presets" ]; then
            mkdir -p ${HOME}/.config/5db5/PluginData/DoubleTake
            ln -sf ${PWD}/DoubleTake/Presets ${HOME}/.config/5db5/PluginData/DoubleTake/Presets
        else
            rm -r ${HOME}/.config/5db5/PluginData/DoubleTake/Presets
            ln -sf ${PWD}/DoubleTake/Presets ${HOME}/.config/5db5/PluginData/DoubleTake/Presets
        fi

    # Echoverb Plugin
    elif [[ "$1" == "echoverb" ]]; then
        if [ ! -d "${HOME}/.config/5db5/PluginData/EchoVerb/Presets" ]; then
            mkdir -p ${HOME}/.config/5db5/PluginData/EchoVerb
            ln -sf ${PWD}/EchoVerb/Presets ${HOME}/.config/5db5/PluginData/EchoVerb/Presets
        else
            rm -r ${HOME}/.config/5db5/PluginData/EchoVerb/Presets
            ln -sf ${PWD}/EchoVerb/Presets ${HOME}/.config/5db5/PluginData/EchoVerb/Presets
        fi

    # Head Crusher Plugin
    elif [[ "$1" == "headcrusher" ]]; then
        if [ ! -d "${HOME}/5db5/PluginData/Head Crusher/Presets" ]; then
            mkdir -p ${HOME}/5db5/PluginData/Head\ Crusher
            ln -sf ${PWD}/Head\ Crusher/Presets ${HOME}/5db5/PluginData/Head\ Crusher/Presets
        else
            rm -r ${HOME}/5db5/PluginData/Head\ Crusher/Presets
            ln -sf ${PWD}/Head\ Crusher/Presets ${HOME}/5db5/PluginData/Head\ Crusher/Presets
        fi

    # Mix Locker Plugin
    elif [[ "$1" == "mixlocker" ]]; then
        if [ ! -d "${HOME}/Audio Assault/PluginData/Audio Assault/MixLockerData" ]; then
            mkdir -p ${HOME}/Audio\ Assault/PluginData/Audio\ Assault
            ln -sf ${PWD}/MixLocker/MixLockerData ${HOME}/Audio\ Assault/PluginData/Audio\ Assault/MixLockerData
        else
            rm -r ${HOME}/Audio\ Assault/PluginData/Audio\ Assault/MixLockerData
            ln -sf ${PWD}/MixLocker/MixLockerData ${HOME}/Audio\ Assault/PluginData/Audio\ Assault/MixLockerData
        fi

    # RM2 Plugin
    elif [[ "$1" == "rm2" ]]; then
        if [ ! -d "${HOME}/5db5/PluginData/RM-2/Presets" ]; then
            mkdir -p ${HOME}/5db5/PluginData/RM-2
            ln -sf ${PWD}/RM-2/Presets ${HOME}/5db5/PluginData/RM-2/Presets
        else
            rm -r ${HOME}/5db5/PluginData/RM-2/Presets
            ln -sf ${PWD}/RM-2/Presets ${HOME}/5db5/PluginData/RM-2/Presets
        fi

    # Help Message
    else
        echo "Please choose a valid option."
        echo "Options: makedirs amplocker channel551 doubletake echoverb headcrusher mixlocker rm2"
    fi

# Ensure you have typed 1 argument for this command.
else
    echo "Please type an argument"

fi
