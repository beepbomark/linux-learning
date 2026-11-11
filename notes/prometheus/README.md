# Prometheus: start here

Prometheus collects numeric measurements and stores their history. Grafana queries
that history to draw dashboards. Node Exporter exposes Linux CPU, RAM, disk and
network metrics; it does not automatically measure application health.

```text
Linux → Node Exporter :9100 → Prometheus :9090 ← Grafana :3000 ← browser
                             pulls every 15s    queries
```

## Guides

- [Install on Ubuntu](setup.md): packages, private listeners and first scrape.
- [Everyday commands](everyday-commands.md): health, targets and simple queries.
- [Grafana](../grafana/): visualization and dashboard setup.

## Vocabulary

| Term | Meaning |
| --- | --- |
| Metric | Named measurement, such as available memory bytes |
| Sample | One measured value and its timestamp |
| Label | Identifies a series, such as job or instance |
| Target | Endpoint Prometheus collects from |
| Scrape | Prometheus requests the endpoint's /metrics data |
| Exporter | Program exposing another system's measurements |
| PromQL | Query language for selecting/calculating measurements |
| Retention | How much measurement history is kept |

`job="node"` groups host metrics. `instance="127.0.0.1:9100"` identifies the
endpoint from Prometheus's perspective, not from your laptop's perspective.

## Gotchas

- Metrics start when collection starts. Empty earlier charts are expected.
- `up=1` means the endpoint was scraped; it does not prove the website works.
- `up=0` means a scrape failed. An absent series means something different:
  the target may have been removed or the data may not exist.
- RAM cache can be reclaimed; use MemAvailable when assessing memory pressure.
- No swap means swap panels may show N/A, not necessarily an exporter failure.
- Retention is not backup. Same-host monitoring cannot notify through a whole-host outage.
- Keep the metrics endpoints private; they reveal machine details.

Sources: [overview](https://prometheus.io/docs/introduction/overview/),
[Node Exporter](https://prometheus.io/docs/guides/node-exporter/).
