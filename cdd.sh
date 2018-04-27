
# Parse arguments and determine what to do
success_color="\e[32m"
failure_color="\e[31m"
new=false

for argument in "$@"; do
    if [[ $argument = "-c" ]]; then
        success_color=""
        failure_color=""
    elif [[ $argument = "new" ]]; then
        new=true
    fi
done

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
        printf "Err: Please supply a name\n" >&2
        exit 1
    fi

    if [[ -f ~/.cdd/$2 ]]; then
        printf "Updating destination\t$2\n"
    else
        printf "Setting new destination\t$2\n"  
    fi

    
fi

