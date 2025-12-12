# Grafana Dashboard Generator

This project provides an automated solution for generating and deploying Grafana dashboards for Kubernetes services. It discovers services with monitoring enabled, generates customized dashboards from a template, and deploys them to Grafana via Kubernetes ConfigMaps. The system also supports pushing generated dashboards back to a GitLab repository for version control.

## Overview

The dashboard generator consists of several components:

1. **Kubernetes CronJob**: Runs periodically to discover services and generate dashboards
2. **Dashboard Template**: A Grafana dashboard JSON template with placeholders for service-specific data
3. **GitLab Integration**: Fetches templates and pushes generated dashboards to GitLab
4. **Grafana Sidecar**: Automatically loads dashboards from ConfigMaps
5. **Prometheus Stack**: Provides metrics collection and querying capabilities

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   CronJob       │    │   GitLab Repo    │    │   Kubernetes    │
│   (every 10min) │◄──►│   Template       │    │   ConfigMaps    │
│                 │    │   Storage        │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                                                │
         ▼                                                ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Service       │    │   Grafana        │    │   Prometheus     │
│   Discovery     │───►│   Sidecar        │◄───│   Metrics        │
│                 │    │   Auto-load      │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## How It Works

### 1. Service Discovery
The system discovers Kubernetes deployments labeled with `monitoring=enabled` across all namespaces. For each discovered service, it extracts the namespace and service name.

### 2. Template Fetching
The generator clones a GitLab repository to retrieve the dashboard template (`dashboards/template.json.tpl`). This template contains placeholders that are replaced with service-specific values.

### 3. Dashboard Generation
For each discovered service, the system:
- Sets environment variables (SERVICE_NAME, NAMESPACE, TITLE, etc.)
- Uses `envsubst` to replace placeholders in the template
- Generates a unique dashboard ID and UID
- Creates a JSON dashboard configuration

### 4. Deployment to Grafana
Generated dashboards are stored in a Kubernetes ConfigMap with the label `grafana_dashboard: "1"`. Grafana's sidecar component automatically detects and loads these ConfigMaps.

### 5. GitLab Synchronization
The system also creates individual ConfigMap YAML files for each dashboard and pushes them back to the GitLab repository for version control and backup.

## Prerequisites

- Kubernetes cluster with kubectl access
- Helm 3.x
- GitLab repository with dashboard template
- Flux CD (for HelmRelease management) or direct kubectl apply

## Installation

### 1. Deploy Prometheus Stack

Apply the `release.yaml` to deploy the Prometheus monitoring stack with Grafana:

```bash
kubectl apply -f release.yaml
```

This installs:
- Prometheus with remote write receiver for OTLP metrics
- Grafana with Tempo and Loki datasources configured
- Kube-state-metrics and Node Exporter
- Grafana ingress at `grafana.10.70.0.45.nip.io`

### 2. Configure GitLab Credentials

Create the GitLab credentials secret:

```bash
kubectl apply -f gitlab-credentials-secret.yaml
```

Update the secret values according to your GitLab setup:
- `GITLAB_URL`: Your GitLab instance URL (e.g., `gitlab.com`)
- `GITLAB_TOKEN`: Personal access token with repository access
- `GITLAB_REPO`: Repository in format `username/repo`
- `GITLAB_BRANCH`: Branch to push dashboards to (default: `main`)
- `DASHBOARDS_PATH`: Path in repo where dashboards are stored

### 3. Deploy Dashboard Generator

Apply the ConfigMap and CronJob:

```bash
kubectl apply -f dashboard-generator-configmap.yaml
kubectl apply -f dashboard-generator-cronjob-final.yaml
```

## Configuration

### Service Labeling

To enable monitoring for a service, add the `monitoring=enabled` label to its deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-service
  labels:
    monitoring: enabled
spec:
  # ... deployment spec
```

### Dashboard Template

The template (`dashboards/template.json.tpl`) is a standard Grafana dashboard JSON with the following placeholders:

- `${SERVICE_NAME}`: Service name (lowercase)
- `${NAMESPACE}`: Kubernetes namespace
- `${TITLE}`: Dashboard title (service name uppercase + " Dashboard")
- `${DASHBOARD_UID}`: Unique dashboard identifier (`service-namespace`)
- `${DASHBOARD_ID}`: Numeric dashboard ID (auto-incremented)

### Metrics Assumptions

The template assumes:
- **Ingress Controller**: Traefik (metrics: `traefik_service_requests_total`, `traefik_service_request_duration_seconds_bucket`)
- **Service Naming**: Services follow pattern `namespace-service`
- **Trace Metrics**: Available via `traces_spanmetrics_*` metrics
- **Resource Metrics**: Standard Kubernetes pod metrics

### Customization

To customize dashboards:
1. Modify the `template.json.tpl` in your GitLab repository
2. Update Prometheus queries to match your metrics
3. Adjust panel configurations as needed
4. Commit and push changes to trigger regeneration

## Dashboard Panels

The generated dashboards include the following panels:

### Overview Metrics (Top Row)
- **Request Rate (RPS)**: Current requests per second
- **Error Rate %**: Percentage of 5xx responses
- **P95 Latency**: 95th percentile response time
- **Uptime/Healthcheck**: Service availability status

### Time Series Charts
- **Request Rate Over Time**: Historical RPS trends
- **Error Rate Over Time**: Error percentage trends
- **Latency Distribution**: P50/P95/P99 percentiles

### Detailed Analysis
- **Top Slow Endpoints**: Endpoints with highest P95 latency
- **Top Error Status Codes**: Distribution of error codes
- **Top Failing Endpoints**: Endpoints with most 5xx errors
- **Resource Usage**: CPU and memory consumption
- **Latency Heatmap**: P95 latency distribution over time

### Observability Integration
- **Traces - Service Latency**: Tempo traces for the service
- **Top Root Cause Span Attributes**: Trace analysis
- **Application Logs**: Loki logs filtered by service

## Monitoring and Troubleshooting

### Check CronJob Status
```bash
kubectl get cronjobs -n internal
kubectl get jobs -n internal
kubectl logs -n internal job/dashboard-generator-<job-id>
```

### View Generated Dashboards
```bash
kubectl get configmaps -n internal -l grafana_dashboard=1
kubectl describe configmap <dashboard-configmap> -n internal
```

### Access Grafana
Navigate to `http://grafana.10.70.0.45.nip.io` (admin/admin123)

### Common Issues

1. **No Services Discovered**
   - Ensure deployments have `monitoring=enabled` label
   - Check RBAC permissions for the service account

2. **Template Not Found**
   - Verify GitLab credentials and repository access
   - Check `DASHBOARDS_PATH` in the secret

3. **Dashboards Not Loading in Grafana**
   - Verify ConfigMap has `grafana_dashboard: "1"` label
   - Check Grafana sidecar logs

4. **Metrics Not Showing**
   - Ensure Prometheus is scraping the services
   - Verify metric names match the template queries

## Security Considerations

- Store GitLab tokens securely in Kubernetes secrets
- Use RBAC to limit service account permissions
- Regularly rotate GitLab access tokens
- Monitor for unauthorized dashboard modifications

## Development

### Local Testing
1. Clone this repository
2. Modify template and configuration files
3. Test with `kubectl apply` in a development cluster
4. Verify dashboards appear in Grafana

### Extending the Template
- Add new panels by following Grafana's JSON structure
- Use additional placeholders for customization
- Test queries in Prometheus/Grafana first