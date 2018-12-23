

red="\e[31m"       # Red bash color code
green="\e[32m"     # Green bash color code
yellow="\e[33m"    # Yellow bash color code
normal="\e[0m"     # Terminal default color code


# Make sure script isn't already installed
if [ -d ~/.cdd ]; then
    printf "It appears cdd is (at least partially) "$red"already installed\n"$normal
    printf "Please run "$yellow"uninstall.sh "$normal"before this script if you want to cleanly reinstall\n\n"
    exit 1
fi

printf "Attempting to install cdd for user "$USER"\n"

# Make destinations directory, which contains all cdd targets
mkdir -p ~/.cdd/destinations

# The location of the script, in case this was executed from another directory
root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Copy executable
cp $root_dir/source.x ~/.cdd/cdd

printf $green"Successfully installed cdd!\n\n"$normal
printf "To actually run cdd, please append the following to your .bashrc\n"
printf $yellow"alias cdd='. ~/.cdd/cdd'\n\n"$normal
