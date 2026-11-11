# Cloudflare: start here

Cloudflare can provide DNS, an HTTPS reverse proxy and an identity gate in front
of a website. These are separate features; turning on one does not configure the others.

These are reusable learning guides for an Ubuntu server with Nginx. Replace
`grafana.example.com` and the SSH alias `my-server` with your own values.
Run server commands yourself; the examples are not deployment records.

## Read in this order

1. [Cloudflare IPv4/IPv6 → Nginx allowlist](nginx-allowlist.md): download both
   lists, generate rules, include them in one site, validate and reload.
2. [Protected HTTPS setup](protected-https.md): DNS, Access and a certificate.
3. [Grafana public route](../grafana/public-access.md): a complete Nginx example.

## The parts

| Part | What it does |
| --- | --- |
| DNS record | Maps a hostname to an origin server or another hostname |
| Proxied / orange cloud | Requests pass through Cloudflare |
| DNS only / grey cloud | Clients connect directly to the origin |
| Edge certificate | HTTPS between browser and Cloudflare |
| Origin certificate | HTTPS between Cloudflare and your server |
| Full (strict) | Encrypts and verifies the origin certificate |
| Cloudflare Access | Requires users to match an access policy |
| Nginx allowlist | Restricts source networks allowed to reach a site |

A proxied DNS lookup returns Cloudflare addresses, not necessarily your origin's
address. Copy the origin address from your own server inventory/dashboard.
Never turn off proxying for an Origin CA-only hostname as a troubleshooting shortcut:
ordinary browsers do not trust that certificate directly.

## Common checks

```bash
# Run on a laptop or server: inspect public DNS.
dig +short grafana.example.com
```

`dig` shows the public DNS answer, not proof of an Access policy or origin routing.

```bash
# Run on the server: validate Nginx without reloading it.
sudo nginx -t
```

A valid configuration does not prove the hostname, permissions or login work.
Test the public site in a private browser window afterward.

## Handover checklist

Record hostname, origin location (privately), proxy status, SSL mode, Access policy
and login method, certificate paths/expiry, Nginx site/snippet paths, and the date
Cloudflare's network list was last refreshed. Never record private keys or login codes.

Network filtering is not user authentication and does not validate Access tokens.
For stronger origin identity protection, plan Access JWT validation, an appropriate
mTLS configuration or an authenticated tunnel. Keep application login enabled.

Sources: [Cloudflare IPs](https://www.cloudflare.com/ips/),
[Access setup](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/http-apps/self-hosted-public-app/),
[Origin CA](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/).
