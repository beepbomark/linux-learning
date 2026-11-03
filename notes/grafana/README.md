# Grafana: start here

Grafana displays dashboards by querying data sources such as Prometheus.
It does not replace Prometheus's measurement storage or install exporters for you.

## Guides

1. [Ubuntu setup and first dashboard](setup.md).
2. [Public HTTPS through Cloudflare and Nginx](public-access.md).
3. [Everyday commands and handover](everyday-commands.md).

The example uses native packages on one server:

| Service | Private endpoint |
| --- | --- |
| Grafana | http://127.0.0.1:3000 |
| Prometheus | http://127.0.0.1:9090 |
| Node Exporter | http://127.0.0.1:9100 |

Grafana's data-source requests come from the SERVER. In this setup localhost
means that server, not the browser user's laptop. Separate containers require
container networking instead; these loopback examples do not transfer unchanged.

A dashboard is not an alert. Alerting needs rules, a contact point, notification
routing and a successful delivery test. Monitoring hosted on the application
server cannot cover the complete loss of that server by itself.

Examples use `grafana.example.com` and SSH alias `my-server`; replace them.
These are generic guides, not claims that a particular server was configured.
