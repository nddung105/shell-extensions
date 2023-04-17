#!/bin/bash

source utils.sh

while getopts ":h:o:r:d:n:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      o)
        SETUP_OR_REMOVE=$OPTARG;;
      r) 
        RUN_FILE=$OPTARG;;
      d) 
        DESCRIPTION=$OPTARG;;
      n) 
        SERVICE_NAME=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

ValidOptionSetupOrRemove

if [[ $SETUP_OR_REMOVE == "setup" ]]
then
  Setup
  exit 1
elif [[ $SETUP_OR_REMOVE == "remove" ]]
then
  Remove
  exit 1
else
    echo " _____________________________________________________________________"
    echo "         **** Option -o must be'remove' or 'setup' service ****       "
    echo " _____________________________________________________________________"
    exit 1
fi