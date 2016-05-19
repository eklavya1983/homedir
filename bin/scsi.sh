#!/bin/bash

function scsi()
{
    case "$1" in
        attach)
            sudo iscsiadm -m discovery -p $2 -t st
            sudo iscsiadm -m node -p $2 --login -T iqn.2012-05.com.formationds\:$3
            ;;

        detach)
            sudo iscsiadm -m node --targetname iqn.2012-05.com.formationds\:$3 -p $2 --logout
            ;;

        run)
            sudo fio $2
            ;;
        logoutall)
            sudo iscsiadm -m node -U all
            ;;
        *)
            echo $"Usage: $0 {attach|detach|run}"
            return 1
    esac
}

function iscsiattach()
{
	sudo iscsiadm -m discovery -p $1 -t st
	sudo iscsiadm -m node -p $1 --login -T iqn.2012-05.com.formationds\:$2
}

function iscsidettach()
{
	sudo iscsiadm -m node --targetname iqn.2012-05.com.formationds\:$2 -p $1 --logout
}
