#!/bin/bash
SECRET=${1}

#SECRET="clusterbob-mongodb-binding"
export USERNAME=$(kubectl get -o yaml secret ${SECRET} | grep username | cut -d' ' -f4 | base64 --decode)
export PASSWORD=$(kubectl get -o yaml secret ${SECRET} | grep password | cut -d' ' -f4 | base64 --decode)
export URI=$(kubectl get -o yaml secret ${SECRET} | grep uri | cut -d' ' -f4 | base64 --decode)

export MONGODBURI=$(python connstring-helper-env.py)

env | grep USERNAME
env | grep PASSWORD
env | grep URI
#env | grep MONGODBURI

