#!/usr/bin/env bash

BASEDIR=$(dirname $0)

source "/etc/dehydrated/dispatch-hooks.inc"

# Recognized actions
HOOK_FUNCTIONS="deploy_challenge clean_challenge deploy_cert unchanged_cert invalid_challenge request_failure exit_hook"


# Rename and copy functions
# source: http://stackoverflow.com/a/18839557
copy_function() { test -n "$(declare -f $1)" && eval "${_/$1/$2}"; };
rename_function() { copy_function "$@" && unset -f "$1"; };

# Special function to load the hook with clean parameters
# This enables the example hook script to be loaded without
# executing the requested function
load_hook() { local HOOKSCRIPT="$1"; shift; source "$HOOKSCRIPT"; };
run_hook() { script="$1"; shift; source "$script"; }

# Initialize the dictionary
declare -A HOOK_CACHE

for f in $HOOK_FUNCTIONS
do
  HOOK_CACHE["$f"]="";
done


# Load the scripts

for hook in ${HOOKS[@]}
do
  echo " + Loading hook: ${hook}"

  # Load the script in a seperate function to clean arguments
  load_hook "${hook}"

  for f in $HOOK_FUNCTIONS
  do
    # Test for hook existence
    if [[ -n "$(declare -f $f)" ]]; then
      CACHE="$(date +%S%N)_$f"

      echo " + Caching $f as $CACHE"

      rename_function "$f" "$CACHE"

      HOOK_CACHE["$f"]+=" $CACHE"
    fi
  done

done


HANDLER="$1"; shift

if [[ "${HANDLER}" =~ ^(deploy_challenge|clean_challenge|deploy_cert|unchanged_cert|invalid_challenge|request_failure|exit_hook)$ ]]; then

  for h in ${HOOK_CACHE["$HANDLER"][@]}; do
    echo " + Running: $h"

    run_hook "$h" "$@"
  done

fi
