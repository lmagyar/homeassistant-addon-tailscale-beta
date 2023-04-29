# Changelog

## vNext (forked)

- Merge changes from original add-on
  - Drop userspace networking
  - Make accepting magicDNS optional

## 0.11.1.1 (forked)

- Make Proxy and Funnel configurable
- Remove Tailscale's SOCKS5 and HTTP outbound proxy (not needed after userspace networking is dropped)
- Merge changes from original add-on
  - Update tailscale/tailscale to v1.40.0
  - Make Taildrop configurable
  - Make exit node advertisement configurable
  - Add custom control server support
  - Update Add-on base image to v13.2.2

## 0.10.1.3 (forked)

- Put local UI webserver on to different port than original add-on's

## 0.10.1.2 (forked)

- Bugfix for login server config

## 0.10.1.1 (forked)

- Allow customizing the login server (from PR [#175](https://github.com/hassio-addons/addon-tailscale/pull/175) by [@reey](https://github.com/reey))
- Merge changes from original add-on
  - Update tailscale/tailscale to v1.38.4

## 0.10.0.1 (forked)

- Remove ACL tagging recommendation from Funnel documentation, finally `autogroup:members` works
- Merge changes from original add-on
  - Add support for Taildrop

## 0.9.0.6 (forked)

- Use the default add-on network config UI for SOCKS5 and HTTP outbound proxy port configuration

## 0.9.0.5 (forked)

- Remove duplicate status checks from dependent S6 services

## 0.9.0.4 (forked)

- Remove unneeded add-on privileges

## 0.9.0.3 (forked)

- Enable Tailscale's Funnel feature

## 0.9.0.2 (forked)

- Enable Tailscale's SOCKS5 and HTTP outbound proxy

## 0.9.0.1 (forked)

- Move Tailscale Proxy functionality into standalone oneshot S6 service
- Merge changes from original add-on
  - Advertise all supported interfaces as Tailscale Subnets
  - Suppress tailscaled logs after 200 lines
  - Bump Tailscale to 1.38.3
  - Bump base image to 13.2.0

## 0.8.0.1 (forked)

- Merge PR modifications
- Merge changes from original add-on
  - Migrate old-style S6 scripts to s6-rc.d
  - Bump base image to 13.1.4

## 0.7.0.13 (forked)

- Bump Tailscale to 1.38.2

## 0.7.0.12 (forked)

- Bump Tailscale to 1.38.1
- Bump base image to 13.1.3

## ~~0.7.0.11 (forked)~~

_This version number is skipped, just to be in sync with the [Funnel version repo](https://github.com/lmagyar/homeassistant-addon-tailscale-funnel)._

## 0.7.0.10 (forked)

- Bump Tailscale to 1.36.2
- Bump base image to 13.1.2

## 0.7.0.9 (forked)

- Bump Tailscale to 1.36.1

## 0.7.0.8 (forked)

***Breaking change***

- Enable Tailscale's Proxy feature
- Revert explicit TLS certificate provisioning

## 0.7.0.7 (forked)

- Use `log_level` configuration option for tailscaled debug messages

## 0.7.0.6 (forked)

- Bump Tailscale to 1.36.0
- Bump base image to 13.1.1

## 0.7.0.5 (forked)

- Only optionally enable tailscaled debug messages in the add-on's log

## 0.7.0.4 (forked)

- Bump base image to 13.1.0

## 0.7.0.3 (forked)

- Advertise all supported interfaces as Subnets

## 0.7.0.2 (forked)

- Rename TLS certificates configuration option from `cert_domain` to `certificate_tailnet_name`

## 0.7.0.1 (forked)

- Enables to provision TLS certificates
- Bump Tailscale to 1.34.2
- Bump base image to 13.0.1

## 0.7.0.0 (forked)

- Fork of the original v0.7.0

For previous changelog see the original add-on's [release history](https://github.com/hassio-addons/addon-tailscale/releases).
