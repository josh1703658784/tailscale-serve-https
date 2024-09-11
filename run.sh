#!/usr/bin/env bash

# inspired by: https://github.com/tailscale-dev/docker-mod

# optional shellcheck options
# shellcheck enable=add-default-case
# shellcheck enable=avoid-nullary-conditions
# shellcheck enable=check-unassigned-uppercase
# shellcheck enable=deprecate-which
# shellcheck enable=quote-safe-variables
# shellcheck enable=require-variable-braces

declare -r TS_SERVE_PORT="${TS_SERVE_PORT}"
declare -r TS_SERVE_MODE="${TS_SERVE_MODE}"
declare -r TS_FUNNEL="${TS_FUNNEL}"

set -e                      # exit all shells if script fails
set -u                      # exit script if uninitialized variable is used
set -o pipefail             # exit script if anything fails in pipe


serve(){
  # only one configuration allowed with this wrapper
  # remove any previous config
  tailscale serve reset
  if [ -n "${TS_FUNNEL}" ]; then
    echo '[-] TS_FUNNEL is defined; will continue with command "tailscale funnel";'
    tailscale funnel --"${TS_SERVE_MODE}"=443 http://localhost:"${TS_SERVE_PORT}"
  else
    echo '[-] TS_FUNNEL is NOT defined; will continue with command "tailscale serve";'
    tailscale serve --"${TS_SERVE_MODE}"=443 http://localhost:"${TS_SERVE_PORT}"
  fi
}


main(){
  if ! [ -n "${TS_SERVE_MODE}" ]; then
    echo '[!] TS_SERVE_MODE is REQUIRED but NOT defined;'
    echo '[!] ABORTING script;'
    exit 255
  fi

  if ! [ -n "${TS_SERVE_PORT}" ]; then
    echo '[!] TS_SERVE_PORT is REQUIRED but NOT defined;'
    echo '[!] ABORTING script;'
    exit 255
  fi

  # run containerboot from the 1st party image
  echo '[^] tailscale (daemon) starting'

  /usr/local/bin/containerboot &
  local -r cb_pid="${!}"
  local -i timeout=5

  # loop on containerboot until ready to continue
  # eventually tailscale launched via containerboot will timeout
  # causing containerboot to die, which will kill this loop for us
  while [ -d "/proc/${cb_pid}" ]; do
    if tailscale status &> /dev/null; then
      echo '[^] tailscale ready; starting tailscale serve/funnel;'
      serve
    else
      echo "[-] tailscale not ready yet; will try again after ${timeout}s sleep;"
    fi
    sleep "${timeout}"
    timeout=$((timeout+1))
  done
  echo '[!] TAILSCALE died; EXITING;'
  exit 255
}
main
