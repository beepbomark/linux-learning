# Prometheus: everyday commands

Run on the monitored server unless stated otherwise.

## Common

```bash
systemctl status prometheus.service prometheus-node-exporter.service --no-pager
```

Shows service state. Active processes alone do not prove successful collection.

```bash
sudo journalctl -u prometheus.service -n 50 --no-pager
sudo journalctl -u prometheus-node-exporter.service -n 50 --no-pager
```

Read recent logs. Review for sensitive values before sharing.

```bash
curl --fail --silent --show-error http://127.0.0.1:9090/-/ready
curl --fail --silent --show-error http://127.0.0.1:9090/api/v1/targets
```

Readiness checks the server. Targets include scrape health and last errors.

## Changing configuration

After editing prometheus.yml:

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Stop on validation errors. If valid:

```bash
sudo systemctl reload prometheus.service
```

The Ubuntu package reloads scrape/rule configuration without restarting. Changes
to /etc/default startup flags require a restart instead:

```bash
sudo systemctl restart prometheus.service
```

This briefly interrupts collection. Recheck readiness and `up` afterward.
For exporter flag changes, restart `prometheus-node-exporter.service` and check its target.

## Simple queries

Enter these in Grafana Explore → Prometheus → Code, then run the query:

| Query | Meaning |
| --- | --- |
| `up` | Latest collection success per target: 1 good, 0 failed |
| `node_memory_MemAvailable_bytes{job="node"}` | RAM available for applications, in bytes |
| `100 * (1 - node_memory_MemAvailable_bytes{job="node"} / node_memory_MemTotal_bytes{job="node"})` | Approximate RAM usage percentage |
| `node_filesystem_avail_bytes{job="node",mountpoint="/"}` | Root filesystem bytes available to normal users |
| `100 * (1 - avg by(instance) (rate(node_cpu_seconds_total{job="node",mode="idle"}[5m])))` | CPU busy percentage over five minutes |

Rates need several samples; a newly started installation may initially show no
result. Metric availability depends on the host/exporter. These are exploratory
queries, not a complete alert configuration.

## Troubleshooting

| Symptom | Check |
| --- | --- |
| Connection refused | Service status/logs; wait for startup; check listener |
| node target down | Exporter status, port and scrape address |
| No older data | Collection start and retention period |
| YAML error | Indentation with spaces; duplicate top-level keys |
| Disk growth | Actual storage path, retention flags, WAL/head usage |

Find package-specific startup/data paths using `systemctl cat prometheus.service`
and `prometheus --help`; don't assume a Docker volume location for native packages.

Handover: record versions, targets, scrape interval, retention, configuration/data
paths, backup policy, and who receives alerts. No alerts exist merely because the
Prometheus page is green.

Sources: [HTTP API](https://prometheus.io/docs/prometheus/latest/querying/api/),
[queries](https://prometheus.io/docs/prometheus/latest/querying/basics/).
