#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: Tailscale
# S6 Overlay stage2 hook to customize services
# ==============================================================================

# Disable protect-subnets service when userspace-networking is enabled or accepting routes is disabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking" || \
    bashio::config.false "accept_routes";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/protect-subnets
    rm /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/protect-subnets
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

# Disable certificate service when it has not been configured
if ! (bashio::config.true 'proxy' || bashio::config.has_value "advanced_serve_config") || \
    ! bashio::config.has_value "lets_encrypt_certfile" || \
    ! bashio::config.has_value "lets_encrypt_keyfile";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/certificate
fi

# Disable proxy and funnel service when advanced_serve_config has been configured
# Disable advanced_serve_config service when advanced_serve_config has not been configured
if bashio::config.has_value "advanced_serve_config"; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/proxy
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/funnel
    rm /etc/s6-overlay/s6-rc.d/certificate/dependencies.d/proxy
else
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/advanced_serve_config
    rm /etc/s6-overlay/s6-rc.d/certificate/dependencies.d/advanced_serve_config
fi
