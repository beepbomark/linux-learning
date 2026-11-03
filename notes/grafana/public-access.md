# Grafana: public HTTPS through Cloudflare and Nginx

Example: https://grafana.example.com. Replace this hostname everywhere.
Prerequisites: working private Grafana, Nginx, a domain on Cloudflare, and admin
password already changed. Run commands on the server unless stated otherwise.

## 1. Prepare Cloudflare and the certificate

Follow [protected HTTPS](../cloudflare/protected-https.md) to create an exact-email
Access policy and a dedicated Origin Certificate. Save the files as:

```text
/etc/nginx/ssl/grafana/origin.pem
/etc/nginx/ssl/grafana/origin.key
```

Then follow [download IPv4/IPv6 and create the allowlist](../cloudflare/nginx-allowlist.md)
through installing `/etc/nginx/snippets/cloudflare-only.conf`. Do not change unrelated
sites. The snippet assumes Nginx sees Cloudflare's original connection address,
without real-IP rewriting or another proxy changing it.

Do not add public DNS until the route and protection are ready.

## 2. Set Grafana's public URL

```bash
sudo nano /etc/grafana/grafana.ini
```

Edit the EXISTING sections/settings; uncomment with removal of the leading `;`:

```ini
[server]
protocol = http
http_addr = 127.0.0.1
http_port = 3000
domain = grafana.example.com
root_url = https://grafana.example.com/

[security]
cookie_secure = true
```

Nginx handles HTTPS; Grafana stays private HTTP. root_url controls public links
and redirects. Secure cookies require HTTPS. Do not restart until Nginx is prepared;
the old plain-HTTP tunnel login must not be assumed to work after these changes.

## 3. Create a dedicated Nginx site

```bash
sudo nano /etc/nginx/sites-available/grafana
```

For a NEW file, paste the following. The map belongs at http scope; Ubuntu's
sites-enabled files are normally included there. Do not put it inside server/location.
Use a dedicated variable name to avoid colliding with another site's map.

```nginx
map $http_upgrade $grafana_connection_upgrade {
    default upgrade;
    '' close;
}

server {
    listen 80;
    listen [::]:80;
    server_name grafana.example.com;
    return 444;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name grafana.example.com;

    ssl_certificate /etc/nginx/ssl/grafana/origin.pem;
    ssl_certificate_key /etc/nginx/ssl/grafana/origin.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    include /etc/nginx/snippets/cloudflare-only.conf;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $grafana_connection_upgrade;
        proxy_read_timeout 60s;
    }
}
```

The HTTP block closes plain-HTTP origin requests; it does not proxy to Grafana.
Use HTTPS in the browser and configure Cloudflare HTTPS redirection as appropriate.
The HTTPS block checks source addresses and proxies HTTP/WebSockets privately.
The forwarded address is Cloudflare's connection address in this simple setup;
accurate visitor-IP logging needs a separately reviewed real-IP design.
IPv6 listen directives require IPv6 support on the server; adapt if unavailable.

```bash
sudo ln -s /etc/nginx/sites-available/grafana /etc/nginx/sites-enabled/grafana
sudo nginx -t
```

The link enables configuration loading. If it already exists, inspect it instead
of overwriting it. nginx -t checks syntax and certificate files. STOP if it fails.

## 4. Apply and check locally

```bash
systemctl is-active grafana-server.service
sudo systemctl restart grafana-server.service
sudo systemctl reload nginx
```

Check the initial state, restart only Grafana to load its URL settings, then
reload Nginx only after successful validation. Check other hosted sites too.

```bash
curl --fail --silent --show-error http://127.0.0.1:3000/api/health
```

Expect database ok after startup. A public root_url does not prevent this local health check.

## 5. Publish and verify

Finish the [Cloudflare DNS/Full (strict) steps](../cloudflare/protected-https.md).
Use a private browser: expect Cloudflare authentication, then Grafana login,
no certificate warning, and working dashboard data. Never disable either login
merely to get a successful test.

Run the allowlist guide's local direct-denial check: expect 403. This does not
prove resistance to every bypass; Cloudflare IPs are shared and no Access JWT
validation is implemented by this example.

If a new setup fails, keep SSH open. Disable only the new Nginx site link with
`sudo unlink /etc/nginx/sites-enabled/grafana`, validate with `sudo nginx -t`,
then reload if valid. This removes public routing, not Grafana data or the main site.
Keep DNS/Access protection in place until the failure is understood.

Sources: [Grafana reverse proxy](https://grafana.com/tutorials/run-grafana-behind-a-proxy/),
[Origin CA](https://developers.cloudflare.com/ssl/origin-configuration/origin-ca/).
