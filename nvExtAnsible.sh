#!/bin/bash
#get subscription id
export AZURE_SUBSCRIPTION_ID=`az account show | grep id | awk -F\" '{print $4}' `


ansible-playbook nvExtAnsible.yml --extra-vars "name=rafTestrg location=eastus"