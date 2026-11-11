# Grafana: everyday commands and handover

## Common

Run on the server:

```bash
systemctl status grafana-server.service --no-pager -l
sudo journalctl -u grafana-server.service -n 50 --no-pager
```

Read full service state and recent logs. Review logs before sharing them.

```bash
curl --fail --silent --show-error http://127.0.0.1:3000/api/health
sudo ss -lntp '( sport = :3000 or sport = :9090 or sport = :9100 )'
```

Check Grafana's database/health and listener addresses. All three should remain
loopback-only in this design. Do not open them publicly to fix DNS/HTTPS issues.

After an intentional grafana.ini edit:

```bash
sudo systemctl restart grafana-server.service
```

This interrupts Grafana briefly, not Prometheus collection. Recheck health,
public login and dashboards. There is no nginx-style validation command promised
here for Grafana; inspect logs if startup fails.

## Troubleshooting

| Symptom | First check |
| --- | --- |
| Connection refused just after start | Wait briefly, then service logs and listener |
| Data source fails | Server-side Prometheus URL and readiness; not laptop localhost |
| No graph data | Time range, selected job/instance and Prometheus up query |
| Some dashboard panels empty | Optional exporter collectors and metric availability |
| Login redirects to localhost | Grafana domain/root_url and proxy Host header |
| Session/login fails only over HTTP tunnel | Secure cookies/public HTTPS configuration |
| Cloudflare 526 | Origin certificate hostname, validity and Full (strict) setup |
| Public 403 after allowlist | Proxy status, source IP/real-IP settings and current CF lists |
| Dashboard works but no alerts arrive | Rules, contact point, notification policy and delivery test |

## Log retention

Use the [general log-retention guide](../services/log-retention.md#4-grafana-built-in-file-rotation)
for Grafana's built-in file rotation and the separate journal policy.

## Backups and recovery

Keep a record of installed versions, public hostname, service/config paths,
Prometheus data-source settings, dashboard IDs/exports and alert definitions.
Native packages commonly use /var/lib/grafana for data and /etc/grafana for
configuration; inspect the actual service/package configuration before backing up.

For a simple consistent SQLite backup, plan a Grafana maintenance window, stop
Grafana, back up its data and necessary configuration securely, then start it and
verify health. Do not assume copying a live grafana.db alone is consistent.
Preserve the encryption secret used for stored credentials, any externally
configured secrets, provisioning files and needed plugins/version information.
Backups can contain credentials: keep them private, outside Git and preferably
on an independent device. Dashboard JSON alone is not a full recovery set.

## Alerts: separate work

Configure a contact point and test actual delivery before relying on alerts.
Distinguish thresholds, missing data and query errors. Do not fill a production
disk or stop a production app just to test a notification. Start with a controlled
test rule and verify firing and recovery. A separate external check is needed
for a complete outage of the server running Grafana and Prometheus.

Handover: include who owns access, where passwords are stored (no values),
certificate expiry, source-IP list refresh date, backup/restore instructions and
which notifications have actually been tested.

Source: [Grafana backup guidance](https://grafana.com/docs/grafana/latest/administration/back-up-grafana/).
