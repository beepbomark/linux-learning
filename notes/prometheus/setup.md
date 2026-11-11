# Prometheus and Node Exporter: Ubuntu setup

For a fresh Ubuntu 24.04 server using its APT packages. Other distributions and
container installs have different paths. Run commands on the server, one step at
a time. These install services; do not paste into an unrelated production host.

## 1. Inspect and install

```bash
sudo ss -lntp '( sport = :9090 or sport = :9100 )'
```

Check the ports are free. If occupied, identify the existing service first.

```bash
sudo systemctl mask prometheus.service prometheus-node-exporter.service
sudo apt update
sudo apt install --no-install-recommends prometheus prometheus-node-exporter
```

`mask` prevents startup before configuration; a not-installed-yet notice is normal.
`apt update` refreshes package lists, not installed packages. The installation skips
optional collector bundles but installs required dependencies. Review APT's summary.
Do not mask an already-running monitoring installation using this fresh-setup procedure.

## 2. Restrict listeners and history

```bash
printf '%s\n' 'ARGS="--web.listen-address=127.0.0.1:9090 --storage.tsdb.retention.time=7d --storage.tsdb.retention.size=1GB"' |
  sudo tee /etc/default/prometheus > /dev/null
```

This writes Prometheus's startup options: loopback only, seven days or the size
threshold, whichever expires blocks first. Working/head/WAL files add disk usage;
1 GB is not a hard total-disk cap. Adjust retention for the server's capacity.

```bash
printf '%s\n' 'ARGS="--web.listen-address=127.0.0.1:9100"' |
  sudo tee /etc/default/prometheus-node-exporter > /dev/null
```

This restricts Node Exporter. These commands replace the defaults files; on an
existing installation preserve and review any other required arguments instead.

## 3. Configure collection

```bash
sudo nano /etc/prometheus/prometheus.yml
```

Replace the sample file with ONLY the following (do not append a second
`scrape_configs` block). Save with Ctrl+O, Enter; exit with Ctrl+X.

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['127.0.0.1:9090']
  - job_name: node
    static_configs:
      - targets: ['127.0.0.1:9100']
```

Each endpoint is collected every 15 seconds. The evaluation interval applies to
rules; none are configured yet. No Alertmanager is needed for this basic setup.

## 4. Validate, then start

```bash
promtool check config /etc/prometheus/prometheus.yml
```

Expect SUCCESS. Stop if invalid; do not start until corrected.

```bash
sudo systemctl unmask prometheus.service prometheus-node-exporter.service
sudo systemctl enable --now prometheus-node-exporter.service prometheus.service
```

`unmask` removes startup blocks. `enable --now` starts services and enables boot startup.

```bash
curl --fail --silent --show-error http://127.0.0.1:9090/-/ready
sudo ss -lntp '( sport = :9090 or sport = :9100 )'
```

Expect readiness and ONLY 127.0.0.1 listeners. Startup may take a few seconds.
A `0.0.0.0`, `[::]` or `*` listener needs correction before exposure.

Wait at least 15 seconds, then:

```bash
curl --fail --silent --show-error   'http://127.0.0.1:9090/api/v1/query?query=up'
```

Expect jobs `prometheus` and `node`, both with value 1. A value 0 needs investigation.

## 5. Record the installation

```bash
prometheus --version
prometheus-node-exporter --version
systemctl is-enabled prometheus.service prometheus-node-exporter.service
```

Record versions and enablement in your private server inventory. Package versions
change; do not assume these notes install a particular release.

Next: [install Grafana](../grafana/setup.md).

Sources: [Prometheus configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/),
[storage](https://prometheus.io/docs/prometheus/latest/storage/).
