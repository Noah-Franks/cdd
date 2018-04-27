#!/usr/bin/env bash

# Parse arguments and determine what to do
success_color="\e[32m"   # Green
failure_color="\e[31m"   # Red
normal_color="\e[0m"     # Terminal default
location=""              # Where cdd should go to
new=false                # Whether to make/update a destination

usage_error_message="Usage: cdd [-n|-c|--new|--colorless|--version] <destination>"
version_number_message="Version 0.1"

for argument in "$@"; do

    if [[ $argument = "--"* ]]; then

        if [[ $argument = "--new" ]]; then
            
            new=true

        elif [[ $argument = "--colorless" ]]; then

            success_color=""
            failure_color=""

        elif [[ $argument = "--version" ]]; then

            printf "$version_number_message\n"
            exit 0
            
        else

            printf "Err: Unknown flag\n"
            printf "$usage_error_message\n"
            
            exit 1
        fi
    
    elif [[ $argument = "-"* ]]; then

        characters_processed=1

        if [[ $argument = *"n"* ]]; then

            new=true
            (( characters_processed += 1 ))
        fi
        
        if [[ $argument = *"c"* ]]; then
            
            success_color=""
            failure_color=""
            (( characters_processed += 1 ))
        fi
        
        echo $characters_processed
        echo ${#argument}
        
        if [[ $characters_processed -ne ${#argument} ]]; then
            printf "Err: Unknown flag\n"
            printf "$usage_error_message\n"
            
            exit 1
        fi
        
    elif [[ $location = "" ]]; then
        location=$argument
    else
        # Second potential location was passed in
        printf "$usage_error_message\n"
        exit 1
    fi
done

if [[ $location = "" ]]; then
    
fi

# Ensure environment is ready for cdd
if [ ! -d ~/.cdd ]; then
    # First time, setup .cdd directory
    
    mkdir -p ~/.cdd/destinations
fi

# Perform cdd
if [[ $new = true ]]; then
    # Create or update destination
    
    if [[ $# -eq 1 ]]; then
        # Needs another argument
        printf $failure_color"Err: Please supply a name\n" >&2
        exit 1
    fi
    
    if [[ -f ~/.cdd/$2 ]]; then
        printf "Updating destination\t$success_color$2\n"$normal_color
    else
        printf "Setting new destination\t$success_color$2\n"$normal_color
    fi
    
    
fi

