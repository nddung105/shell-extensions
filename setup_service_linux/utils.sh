#!/bin/bash

user=$USER
FOLDER_SERVICES=/etc/systemd/system/

unset -v RUN_FILE
unset -v DESCRIPTION
unset -v SERVICE_NAME

Help()
{
    # Display Help
    echo " _____________________________________________________________________"
    echo "|                                                                     |"
    echo "|          Set up service auto restart when rebooting                 |"
    echo "|                                                                     |"
    echo "| Command structure: ./setup.sh -[argument] [value]                   |"
    echo "|                                                                     |"
    echo "| [argument]:                                                         |"
    echo "| -  o:  Option 'remove' or 'setup' service                           |"
    echo "|                                                                     |"
    echo "| -  r:  Full path file bash shell .sh execute when the machine boots |"
    echo "|                                                                     |"
    echo "| -  d:  Description of services                                      |"
    echo "|                                                                     |"
    echo "| -  n:  Service name (must end with .service)                        |"
    echo "|_____________________________________________________________________|"
}

Setup()
{
    if [ -z "$RUN_FILE" ] || [ -z "$DESCRIPTION" ] || [ -z "$SERVICE_NAME" ]; then
        echo " _____________________________________________________________________"
        echo "                 **** Requires all 3 parameters ****                 "
        Help
        exit 1
    fi

    if [ -f "$RUN_FILE" ]; then
        sudo chmod +x $RUN_FILE
    else
        echo "No found file $RUN_FILE"
        exit 1
    fi

    cp ./interface_service.service ./$SERVICE_NAME

    full_path_file_run=$(echo $RUN_FILE | sed -e 's/\//\\\//g')
    sed -i "s/full_path_file_run/$full_path_file_run/g" $SERVICE_NAME

    sed -i "s/username/$user/g" $SERVICE_NAME
    sed -i "s/text_description/$DESCRIPTION/g" $SERVICE_NAME

    if [ ! -f "$FOLDER_SERVICES$SERVICE_NAME" ]; then
        sudo cp ./$SERVICE_NAME $FOLDER_SERVICES
        sudo chmod +x $FOLDER_SERVICES$SERVICE_NAME
        echo "copy file $SERVICE_NAME to $FOLDER_SERVICES"
        rm -rf $SERVICE_NAME
    else
        echo "file $SERVICE_NAME exist in $FOLDER_SERVICES"
        rm -rf $SERVICE_NAME
        exit 1
    fi

    sudo systemctl daemon-reload
    sudo systemctl enable $SERVICE_NAME
    sudo systemctl start $SERVICE_NAME
}

Remove()
{
    if [ -z "$SERVICE_NAME" ]; then
        echo " _____________________________________________________________________"
        echo "         **** Requires -n service name to remove it ****              "
        exit 1
    fi
    sudo systemctl stop $SERVICE_NAME
    sudo systemctl disable $SERVICE_NAME
    sudo systemctl daemon-reload
    sudo rm $FOLDER_SERVICES$SERVICE_NAME
}

ValidOptionSetupOrRemove()
{
    if [ -z "$SETUP_OR_REMOVE" ]; then
        echo " _____________________________________________________________________"
        echo "                  **** Requires -o parameters ****                    "
        Help
        exit 1
    fi
}