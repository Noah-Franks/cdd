#!/usr/bin/env bash


# Parse arguments and determine what to do
cdd_failure_color="\e[31m"   # Red
cdd_success_color="\e[32m"   # Green
cdd_yellow="\e[33m"          # Yellow bash color code
cdd_normal="\e[0m"           # Terminal default
cdd_italics="\e[3m"          # Terminal italics
cdd_location=""              # Where cdd should go to
cdd_list=false               # Whether to list all defined destinations
cdd_new=false                # Whether to make/update a destination


cdd_usage_message="Usage: cdd [-nluch] [--new] [--list] [--undo] [--colorless] [--help] [--version] "$cdd_italics"destination"$cdd_normal

cdd_version_number_message="Version 1.0"

for argument in "$@"; do
    
    if [[ $argument = "--"* ]]; then
        
        if [[ $argument = "--new" ]]; then
            cdd_new=true
            
        elif [[ $argument = "--list" ]]; then
            cdd_list=true
            
        elif [[ $argument = "--colorless" ]]; then
            cdd_success_color=""
            cdd_failure_color=""
            
        elif [[ $argument = "--version" ]]; then
            printf "$cdd_version_number_message\n"
            return 0
            
        elif [[ $argument = "--help" ]]; then
            printf "$cdd_usage_message\n\n"
            printf "Create a new cdd target directory via\n"
            printf $cdd_yellow"cdd -n "$cdd_italics"destination"$cdd_normal"\n\n"
            printf "List the directories via\n"
            printf $cdd_yellow"cdd -l "$cdd_normal"\n\n"

            printf "Notes\n"
            printf "If the target already exists, it will be overwritten\n"
            printf "If the target is not specified, it will be the default, which you can set via\n"
            printf $cdd_yellow"cdd -n"$cdd_normal"\n"
            printf "and go to via\n"
            printf $cdd_yellow"cdd"$cdd_normal"\n"
            return 0
            
        else
            printf "Err: Unknown flag\n"
            printf "$cdd_usage_message\n"
            return 1
        fi
    
    elif [[ $argument = "-"* ]]; then
        characters_processed=1   # Let's us know if any undefined flags were set
        
        if [[ $argument = *"n"* ]]; then            
            cdd_new=true
            (( characters_processed += 1 ))
        fi
        
        if [[ $argument = *"l"* ]]; then
            cdd_list=true
            (( characters_processed += 1 ))
        fi
        
        if [[ $argument = *"c"* ]]; then
            cdd_success_color=""
            cdd_failure_color=""
            (( characters_processed += 1 ))
        fi
        
        if [[ $argument = *"h"* ]]; then
            printf "$cdd_usage_message\n\n"
            printf "Create a new cdd target directory via\n"
            printf $cdd_yellow"cdd -n "$cdd_italics"destination"$cdd_normal"\n\n"
            printf "List the directories via\n"
            printf $cdd_yellow"cdd -l "$cdd_normal"\n\n"
            
            printf "Notes\n"
            printf "If the target already exists, it will be overwritten\n"
            printf "If the target is not specified, it will be the default, which you can set via\n"
            printf $cdd_yellow"cdd -n"$cdd_normal"\n"
            printf "and go to via\n"
            printf $cdd_yellow"cdd"$cdd_normal"\n"
            return 0
        fi
        
        if [[ $characters_processed -ne ${#argument} ]]; then
            printf "Err: Unknown flag\n"
            printf "$usage_error_message\n"
            return 1
        fi
        
    elif [[ $cdd_location = "" ]]; then
        cdd_location=$argument
        
    else
        # Second potential cdd_location was passed in
        
        printf "$usage_error_message\n"
        return 1
    fi
done

if [[ $cdd_location = "" ]]; then
    cdd_location="default"
fi


# Perform cdd
if [[ $cdd_new = true ]]; then
    # Create or update destination
    
    if [[ -f ~/.cdd/destinations/$cdd_location ]]; then
        # Update destination
        
        if [[ $cdd_location = "default" ]]; then
            printf "Updating "$cdd_success_color"default"$cdd_normal" destination\n"
        else
            printf "Updating destination "$cdd_success_color$2"\n"$cdd_normal
        fi
        
    else
        if [[ $cdd_location = "default" ]]; then
            printf "Setting new "$cdd_success_color"default"$cdd_normal" destination\n"
        else
            printf "Setting new destination "$cdd_success_color$2"\n"$cdd_normal  
        fi    
    fi

    pwd > ~/.cdd/destinations/$cdd_location
    return 0
fi



if [[ $cdd_list = true ]]; then
    for destination_file in ~/.cdd/destinations/*; do
        file_contents=$(cat $destination_file 2>/dev/null)
        if [[ $? -eq 0 ]]; then
            printf $cdd_success_color${destination_file##*/}$cdd_normal"\t"$file_contents"\n"
        else
            printf $cdd_failure_color"No destinations have been set"$cdd_normal"\n"
        fi
    done
    
    if [[ $cdd_location = "default" ]]; then
        return 0;
    fi
fi
    
destination=$(cat ~/.cdd/destinations/$cdd_location 2> /dev/null)
if [[ $? -ne 0 ]]; then
    if [[ $cdd_location = "default" ]]; then
        printf "No default destination set.\nSet it to the current directory using 'cdd -n'\n"
    else
        printf "Destination "$cdd_failure_color$cdd_location$cdd_normal" not set\n"
    fi
    return 1
fi

cd $destination


