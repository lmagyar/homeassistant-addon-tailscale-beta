
| <img src="https://github.com/lmagyar/homeassistant-addon-tailscale-beta/raw/main/images/stop_sign.png" title="Stop"> | This is a beta repository! Please use the non-beta https://github.com/lmagyar/homeassistant-addon-tailscale repository! This beta repository is for myself to experiment and test. | <img src="https://github.com/lmagyar/homeassistant-addon-tailscale-beta/raw/main/images/stop_sign.png" title="Stop"> |
| --- | --- | --- |

# Home Assistant Custom Add-on: Tailscale with features

Zero config VPN for building secure networks.

![Warning][warning_stripe]

> This is a **fork** of the [community add-on][community_addon]!
>
> Changes:
> - Release unreleased changes from community add-on
>   - Update tailscale/tailscale to v1.92.5
>   - Make exit-node configurable
> - Release pending changes from community add-on
>   - Make all config options mandatory, fill in the default values for previously optional config options
>   - Make accept_routes, advertise_connector, advertise_exit_node, advertise_routes, taildrop and userspace_networking options default disabled to align with stock Tailscale's platform-specific behavior
>   - Rename tags option to advertise_tags to align with stock Tailscale's naming convention - ***config is automatically updated***
>   - Add support for Taildrive
>   - Fix MagicDNS incompatibility with Home Assistant
>   - Make always use derp option configurable
>   - Create persistent notification also (not just log warning) when key expiration is detected
> - Withhold changes from community add-on (will be released here later)
>   - Drop support for armv7 architecture
>   - Update Add-on base image to v19 (drop armv7 support)
> - Release unmerged changes from community add-on
>   - Make Tailscale SSH configurable
>   - Optionally copy Tailscale Serve's certificate files to /ssl folder
>   - Make DSCP configurable on tailscaled's network traffic
>   - Configure log format for the add-on to be compatible with Tailscale's format

> Migration from the community add-on to this fork:
>
> **Note:** This is **not** an in-place replacement of the community add-on, but
> another (though very similar) standalone add-on.
>
> 1. Stop the original community add-on
> 1. Uninstall the original add-on **or** disable **Start on boot**, **Watchdog**,
>    **Autoupdate** and **Add to sidebar** of the original add-on
> 1. Navigate to the [Machines page][tailscale_machines] of the admin console, and
>    find your Home Assistant instance
> 1. Click on the **&hellip;** icon at the right side and select the **Remove...**
>    option (this is to be able to use the same device name again)
> 1. Install the fork
> 1. Copy the configuration YAML of the original add-on to this fork
>    - **Note:** **DO NOT USE THE UI** to copy the configuration, Home Assistant's
>      add-on config UI is totally broken
>    - Navigate to the **Configuration** tab -> **&hellip;** -> **Edit in YAML**
>    - Copy-paste the settings to the forked add-on, but do not overwrite it
>      completely, because there are more options in the forked add-on, and even
>      the common options are not mandatory in the original add-on (ie. missing
>      from the yaml), so remove/overwrite only the options of the forked add-on
>      that you are copying from the original add-on, and **DO NOT SAVE** it yet
>    - Rename `tags:` to `advertise_tags:`
>    - **SAVE** it now
> 1. Enable **Start on boot** and **Watchdog** of the forked add-on
> 1. Start the forked add-on
> 1. Check the logs to see if everything went well
> 1. Open the **Web UI** to complete authentication
>
>    **Note:** _Some browsers don't work with this step. It is recommended to
>    complete this step on a desktop or laptop computer using the Chrome browser._
>
> 1. Check the logs again to see if everything went well.

![Warning][warning_stripe]

[![GitHub Release][releases-shield]][releases]
[![Last Updated][updated-shield]][updated]
![Reported Installations][installations-shield]
![Project Stage][project-stage-shield]
[![License][license-shield]][licence]

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

[![Github Actions][github-actions-shield]][github-actions]
![Project Maintenance][maintenance-shield]
[![GitHub Activity][commits-shield]][commits]

## About

Tailscale is a zero config VPN, which installs on any device in minutes,
including your Home Assistant instance.

Create a secure network between your servers, computers, and cloud instances.
Even when separated by firewalls or subnets, Tailscale just works. Tailscale
manages firewall rules for you, and works from anywhere you are.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-no-red.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[commits-shield]: https://img.shields.io/github/commit-activity/y/lmagyar/homeassistant-addon-tailscale.svg
[commits]: https://github.com/lmagyar/homeassistant-addon-tailscale/commits/main
[github-actions-shield]: https://github.com/lmagyar/homeassistant-addon-tailscale/workflows/Publish/badge.svg
[github-actions]: https://github.com/lmagyar/homeassistant-addon-tailscale/actions
[i386-shield]: https://img.shields.io/badge/i386-no-red.svg
[installations-shield]: https://img.shields.io/badge/dynamic/json?label=reported%20installations&query=$[%2709716aab_tailscale%27].total&url=https%3A%2F%2Fanalytics.home-assistant.io%2Faddons.json
[license-shield]: https://img.shields.io/github/license/lmagyar/homeassistant-addon-tailscale.svg
[licence]: https://github.com/lmagyar/homeassistant-addon-tailscale/blob/main/LICENSE
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-beta-orange.svg
[releases-shield]: https://img.shields.io/github/tag/lmagyar/homeassistant-addon-tailscale.svg?label=release
[releases]: https://github.com/lmagyar/homeassistant-addon-tailscale/tags
[updated-shield]: https://img.shields.io/github/last-commit/lmagyar/homeassistant-addon-tailscale/main?label=updated
[updated]: https://github.com/lmagyar/homeassistant-addon-tailscale/commits/main
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-tailscale/raw/main/images/warning_stripe_wide.png
[community_addon]: https://github.com/hassio-addons/addon-tailscale
