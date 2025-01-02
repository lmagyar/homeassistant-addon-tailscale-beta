#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: Tailscale
# S6 Overlay stage2 hook to customize services
# ==============================================================================

declare options
declare proxy, funnel, proxy_and_funnel_port
declare healthcheck_offline_timeout healthcheck_restart_timeout
declare forward_to_host

# Load add-on options, even deprecated one to upgrade
options=$(bashio::addon.options)

# Upgrade configuration from 'proxy', 'funnel' and 'proxy_and_funnel_port' to 'share_homeassistant' and 'share_on_port'
options=$(bashio::addon.options)
proxy=$(bashio::jq "${options}" '.proxy')
funnel=$(bashio::jq "${options}" '.funnel')
proxy_and_funnel_port=$(bashio::jq "${options}" '.proxy_and_funnel_port')
if bashio::var.true "${proxy}"; then
    if bashio::var.true "${funnel}"; then
        bashio::addon.option 'share_homeassistant' 'funnel'
    else
        bashio::addon.option 'share_homeassistant' 'serve'
    fi
fi
if ! bashio::var.equals "${proxy_and_funnel_port}" 'null'; then
    bashio::addon.option 'share_on_port' "${proxy_and_funnel_port}"
fi
bashio::addon.option 'proxy'
bashio::addon.option 'funnel'
bashio::addon.option 'proxy_and_funnel_port'

# Remove unused options
healthcheck_offline_timeout=$(bashio::jq "${options}" '.healthcheck_offline_timeout | select(.!=null)')
healthcheck_restart_timeout=$(bashio::jq "${options}" '.healthcheck_restart_timeout | select(.!=null)')
forward_to_host=$(bashio::jq "${options}" '.forward_to_host | select(.!=null)')
if bashio::var.has_value "${healthcheck_offline_timeout}"; then
    bashio::log.info 'Removing deprecated healthcheck_offline_timeout option'
    bashio::addon.option 'healthcheck_offline_timeout'
fi
if bashio::var.has_value "${healthcheck_restart_timeout}"; then
    bashio::log.info 'Removing deprecated healthcheck_restart_timeout option'
    bashio::addon.option 'healthcheck_restart_timeout'
fi
if bashio::var.has_value "${forward_to_host}"; then
    bashio::log.info 'Removing deprecated forward_to_host option'
    bashio::addon.option 'forward_to_host'
fi

# Disable MagicDNS proxy services when userspace-networking is enabled or accepting dns is disabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking" || \
    bashio::config.false "accept_dns";
then
    rm /etc/s6-overlay/s6-rc.d/tailscaled/dependencies.d/magicdns-egress-proxy
    rm /etc/s6-overlay/s6-rc.d/forwarding/dependencies.d/magicdns-ingress-proxy
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/magicdns-ingress-proxy
fi

# Disable protect-subnets service when userspace-networking is enabled or accepting routes is disabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking" || \
    bashio::config.false "accept_routes";
then
    rm /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/protect-subnets
fi

# If advertise_routes is configured, do not wait for the local network to be ready to collect subnet information
if bashio::config.exists "advertise_routes";
then
    rm /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/local-network
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
