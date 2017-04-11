#!/usr/bin/env bash

BASEDIR=$(dirname $0)

source "/etc/dehydrated/dispatch-hooks.inc"

# Load the scripts
for hook in ${HOOKS[@]}; do

#  echo " + Dispatching hook to $hook"

  "${hook}" "$@"
done
