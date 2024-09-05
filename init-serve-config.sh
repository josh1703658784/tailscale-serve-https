#!/usr/bin/env sh

export TS_SERVE_CONFIG="${TS_SERVE_CONFIG}"
export LOCAL_PORT="${LOCAL_PORT}"

# optional shellcheck options
# shellcheck enable=add-default-case
# shellcheck enable=avoid-nullary-conditions
# shellcheck enable=check-unassigned-uppercase
# shellcheck enable=deprecate-which
# shellcheck enable=quote-safe-variables
# shellcheck enable=require-variable-braces

cat << CONFIG > "${TS_SERVE_CONFIG}"
{
  "TCP": {
    "443": {
      "HTTPS": true
    }
  },
  "Web": {
    "\${TS_CERT_DOMAIN}:443": {
      "Handlers": {
        "/": {
          "Proxy": "http://localhost:${LOCAL_PORT}"
        }
      }
    }
  }
}
CONFIG
