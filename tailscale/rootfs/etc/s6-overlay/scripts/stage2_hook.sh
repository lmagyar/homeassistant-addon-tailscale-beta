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

# Disable taildrop service when it is has been explicitly disabled
if bashio::config.false 'taildrop'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/taildrop
fi

# Disable proxy service when it is has been explicitly disabled
if bashio::config.false 'proxy'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/proxy
fi

# Disable funnel service when it is has been explicitly disabled
if bashio::config.false 'proxy' || bashio::config.false 'funnel'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/funnel
fi

# Disable certificate service when it is not configured
if bashio::config.false 'proxy' || \
    ! bashio::config.has_value "lets_encrypt-certfile" || \
    ! bashio::config.has_value "lets_encrypt-keyfile";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/certificate
    rm /etc/s6-overlay/s6-rc.d/proxy/dependencies.d/certificate
fi
# Warn about invalid certificate service configuration (can't be checked by the UI)
if (bashio::config.has_value "lets_encrypt-certfile" && ! bashio::config.has_value "lets_encrypt-keyfile") ||
    (! bashio::config.has_value "lets_encrypt-certfile" && bashio::config.has_value "lets_encrypt-keyfile");
then
    bashio::log.warning \
        "Both 'lets_encrypt' options ('lets_encrypt-certfile' and 'lets_encrypt-keyfile')" \
        "has to be specified or omitted together."
fi
