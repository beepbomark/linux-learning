# Grafana OSS: Ubuntu setup and first dashboard

Prerequisites: Ubuntu with systemd, curl, CA certificates and
[working Prometheus/Node Exporter](../prometheus/setup.md).
Run server commands yourself. This is for a fresh installation.

## 1. Install from the official repository

```bash
sudo systemctl mask grafana-server.service
sudo install -d -m 0755 /etc/apt/keyrings
```

Block startup before configuration and create the public package-key directory.
A missing-unit notice before installation is normal.

```bash
sudo curl --fail --silent --show-error --location   https://apt.grafana.com/gpg-full.key -o /etc/apt/keyrings/grafana.asc
sudo chmod 0644 /etc/apt/keyrings/grafana.asc
```

Download the official public signing key and make it readable to APT. Stop if the
download fails. This scopes package verification to the repository below.

```bash
printf '%s\n' 'deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main' |
  sudo tee /etc/apt/sources.list.d/grafana.list > /dev/null
sudo apt update
sudo apt install --no-install-recommends grafana
```

Add the stable repository, refresh available packages, then install OSS Grafana.
`apt update` alone does NOT upgrade installed packages. Review the install summary.

## 2. Configure private access

```bash
sudo nano /etc/grafana/grafana.ini
```

Edit these settings in their EXISTING sections, removing leading semicolons.
Do not replace the entire packaged file or duplicate sections:

```ini
[server]
protocol = http
http_addr = 127.0.0.1
http_port = 3000

[users]
allow_sign_up = false

[auth.anonymous]
enabled = false
```

Loopback restricts the listener. Account creation is administrator-controlled,
and anonymous access is disabled. Keep other defaults for initial setup.
Save Nano with Ctrl+O, Enter; exit with Ctrl+X.

```bash
sudo ss -lntp '( sport = :3000 )'
```

Check nothing else occupies port 3000 before starting.

```bash
sudo systemctl unmask grafana-server.service
sudo systemctl enable --now grafana-server.service
```

Allow startup, start now and enable at boot.

```bash
curl --fail --silent --show-error http://127.0.0.1:3000/api/health
sudo ss -lntp '( sport = :3000 )'
```

Expect database ok and ONLY 127.0.0.1:3000. Wait a few seconds if startup is still
in progress. If it remains unavailable, read service status/logs, not a blind restart loop.

## 3. Sign in over an SSH tunnel

Run in a NEW terminal on your laptop, using your configured SSH alias:

```bash
ssh -N -L 127.0.0.1:3000:127.0.0.1:3000 my-server
```

`-N` runs no remote shell. `-L` forwards laptop port 3000 to the server's private
Grafana listener. Keep the terminal open; Ctrl+C closes the tunnel. If laptop
port 3000 is occupied, use local port 3300 in the first address and browse port 3300.

Open http://127.0.0.1:3000 on the laptop. For a fresh default installation, use
admin/admin, immediately change the password, and save it in a password manager.
Never post the password. This tunnel-first login is before public URL/secure-cookie configuration.

## 4. Add Prometheus

Connections → Add new connection → Prometheus → Add new data source:

| Setting | Value |
| --- | --- |
| Name | Prometheus |
| Default | On |
| Server URL | http://127.0.0.1:9090 |
| Authentication | No authentication for this loopback-only setup |
| Scrape interval | 15s, matching Prometheus |

Click Save & test. Then Explore → select the data source → Code → enter `up`
and run. Expect prometheus and node, both 1. Their chart lines overlap.

## 5. Import a host dashboard

Dashboards → New → Import → enter dashboard ID `1860` → Load.
Select your Prometheus data source and Import. This is the community
[Node Exporter Full](https://grafana.com/grafana/dashboards/1860-node-exporter-full/) dashboard.

Select job `node` and your exporter instance. Use Last 15 minutes initially and
refresh every 30 seconds or 1 minute. CPU/RAM/disk/network should populate.
Some optional collectors are disabled by default, so some panels may remain empty.
Older periods are empty because measurements were not collected then.

Next: [public HTTPS access](public-access.md). No dashboard import creates alerts.

Sources: [Ubuntu installation](https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/),
[Prometheus data source](https://grafana.com/docs/grafana/latest/datasources/prometheus/configure/),
[dashboard import](https://grafana.com/docs/grafana/latest/visualizations/dashboards/build-dashboards/import-dashboards/).
