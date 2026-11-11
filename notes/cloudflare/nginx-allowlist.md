# Download Cloudflare IPv4/IPv6 and allow them in Nginx

Goal: permit Cloudflare's networks to reach ONE Nginx site and deny other sources.
This is the command reference to use when setting up or refreshing that allowlist.

Run on an Ubuntu server with Nginx, curl and Python 3. Stop on any error.
Keep an SSH session open. This does not change SSH or firewall rules.
Do not apply the snippet globally or to unrelated sites.

## 1. Check how Nginx sees source addresses

```bash
sudo nginx -T 2>/dev/null |
  grep -E '^[[:space:]]*(real_ip_header|set_real_ip_from|real_ip_recursive)[[:space:]]'
```

This displays IP-rewrite settings, not private keys. With no output, the direct
Cloudflare → Nginx setup below can normally use the connection's source IP.
If output appears, or another proxy/load balancer sits in front of Nginx, stop
and review the design: allow/deny may see a rewritten visitor IP or another proxy.
Do not remove existing real-IP settings or trust arbitrary forwarded headers.

## 2. Download BOTH official network lists

Use a new working directory so a failed download cannot leave a stale list:

```bash
CF_WORK=$(mktemp -d)
cd "$CF_WORK"
```

`mktemp -d` creates a new temporary directory; `CF_WORK` remembers its path.
Use the same terminal for the following steps.

```bash
curl --fail --silent --show-error --location   https://www.cloudflare.com/ips-v4 -o ipv4.txt
```

```bash
curl --fail --silent --show-error --location   https://www.cloudflare.com/ips-v6 -o ipv6.txt
```

`--fail` rejects HTTP errors; `--show-error` displays failures; `-o` saves the
response. These are public lists, not credentials. If either fails, do not proceed.

## 3. Validate the lists and create an Nginx snippet

```bash
python3 - <<'PYCODE'
import ipaddress
from pathlib import Path

rules = []
for filename, version in (("ipv4.txt", 4), ("ipv6.txt", 6)):
    lines = Path(filename).read_text().splitlines()
    networks = [ipaddress.ip_network(line.strip()) for line in lines if line.strip()]
    if not networks or any(n.version != version or n.prefixlen == 0 for n in networks):
        raise SystemExit(f"Refusing empty, wrong-family or all-address list: {filename}")
    rules.extend(f"allow {network};" for network in networks)
Path("cloudflare-only.conf").write_text("\n".join(rules + ["deny all;"]) + "\n")
print(f"Created {len(rules)} allow rules followed by deny all.")
PYCODE
```

Python's standard `ipaddress` module rejects malformed addresses. Both families
must be nonempty; an all-address range is refused. Output is written only after
both lists validate. This validates structure, not the publisher's identity;
HTTPS and the official URLs remain the source of trust.

```bash
cat cloudflare-only.conf
```

Review it: `allow ...;` lines first, then one `deny all;`. Nginx uses the first
matching rule, so putting `deny all;` at the top would block everyone.

For understanding, the conversion itself is simply
`awk 'NF { print "allow " $1 ";" }' ipv4.txt ipv6.txt`, followed by `deny all;`.
Use the validated generation above for the actual file.

## 4. Install the snippet

If updating an existing snippet, preserve its previous version first:

```bash
# Run only if the current file exists.
sudo cp -a /etc/nginx/snippets/cloudflare-only.conf   /etc/nginx/snippets/cloudflare-only.conf.previous
```

This keeps its permissions and contents for rollback. On first setup, skip that
command. Do not overwrite a previous rollback copy you still need.

```bash
sudo install -m 0644 cloudflare-only.conf /etc/nginx/snippets/cloudflare-only.conf
```

This copies the generated file into Nginx's configuration directory. It does not reload Nginx.

## 5. Include it in the intended site

Edit your existing site (replace the filename):

```bash
sudo nano /etc/nginx/sites-available/my-site
```

Inside that site's HTTPS `server { ... }` block, add:

```nginx
include /etc/nginx/snippets/cloudflare-only.conf;
```

Do not replace the whole existing site with this one line. See the complete
[Grafana example](../grafana/public-access.md) for a fresh dedicated site.
Save Nano with Ctrl+O, Enter; exit with Ctrl+X.

A location containing its own `allow` or `deny` directives overrides inherited
access rules. Review all locations so a health/WebSocket path does not bypass the
restriction. A bare server-level `return` can also run before access checks.
Keep the application's backend listening only on loopback.

## 6. Validate BEFORE reloading

```bash
sudo nginx -t
```

If it fails, do not reload. Fix the reported error or restore the previous
snippet with `sudo cp -a` from the `.previous` file, then validate again.
For first setup, remove only the include line you just added if rolling back.

When validation succeeds:

```bash
sudo systemctl reload nginx
```

This gracefully applies the configuration. It affects the shared Nginx process,
so also check your other public sites after the reload.

## 7. Verify public access and direct denial

Open the proxied hostname in a private browser window. Confirm Access login
(if configured), application login, and normal application behavior.

On the server, using the REAL hostname:

```bash
curl --insecure --silent --show-error   --resolve grafana.example.com:443:127.0.0.1   --output /dev/null --write-out '%{http_code}\n'   https://grafana.example.com/
```

`--resolve` connects directly to local Nginx while retaining hostname/SNI.
`--insecure` is for this diagnostic only, because curl does not normally trust
Cloudflare Origin CA. Expect `403` if localhost is not allowed. This checks that
path only, not every possible origin bypass. An external origin test can be a
separate controlled check; do not publish the origin address.

## Maintenance and gotchas

- Refresh BOTH lists from the official endpoints; do not copy a static list
  from an old tutorial. Repeat validation, rollback preparation and reload.
- Keep the DNS record proxied. DNS-only visitors will be denied by this design.
- If real-IP rewriting or another proxy is later added, review this rule again.
- Cloudflare's source networks are shared: this is not proof of your account,
  your Access policy, or a particular user. Do not disable application login.
- This is an Nginx restriction, not a firewall covering every port.
- Do not open backend ports 3000, 9090 or 9100 publicly for troubleshooting.

Sources: [official IPv4](https://www.cloudflare.com/ips-v4),
[official IPv6](https://www.cloudflare.com/ips-v6),
[Nginx access rules and inheritance](https://nginx.org/en/docs/http/ngx_http_access_module.html).
