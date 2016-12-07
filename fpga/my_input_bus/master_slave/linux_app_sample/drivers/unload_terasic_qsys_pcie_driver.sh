#!/bin/sh

DRV_MODULE="terasic_qsys_pcie"
DRV_NAME="terasic_qsys_pcie"

/sbin/rmmod -f $DRV_MODULE

# remove state nodes
rm -f /dev/${DRV_NAME}*

