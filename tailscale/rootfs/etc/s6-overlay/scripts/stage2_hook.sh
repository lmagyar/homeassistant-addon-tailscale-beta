#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: Tailscale
# S6 Overlay stage2 hook to customize services
# ==============================================================================

declare options
declare proxy funnel proxy_and_funnel_port
declare share_homeassistant share_on_port
declare healthcheck_offline_timeout healthcheck_restart_timeout

# This is to execute potentially failing supervisor api functions within conditions,
# where set -e is not propagated inside the function and bashio relies on set -e for api error handling
function try {
    set +e
    (set -e; "$@")
    declare -gx TRY_ERROR=$?
    set -e
}

# Load add-on options, even deprecated one to upgrade
options=$(bashio::addon.options)

# Upgrade configuration from 'proxy', 'funnel' and 'proxy_and_funnel_port' to 'share_homeassistant' and 'share_on_port'
# This step can be removed in a later version
proxy=$(bashio::jq "${options}" '.proxy // empty')
funnel=$(bashio::jq "${options}" '.funnel // empty')
proxy_and_funnel_port=$(bashio::jq "${options}" '.proxy_and_funnel_port // empty')
share_homeassistant=$(bashio::jq "${options}" '.share_homeassistant // empty')
share_on_port=$(bashio::jq "${options}" '.share_on_port // empty')
# Upgrade to share_homeassistant
if bashio::var.true "${proxy}"; then
    if bashio::var.has_value "${share_homeassistant}"; then
        bashio::log.warning "The proxy and funnel options are already migrated to share_homeassistant option, do not configure deprecated options, proxy and funnel options are dropped."
    else
        if bashio::var.true "${funnel}"; then
            bashio::addon.option 'share_homeassistant' 'funnel'
            bashio::log.info "Successfully migrated proxy and funnel options to share_homeassistant: funnel"
        else
            bashio::addon.option 'share_homeassistant' 'serve'
            bashio::log.info "Successfully migrated proxy and funnel options to share_homeassistant: serve"
        fi
    fi
fi
# Upgrade to share_on_port
if bashio::var.has_value "${proxy_and_funnel_port}"; then
    if bashio::var.has_value "${share_on_port}"; then
        bashio::log.warning "The proxy_and_funnel_port option is already migrated to share_on_port option, do not configure deprecated options, proxy_and_funnel_port option is dropped."
    else
        try bashio::addon.option 'share_on_port' "^${proxy_and_funnel_port}"
        if ((TRY_ERROR)); then
            bashio::log.warning "The proxy_and_funnel_port option value '${proxy_and_funnel_port}' is invalid, proxy_and_funnel_port option is dropped, using default port."
        else
            bashio::log.info "Successfully migrated proxy_and_funnel_port option to share_on_port: ${proxy_and_funnel_port}"
        fi
    fi
fi
# Remove previous options
if bashio::var.has_value "${proxy}"; then
    bashio::addon.option 'proxy'
fi
if bashio::var.has_value "${funnel}"; then
    bashio::addon.option 'funnel'
fi
if bashio::var.has_value "${proxy_and_funnel_port}"; then
    bashio::addon.option 'proxy_and_funnel_port'
fi

# Remove unused options
healthcheck_offline_timeout=$(bashio::jq "${options}" '.healthcheck_offline_timeout // empty')
healthcheck_restart_timeout=$(bashio::jq "${options}" '.healthcheck_restart_timeout // empty')
if bashio::var.has_value "${healthcheck_offline_timeout}"; then
    bashio::addon.option 'healthcheck_offline_timeout'
fi
if bashio::var.has_value "${healthcheck_restart_timeout}"; then
    bashio::addon.option 'healthcheck_restart_timeout'
fi

# Disable dnsmasq service when userspace-networking is enabled or accepting dns is disabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking" || \
    bashio::config.false "accept_dns";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/dnsmasq
    rm /etc/s6-overlay/s6-rc.d/tailscaled/dependencies.d/dnsmasq
fi

# Disable protect-subnets service when userspace-networking is enabled or accepting routes is disabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking" || \
    bashio::config.false "accept_routes";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/protect-subnets
    rm /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/protect-subnets
fi

# Disable forwarding service when userspace-networking is enabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/forwarding
fi

# Disable mss-clamping service when userspace-networking is enabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/mss-clamping
fi

# Disable taildrop service when it has been explicitly disabled
if bashio::config.false 'taildrop'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/taildrop
fi

# Disable share-homeassistant service when share_homeassistant has not been explicitly enabled
if ! bashio::config.has_value 'share_homeassistant' || \
    bashio::config.equals 'share_homeassistant' 'disabled'
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/share-homeassistant
fi

# Disable certificate service when it has not been configured
if ! bashio::config.has_value 'share_homeassistant' || \
    bashio::config.equals 'share_homeassistant' 'disabled' || \
    ! bashio::config.has_value 'lets_encrypt_certfile' || \
    ! bashio::config.has_value 'lets_encrypt_keyfile';
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/certificate
fi
