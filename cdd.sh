#!/usr/bin/env bash


# Ensure environment is ready for cdd
if [ ! -d ~/.cdd ]; then
    # First time, setup .cdd directory

    printf "Attempting to install cdd for user "$USER"\n"
    
    mkdir -p ~/.cdd/destinations
    sudo cp ./cdd.sh /usr/bin/cdd
    cp ./cdd.sh ~/.cdd/cdd
    
    printf "Successfully installed cdd!\n\n"

    printf "To run cdd without issues, append the following to your .bashrc\n"
    printf "\talias cdd='. /usr/bin/cdd'\n\n"
    exit 0
fi


# Parse arguments and determine what to do
success_color="\e[32m"   # Green
failure_color="\e[31m"   # Red
normal_color="\e[0m"     # Terminal default
location=""              # Where cdd should go to
list=false               # Whether to list all defined destinations
new=false                # Whether to make/update a destination


usage_error_message="Usage: cdd [-n|-l|-c|-h|--new|--list|--colorless|--help|--version] [<destination>]"
version_number_message="Version 0.1"

for argument in "$@"; do

    if [[ $argument = "--"* ]]; then

        if [[ $argument = "--new" ]]; then
            
            new=true

        elif [[ $argument = "--list" ]]; then

            list=true
            
        elif [[ $argument = "--colorless" ]]; then

            success_color=""
            failure_color=""

        elif [[ $argument = "--version" ]]; then

            printf "$version_number_message\n"
            return 0
            
        else

            printf "Err: Unknown flag\n"
            printf "$usage_error_message\n"
            
            return 1
        fi
    
    elif [[ $argument = "-"* ]]; then

        characters_processed=1   # Let's us know if any undefined flags were set

        if [[ $argument = *"n"* ]]; then

            new=true
            (( characters_processed += 1 ))
        fi

        if [[ $argument = *"l"* ]]; then

            list=true
            (( characters_processed += 1 ))
        fi
        
        if [[ $argument = *"c"* ]]; then
            
            success_color=""
            failure_color=""
            (( characters_processed += 1 ))
        fi
        
        if [[ $characters_processed -ne ${#argument} ]]; then
            printf "Err: Unknown flag\n"
            printf "$usage_error_message\n"
            
            return 1
        fi
        
    elif [[ $location = "" ]]; then

        location=$argument

    else
        # Second potential location was passed in

        printf "$usage_error_message\n"
        return 1
    fi
done

if [[ $location = "" ]]; then
    location="default"
fi


# Perform cdd
if [[ $new = true ]]; then
    # Create or update destination
    
    if [[ -f ~/.cdd/destinations/$location ]]; then
        # Update destination
        
        if [[ $location = "default" ]]; then
            printf "Updating "$success_color"default"$normal_color" destination\n"
        else
            printf "Updating destination "$success_color$2"\n"$normal_color
        fi
        
    else
        if [[ $location = "default" ]]; then
            printf "Setting new "$success_color"default"$normal_color" destination\n"
        else
            printf "Setting new destination "$success_color$2"\n"$normal_color  
        fi    
    fi

    pwd > ~/.cdd/destinations/$location
    return 0
fi



if [[ $list = true ]]; then
    for destination_file in ~/.cdd/destinations/*; do
        file_contents=$(cat $destination_file 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            printf $success_color${destination_file##*/}$normal_color"\t"$file_contents"\n"
        else
            printf $failure_color"No destinations have been set"$normal_color"\n"
        fi
    done

    if [[ $location = "default" ]]; then
        return 0;
    fi
fi
    
destination=$(cat ~/.cdd/destinations/$location 2> /dev/null)
if [[ $? -ne 0 ]]; then
    if [[ $location = "default" ]]; then
        printf "No default destination set.\nSet it to the current directory using 'cdd -n'\n"
    else
        printf "Destination "$failure_color$location$normal_color" not set\n"
    fi
    return 1
fi

cd $destination


