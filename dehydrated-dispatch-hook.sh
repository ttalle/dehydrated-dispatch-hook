#!/usr/bin/env bash

BASEDIR=$(dirname $0)

source "/etc/dehydrated/dispatch-hooks.inc"

HOOK_FUNCTIONS="deploy_challenge clean_challenge deploy_cert unchanged_cert invalid_challenge request_failure exit_hook"

run_hook() { script="$1"; shift; source "$script"; }

# Load the scripts
for hook in ${HOOKS[@]}; do

  for f in $HOOK_FUNCTIONS; do
    unset -f "$f"
  done

#  echo " + Dispatching hook to $hook"

  run_hook "${hook}" "$@"
done
