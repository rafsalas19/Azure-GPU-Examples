#!/bin/bash
#get subscription id
export AZURE_SUBSCRIPTION_ID=`az account show | grep id | awk -F\" '{print $4}' `

SSHKEY=`cat ~/.ssh/id_rsa.pub`
#echo $SSHKEY
ansible-playbook nvExtAnsible.yml --extra-vars "name=rafTest location=eastus size=Standard_NC6_Promo userName=rafsalas sshKey=$SSHKEY"