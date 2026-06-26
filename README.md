# Grafana Dashboards

<p align="left">
  <img src="https://raw.githubusercontent.com/RomeoCavazza/setup-os/refs/heads/main/docs/assets/logo/graphana.png" alt="Grafana" width="26" />
  <img src="https://raw.githubusercontent.com/RomeoCavazza/setup-os/refs/heads/main/docs/assets/logo/loki.png" alt="Loki" width="26" />
  <img src="https://raw.githubusercontent.com/RomeoCavazza/setup-os/refs/heads/main/docs/assets/logo/prometheus.png" alt="Prometheus" width="26" />
</p>

This repository contains the Grafana dashboard sources extracted from
[`setup-os`](https://github.com/RomeoCavazza/setup-os).

The stack is intentionally small: Prometheus and Node Exporter handle metrics,
Loki and Promtail handle logs, and Grafana ties the signals together.

| Component | Endpoint | Role |
| --- | --- | --- |
| Prometheus | `localhost:9090` | Metrics TSDB and query engine |
| Node Exporter | `localhost:9100` | Host metrics plus textfile collector |
| NVIDIA GPU Exporter | `localhost:9835` | GPU metrics: VRAM, power, utilization |
| Loki | `localhost:3100` | Centralized logs |
| Promtail | systemd service | Journald scraping and labeling |
| Grafana | `localhost:3001` | Dashboards and correlation UI |

## Dashboards

The monitoring suite has three specialized operational views sharing a unified
25-gauge rail on the left. That rail provides a constant heartbeat of the
system: uptime, PSI, temperature, store pressure, incidents, and desktop state.

### System Cockpit

The primary view for overall system health and real-time monitoring.

![NixOS Metrics Live](https://raw.githubusercontent.com/RomeoCavazza/setup-os/refs/heads/main/docs/assets/live/live-dashboard.png)

Files: [`src/nix-dashboard.jsonnet`](src/nix-dashboard.jsonnet) ->
[`nixos-metrics.json`](nixos-metrics.json)

- **Operational rail**: CPU/RAM/PSI, thermal sensors, store fill, journal
  incidents, Hyprland status.
- **Resource pressure heatmap**: multi-dimensional CPU, memory, and I/O
  pressure with sharpened raw spikes.
- **Resource pressure timeline**: historical PSI trends for identifying
  bottlenecks.
- **Temperature sensors**: detailed chip and thermal zone monitoring: CPU,
  NVMe, and more.
- **NVIDIA GPU metrics**: VRAM occupancy and real-time power draw.

### Nix Efficiency

Tracking drift, generation debt, and the cost of system rebuilds.

![Nix Efficiency](https://raw.githubusercontent.com/RomeoCavazza/setup-os/refs/heads/main/docs/assets/live/nix-efficiency.png)

Files: [`src/nix-efficiency-dashboard.jsonnet`](src/nix-efficiency-dashboard.jsonnet)
-> [`nix-efficiency.json`](nix-efficiency.json)

- **Generation debt**: `nix_generations_count` and
  `nix_flake_lock_age_seconds`.
- **Closure shape**: `nix_closure_bytes` versus `nix_store_bytes` ratio.
- **Store performance**: rebuild activity calendar and scheduler pulse.
- **System stress context**: pressure timeline and thermal sensors to monitor
  the impact of heavy builds.

### Incident Diagnostics

Log correlation matched with hardware risk signals for fast root-cause
analysis.

![Incident Dashboard](https://raw.githubusercontent.com/RomeoCavazza/setup-os/refs/heads/main/docs/assets/live/incident-dashboard.png)

Files: [`src/incident-correlation-dashboard.jsonnet`](src/incident-correlation-dashboard.jsonnet)
-> [`incident-correlation.json`](incident-correlation.json)

- **Incident risk river**: stream graph of disk and network risk signals versus
  log volume.
- **Journal logs**: filtered incident feed: `failed`, `panic`, `segfault`, and
  related terms.
- **Network and disk faults**: I/O throughput versus latency and network error
  rates.
- **Correlation context**: pressure timeline and GPU metrics to match log
  events with hardware stress.

## Prometheus

Prometheus is the verification layer. If a dashboard panel looks wrong, this is
where raw `nix_*` or `node_*` series are checked first.

![Prometheus query view](https://raw.githubusercontent.com/RomeoCavazza/setup-os/refs/heads/main/docs/assets/prometheus.png)

## Maintenance

### Sources

Dashboards are written in [`src/*.jsonnet`](src/) and rendered into JSON at the
repository root. The shared panel catalog lives in
[`src/nixos-compiled.jsonnet`](src/nixos-compiled.jsonnet); the three
dashboards reuse those panels so gauges and graph modules are defined once.

[`src/lib/dashboard.libsonnet`](src/lib/dashboard.libsonnet) keeps a small
Grafonnet-style helper API.

### Logs

Promtail adds a `component` label for targeted LogQL queries:

- `component="display"`: Hyprland and display stack.
- `component="build"`: Nix build and rebuild logs.
- `component="system"`: default systemd journal.

### Snapshots

[`grafana-snapshot-sync.timer`](https://github.com/RomeoCavazza/setup-os/blob/main/config/bin/grafana-snapshot-sync)
captures dashboard PNGs every 6 hours from Grafana on port `3001`. PNGs with a
meaningful visual delta are pushed to
[`docs/assets/live/`](https://github.com/RomeoCavazza/setup-os/tree/main/docs/assets/live)
in `setup-os`.

### Regenerate

The NixOS services and provisioning live in
[`modules/observability.nix`](https://github.com/RomeoCavazza/setup-os/blob/main/modules/observability.nix)
inside `setup-os`. Regenerate rendered JSON from a `setup-os` checkout that
mounts this repo at `config/grafana`:

```sh
cd /etc/nixos
sudo -E nix shell nixpkgs#jsonnet nixpkgs#jq -c ./config/bin/grafana-generate
```
