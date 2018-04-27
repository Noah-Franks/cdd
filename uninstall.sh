#!/usr/bin/env bash

rm -r ~/.cdd/
sudo rm /usr/bin/cdd

if [[ $? -eq 0 ]]; then
    printf "cdd has been uninstalled. Thanks for trying it!\n"
fi

exit 0
