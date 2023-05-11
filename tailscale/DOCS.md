# Home Assistant Custom Add-on: Tailscale with features

![Warning][warning_stripe]

> This is a **fork** of the [community add-on][community_addon]!
>
> Changes:
>   - Enable Tailscale's Funnel feature
>   - Make userspace networking configurable
>   - Protect local subnets from being routed toward Tailscale subnets if they collide

![Warning][warning_stripe]

Tailscale is a zero config VPN, which installs on any device in minutes,
including your Home Assistant instance.

Create a secure network between your servers, computers, and cloud instances.
Even when separated by firewalls or subnets, Tailscale just works. Tailscale
manages firewall rules for you, and works from anywhere you are.

## Prerequisites

In order to use this add-on, you'll need a Tailscale account.

It is free to use for personal & hobby projects, up to 100 clients/devices on a
single user account. Sign up using your Google, Microsoft or GitHub account at
the following URL:

<https://login.tailscale.com/start>

You can also create an account during the add-on installation processes,
however, it is nice to know where you need to go later on.

## Installation

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** ->
   **Add-on Store**.
1. In the **...** menu at the top right corner click **Repositories**, add
   `https://github.com/lmagyar/homeassistant-addon-tailscale` as repository.
1. Find the "Tailscale with features" add-on and click it. If it doesn't show
   up, wait until HA refreshes the information about the add-on, or click
   **Reload** in the **...** menu at the top right corner.
1. Click the "INSTALL" button to install the add-on.

## How to use

1. Start the "Tailscale with features" add-on.
1. Check the logs of the "Tailscale with features" add-on to see if everything
   went well.
1. Open the **Web UI** of the "Tailscale with features" add-on to complete
   authentication and couple your Home Assistant instance with your Tailscale
   account.

   **Note:** _Some browsers don't work with this step. It is recommended to
   complete this step on a desktop or laptop computer using the Chrome browser._

1. Check the logs of the "Tailscale with features" add-on again to see if
   everything went well.

## Configuration

This add-on has almost no additional configuration options for the
add-on itself.

However, when logging in to Tailscale, you can configure your Tailscale
network right from their interface.

<https://login.tailscale.com/>

The add-on exposes "Exit Node" capabilities that you can enable from your
Tailscale account. Additionally, if the Supervisor managed your network (which
is the default), the add-on will also advertise routes to your subnets on all
supported interfaces to Tailscale.

Consider disabling key expiry to avoid losing connection to your Home Assistant
device. See [Key expiry][tailscale_info_key_expiry] for more information.

1. Navigate to the [Machines page][tailscale_machines] of the admin console, and
   find your Home Assistant instance.

1. Click on the **&hellip;** icon at the right side and select the "Edit route
   settings..." option. The "Exit node" and "Subnet routes" functions can be
   enabled here.

1. Click on the **&hellip;** icon at the right side and select the "Disable key
   expiry" option.

## Add-on configuration

```yaml
accept_dns: true
advertise_exit_node: true
log_level: info
login_server: "https://controlplane.tailscale.com"
tags:
  - tag:example
  - tag:homeassistant
taildrop: true
userspace_networking: true
proxy: true
funnel: true
```

### Option: `accept_dns`

If you are experiencing trouble with MagicDNS on this device and wish to
disable, you can do so using this option.

When not set, this option is enabled by default.

MagicDNS may cause issues if you run things like Pi-hole or AdGuard Home
on the same machine as this add-on. In such cases disabling `accept_dns`
will help. You can still leverage MagicDNS on other devices on your network,
by adding `100.100.100.100` as a DNS server in your Pi-hole or AdGuard Home.

### Option: `advertise_exit_node`

This option allows you to advertise this Tailscale instance as an exit node.

By setting a device on your network as an exit node, you can use it to
route all your public internet traffic as needed, like a consumer VPN.

More information: <https://tailscale.com/kb/1103/exit-nodes/>

When not set, this option is enabled by default.

### Option: `log_level`

Optionally enable tailscaled debug messages in the add-on's log. Turn it on only
in case you are troubleshooting, because Tailscale's daemon is quite chatty.

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `notice`: Normal but significant events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `login_server`

This option lets you specify you to specify a custom control server instead of
the default (`https://controlplane.tailscale.com`). This is useful if you
are running your own Tailscale control server, for example, a self-hosted
[Headscale] instance.

### Option: `tags`

This option allows you to specify specific ACL tags for this Tailscale
instance. They need to start with `tag:`.

More information: [ACL tags][tailscale_info_acls]

### Option: `taildrop`

This add-on support [Tailscale's Taildrop][taildrop] feature, which allows
you to send files to your Home Assistant instance from other Tailscale
devices.

When not set, this option is enabled by default.

Received files are stored in the `/share/taildrop` directory.

### Option: `userspace_networking`

The add-on uses [userspace networking mode][tailscale_info_userspace_networking]
to make your Home Assistant instance accessible within your Tailnet.

When not set, this option is enabled by default.

If you need to access other clients on your Tailnet from your Home Assistant
instance, ie. you need a VPN tunnel, a `tailscale0` network interface (like
Ethernet or Wi-Fi), disable userspace networking mode.

In case your local subnets collide with subnet routes within your tailnet, your
local network access has priority and these addresses won't be routed toward
your tailnet. This will prevent your Home Assistant instance to lose network
conection.

### Option: `proxy`

When not set, this option is enabled by default.

Tailscale can provide a TLS certificate for your Home Assistant instance within
your tailnet domain.

This can prevent browsers from warning that HTTP URLs to your Home Assistant instance
look unencrypted (browsers are not aware of the connections between Tailscale
nodes are secured with end-to-end encryption).

More information: [Enabling HTTPS][tailscale_info_https]

1. Configure Home Assistant to be accessible through an HTTP connection (this is
   the default). See [HTTP integration documentation][http_integration] for more
   information. If you still want to use another HTTPS connection to access Home
   Assistant, please use a reverse proxy add-on.

1. Home Assistant, by default, blocks requests from reverse proxies, like the
   Tailscale Proxy. To enable it, add the following lines to your
   `configuration.yaml`, without changing anything:

   ```yaml
   http:
     use_x_forwarded_for: true
     trusted_proxies:
       - 127.0.0.1
   ```

1. Navigate to the [DNS page][tailscale_dns] of the admin console:

   - Choose a Tailnet name.

   - Enable MagicDNS if not already enabled.

   - Under HTTPS Certificates section, click Enable HTTPS.

1. Restart the add-on.

**Note:** _You should not use any port number in the URL that you used
previously to access Home Assistant. Tailscale Proxy works on the default HTTPS
port 443._

### Option: `funnel`

This requires Tailscale Proxy to be enabled.

When not set, this option is enabled by default.

With the Tailscale Funnel feature you can access your Home Assistant instance
from the wider internet using your Tailscale domain (like
`https://homeassistant.tail1234.ts.net`) even from devices **without installed
Tailscale VPN client** (eg. general phones, tablets, laptops).

> **Client** &#8658; _Internet_ &#8658; **Tailscale Funnel** (TCP proxy) &#8658;
> _VPN_ &#8658; **Tailscale Proxy** (HTTPS proxy) &#8594; **HA** (HTTP
> web-server)

Without the Tailscale Funnel feature, you will be able to access your Home
Assistant instance only when your devices (eg. phones, tablets, laptops) are
connected to your Tailscale VPN, there will be no Internet &#8658; VPN TCP
proxying for HTTPS communication.

More information: [Tailscale Funnel][tailscale_info_funnel]

1. Navigate to the [Access controls page][tailscale_acls] of the admin console,
   and add the below policy entries to the policy file. See [Server role
   accounts using ACL tags][tailscale_info_acls] for more information.

   ```json
   {
     "nodeAttrs": [
       {
         "target": ["autogroup:members"],
         "attr": ["funnel"]
       }
     ]
   }
   ```

1. Restart the add-on.

**Note**: _After initial set up it can take up to 10 minutes for the domain to
be publicly available. You can use the `dig` command (Linux/MacOS) to regularly
check if an A-record is already present for your domain (`dig
<machine-name>.<tailnet-name>.ts.net +short` should return an IP address once
the record is published)._

**Note:** _You should not use any port number in the url that you used
previously to access Home Assistant. Tailscale Funnel works on the default HTTPS
port 443._

**Note:** _If you encounter strange browser behaviour or strange error messages,
try to clear all site related cookies, clear all browser cache, restart browser._

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Discord chat server][discord].
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

You could also [open an issue here][issue] on GitHub.

[discord]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io/
[headscale]: https://github.com/juanfont/headscale
[http_integration]: https://www.home-assistant.io/integrations/http/
[issue]: https://github.com/lmagyar/homeassistant-addon-tailscale/issues
[reddit]: https://reddit.com/r/homeassistant
[taildrop]: https://tailscale.com/taildrop/
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-tailscale/raw/main/images/warning_stripe_wide.png
[community_addon]: https://github.com/hassio-addons/addon-tailscale
[tailscale_acls]: https://login.tailscale.com/admin/acls
[tailscale_dns]: https://login.tailscale.com/admin/dns
[tailscale_info_acls]: https://tailscale.com/kb/1068/acl-tags/
[tailscale_info_funnel]: https://tailscale.com/kb/1223/tailscale-funnel/
[tailscale_info_https]: https://tailscale.com/kb/1153/enabling-https/
[tailscale_info_key_expiry]: https://tailscale.com/kb/1028/key-expiry/
[tailscale_info_userspace_networking]: https://tailscale.com/kb/1112/userspace-networking/
[tailscale_machines]: https://login.tailscale.com/admin/machines
