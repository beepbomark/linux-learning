# Cloudflare: protected hostname and HTTPS

Example: `grafana.example.com` → Cloudflare → Nginx → private application.
Use your own domain. This assumes the domain is already active in Cloudflare
and Nginx is installed. A new zone also needs nameserver setup at the registrar.

## 1. Create Access protection first

In Zero Trust → Access → Applications, create a Self-hosted application:

| Setting | Example |
| --- | --- |
| Name | Grafana |
| Public hostname | grafana.example.com |
| Path | Empty: protect the whole hostname |
| Session | 8 hours, adjustable |
| Policy action | Allow |
| Include rule | Emails: your exact approved email |

Attach the policy to the application and save both. Select an existing identity
provider or configure One-time PIN if using email codes. Avoid Everyone/Bypass
rules for an administrator dashboard. A saved policy alone is not an attached policy.

## 2. Create a dedicated origin certificate

In the regular domain dashboard → SSL/TLS → Origin Server → Create Certificate:
- Generate a key/CSR using RSA, or use your own CSR.
- Set only the intended hostname; remove broader default names if unnecessary.
- Choose a validity period and record the expiry.
- Use PEM format. Keep the screen open until the key has been saved securely.

Run on the server:

```bash
sudo install -d -m 0700 /etc/nginx/ssl/grafana
sudo install -m 0600 /dev/null /etc/nginx/ssl/grafana/origin.pem
sudo install -m 0600 /dev/null /etc/nginx/ssl/grafana/origin.key
```

These create a root-only directory and empty private files. FIRST SETUP ONLY:
`install` overwrites existing files, so do not run it over a working certificate.

```bash
sudo nano /etc/nginx/ssl/grafana/origin.pem
sudo nano /etc/nginx/ssl/grafana/origin.key
```

Paste the certificate into the first file and private key into the second, including
their BEGIN/END lines. Save each with Ctrl+O, Enter, Ctrl+X. Never put keys into
shell command arguments, chat, screenshots or Git.

```bash
sudo openssl x509 -in /etc/nginx/ssl/grafana/origin.pem   -noout -dates -ext subjectAltName
```

This displays the public certificate's expiry and hostnames. Check key matching:

```bash
sudo openssl x509 -in /etc/nginx/ssl/grafana/origin.pem -pubkey -noout |
  openssl pkey -pubin -outform DER | sha256sum
```

```bash
sudo openssl pkey -in /etc/nginx/ssl/grafana/origin.key -pubout -outform DER |
  sha256sum
```

Both commands fingerprint PUBLIC keys only. Expect identical hashes; stop on any error.

## 3. Configure the origin before adding DNS

Follow the [network allowlist](nginx-allowlist.md), then the
[Grafana Nginx example](../grafana/public-access.md) if using Grafana.
Validate Nginx before reload. Test existing sites afterward.

## 4. Publish using the Cloudflare proxy

Add an A record `grafana` pointing to your actual origin IPv4 address, with proxy
status Proxied (orange cloud). Add AAAA only if origin IPv6 is intentionally configured.

Use Full (strict) SSL mode. Changing a zone-wide mode affects other hostnames:
confirm their certificates are valid before changing it. Do not use Flexible.

## 5. Check

Use a private browser window: expect Access authentication, then the application's
own login, valid HTTPS and working pages. Test an unauthorized account if available.
Use the allowlist guide's direct-denial check too.

Origin CA certificates are trusted by Cloudflare, not ordinary browsers. They do
not replace the browser-facing edge certificate. Track expiry yourself; do not
assume a long-lived certificate renews automatically or triggers a reminder.

Sources: [Access](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/http-apps/self-hosted-public-app/),
[Origin CA](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/).
