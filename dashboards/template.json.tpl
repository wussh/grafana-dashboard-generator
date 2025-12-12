{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "fiscalYearStartMonth": 0,
  "graphTooltip": 0,
  "id": ${DASHBOARD_ID},
  "links": [],
  "panels": [
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          },
          "unit": "reqps"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 6,
        "x": 0,
        "y": 0
      },
      "id": 1,
      "options": {
        "colorMode": "background",
        "graphMode": "area",
        "justifyMode": "center",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "sum(rate(traefik_service_requests_total{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[5m]))",
          "legendFormat": "RPS",
          "refId": "A"
        }
      ],
      "title": "Request Rate (RPS)",
      "type": "stat"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "yellow",
                "value": 5
              },
              {
                "color": "red",
                "value": 10
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 6,
        "x": 6,
        "y": 0
      },
      "id": 2,
      "options": {
        "colorMode": "value",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "sum(rate(traefik_service_requests_total{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\",code=~\"5..\"}[5m])) / sum(rate(traefik_service_requests_total{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[5m])) * 100",
          "legendFormat": "Error %",
          "refId": "A"
        }
      ],
      "title": "Error Rate %",
      "type": "stat"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "yellow",
                "value": 500
              },
              {
                "color": "red",
                "value": 1000
              }
            ]
          },
          "unit": "ms"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 6,
        "x": 12,
        "y": 0
      },
      "id": 3,
      "options": {
        "colorMode": "value",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "histogram_quantile(0.95, sum(rate(traefik_service_request_duration_seconds_bucket{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[5m])) by (le)) * 1000",
          "legendFormat": "P95",
          "refId": "A"
        }
      ],
      "title": "P95 Latency (ms)",
      "type": "stat"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "thresholds"
          },
          "mappings": [],
          "max": 100,
          "min": 0,
          "thresholds": {
            "mode": "percentage",
            "steps": [
              {
                "color": "red",
                "value": null
              },
              {
                "color": "yellow",
                "value": 50
              },
              {
                "color": "green",
                "value": 100
              }
            ]
          },
          "unit": "percent"
        },
        "overrides": []
      },
      "gridPos": {
        "h": 4,
        "w": 6,
        "x": 18,
        "y": 0
      },
      "id": 4,
      "options": {
        "colorMode": "background",
        "graphMode": "none",
        "justifyMode": "center",
        "orientation": "auto",
        "percentChangeColorMode": "standard",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "showPercentChange": false,
        "textMode": "auto",
        "wideLayout": true
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "(kube_deployment_status_replicas_available{namespace=\"${NAMESPACE}\",deployment=\"${SERVICE_NAME}\"} / kube_deployment_spec_replicas{namespace=\"${NAMESPACE}\",deployment=\"${SERVICE_NAME}\"}) * 100",
          "legendFormat": "Uptime %",
          "refId": "A"
        }
      ],
      "title": "Uptime / Healthcheck",
      "type": "stat"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "Requests/sec",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 0,
        "y": 4
      },
      "id": 5,
      "options": {
        "legend": {
          "calcs": [
            "mean",
            "max",
            "lastNotNull"
          ],
          "displayMode": "table",
          "placement": "right",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "sum(rate(traefik_service_requests_total{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[1m])) by (code)",
          "legendFormat": "{{ code }}",
          "refId": "A"
        }
      ],
      "title": "Request Rate (RPS) - Time Series",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "Error %",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "yellow",
                "value": 5
              },
              {
                "color": "red",
                "value": 10
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 12,
        "y": 4
      },
      "id": 6,
      "options": {
        "legend": {
          "calcs": [
            "mean",
            "max",
            "lastNotNull"
          ],
          "displayMode": "table",
          "placement": "right",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "sum(rate(traefik_service_requests_total{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\",code=~\"5..\"}[1m])) / sum(rate(traefik_service_requests_total{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[1m])) * 100",
          "legendFormat": "Error %",
          "refId": "A"
        }
      ],
      "title": "Error Rate % - Time Series",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "Latency (ms)",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 24,
        "x": 0,
        "y": 10
      },
      "id": 7,
      "options": {
        "legend": {
          "calcs": [
            "mean",
            "max",
            "lastNotNull"
          ],
          "displayMode": "table",
          "placement": "bottom",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "histogram_quantile(0.50, sum(rate(traefik_service_request_duration_seconds_bucket{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[1m])) by (le)) * 1000",
          "legendFormat": "P50",
          "refId": "A"
        },
        {
          "expr": "histogram_quantile(0.95, sum(rate(traefik_service_request_duration_seconds_bucket{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[1m])) by (le)) * 1000",
          "legendFormat": "P95",
          "refId": "B"
        },
        {
          "expr": "histogram_quantile(0.99, sum(rate(traefik_service_request_duration_seconds_bucket{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[1m])) by (le)) * 1000",
          "legendFormat": "P99",
          "refId": "C"
        }
      ],
      "title": "Latency Distribution (P50/P95/P99)",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 0,
        "y": 16
      },
      "id": 8,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true,
        "sortBy": [
          {
            "desc": true,
            "field": "Value"
          }
        ]
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "topk(10, histogram_quantile(0.95, sum(rate(traefik_service_request_duration_seconds_bucket{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[5m])) by (endpoint, le)) * 1000)",
          "format": "table",
          "instant": true,
          "refId": "A"
        }
      ],
      "title": "Top Slow Endpoints (P95 Latency)",
      "type": "table"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            }
          },
          "mappings": []
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 12,
        "y": 16
      },
      "id": 9,
      "options": {
        "displayLabels": [
          "name",
          "percent"
        ],
        "legend": {
          "displayMode": "list",
          "placement": "bottom",
          "showLegend": true
        },
        "pieType": "pie",
        "reduceOptions": {
          "calcs": [
            "lastNotNull"
          ],
          "fields": "",
          "values": false
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "single",
          "sort": "none"
        }
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "topk(5, sum(rate(traefik_service_requests_total{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\",code=~\"[45]..\"}[5m])) by (code))",
          "legendFormat": "{{ code }}",
          "refId": "A"
        }
      ],
      "title": "Top Error Status Codes",
      "type": "piechart"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 24,
        "x": 0,
        "y": 22
      },
      "id": 10,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true,
        "sortBy": [
          {
            "desc": true,
            "field": "Value"
          }
        ]
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "topk(15, sum(rate(traefik_service_requests_total{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\",code=~\"5..\"}[5m])) by (service))",
          "format": "table",
          "instant": true,
          "refId": "A"
        }
      ],
      "title": "Top Failing Endpoints (5xx)",
      "type": "table"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "CPU Cores",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "yellow",
                "value": 0.5
              },
              {
                "color": "red",
                "value": 0.8
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 0,
        "y": 28
      },
      "id": 11,
      "options": {
        "legend": {
          "calcs": [
            "mean",
            "max",
            "lastNotNull"
          ],
          "displayMode": "table",
          "placement": "right",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "sum(rate(container_cpu_usage_seconds_total{namespace=\"${NAMESPACE}\",pod=~\"${SERVICE_NAME}.*\"}[5m])) by (pod)",
          "legendFormat": "{{ pod }}",
          "refId": "A"
        }
      ],
      "title": "Resource Usage - CPU (pod)",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "color": {
            "mode": "palette-classic"
          },
          "custom": {
            "axisBorderShow": false,
            "axisCenteredZero": false,
            "axisColorMode": "text",
            "axisLabel": "Memory (MB)",
            "axisPlacement": "auto",
            "barAlignment": 0,
            "barWidthFactor": 0.6,
            "drawStyle": "line",
            "fillOpacity": 0,
            "gradientMode": "none",
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "insertNulls": false,
            "lineInterpolation": "linear",
            "lineWidth": 2,
            "pointSize": 5,
            "scaleDistribution": {
              "type": "linear"
            },
            "showPoints": "never",
            "spanNulls": true,
            "stacking": {
              "group": "A",
              "mode": "none"
            },
            "thresholdsStyle": {
              "mode": "off"
            }
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              },
              {
                "color": "yellow",
                "value": 300
              },
              {
                "color": "red",
                "value": 500
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 12,
        "x": 12,
        "y": 28
      },
      "id": 12,
      "options": {
        "legend": {
          "calcs": [
            "mean",
            "max",
            "lastNotNull"
          ],
          "displayMode": "table",
          "placement": "right",
          "showLegend": true
        },
        "tooltip": {
          "hideZeros": false,
          "mode": "multi",
          "sort": "none"
        }
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "sum(container_memory_usage_bytes{namespace=\"${NAMESPACE}\",pod=~\"${SERVICE_NAME}.*\"}) by (pod) / 1024 / 1024",
          "legendFormat": "{{ pod }}",
          "refId": "A"
        }
      ],
      "title": "Memory Usage (pod)",
      "type": "timeseries"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "custom": {
            "hideFrom": {
              "legend": false,
              "tooltip": false,
              "viz": false
            },
            "scaleDistribution": {
              "type": "linear"
            }
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 24,
        "x": 0,
        "y": 34
      },
      "id": 13,
      "options": {
        "calculate": false,
        "cellGap": 2,
        "cellRadius": 2,
        "color": {
          "exponent": 0.5,
          "fill": "dark-orange",
          "mode": "scheme",
          "reverse": false,
          "scale": "exponential",
          "scheme": "Spectral",
          "steps": 64
        },
        "exemplars": {
          "color": "rgba(255,0,255,0.7)"
        },
        "filterValues": {
          "le": 1e-9
        },
        "legend": {
          "show": true
        },
        "rowsFrame": {
          "layout": "auto"
        },
        "tooltip": {
          "mode": "single",
          "showColorScale": false,
          "yHistogram": false
        },
        "yAxis": {
          "axisPlacement": "left",
          "reverse": false
        }
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "sum(increase(traefik_service_request_duration_seconds_bucket{service=~\"${NAMESPACE}-${SERVICE_NAME}.*\"}[5m])) by (le)",
          "format": "heatmap",
          "legendFormat": "{{ le }}",
          "refId": "A"
        }
      ],
      "title": "Latency Heatmap (P95)",
      "type": "heatmap"
    },
    {
      "datasource": {
        "type": "tempo",
        "uid": "tempo"
      },
      "fieldConfig": {
        "defaults": {},
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 24,
        "x": 0,
        "y": 42
      },
      "id": 14,
      "options": {
        "showSpanFilterMatchesOnly": false,
        "spanFilters": {
          "criticalPathOnly": false,
          "matchesOnly": false,
          "serviceNameOperator": "=",
          "spanNameOperator": "="
        }
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "datasource": {
            "type": "tempo",
            "uid": "tempo"
          },
          "queryType": "traceql",
          "query": "{ resource.service.name=\"${SERVICE_NAME}\" }",
          "limit": 20,
          "refId": "A"
        }
      ],
      "title": "Traces - Service Latency",
      "type": "traces"
    },
    {
      "datasource": "Tempo",
      "fieldConfig": {
        "defaults": {
          "custom": {
            "align": "auto",
            "cellOptions": {
              "type": "auto"
            },
            "inspect": false
          },
          "mappings": [],
          "thresholds": {
            "mode": "absolute",
            "steps": [
              {
                "color": "green",
                "value": null
              }
            ]
          }
        },
        "overrides": []
      },
      "gridPos": {
        "h": 6,
        "w": 24,
        "x": 0,
        "y": 50
      },
      "id": 15,
      "options": {
        "cellHeight": "sm",
        "footer": {
          "countRows": false,
          "fields": "",
          "reducer": [
            "sum"
          ],
          "show": false
        },
        "showHeader": true,
        "sortBy": []
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "datasource": {
            "type": "tempo",
            "uid": "tempo"
          },
          "queryType": "traceql",
          "query": "{ resource.service.name=\"${SERVICE_NAME}\" && status=error }",
          "limit": 20,
          "refId": "A"
        }
      ],
      "title": "Top Root Cause Span Attributes",
      "type": "table"
    },
    {
      "datasource": "Loki",
      "fieldConfig": {
        "defaults": {},
        "overrides": []
      },
      "gridPos": {
        "h": 8,
        "w": 24,
        "x": 0,
        "y": 56
      },
      "id": 16,
      "options": {
        "dedupStrategy": "none",
        "enableInfiniteScrolling": false,
        "enableLogDetails": true,
        "maxLines": 1000,
        "prettifyLogMessage": false,
        "showCommonLabels": false,
        "showLabels": false,
        "showLogLevel": true,
        "showTime": true,
        "sortOrder": 1,
        "wrapLogMessage": false
      },
      "pluginVersion": "11.5.1",
      "targets": [
        {
          "expr": "{service_name=\"${SERVICE_NAME}\"} | json",
          "refId": "A"
        }
      ],
      "title": "Application Logs (Loki) - Service ${SERVICE_NAME}",
      "type": "logs"
    }
  ],
  "preload": false,
  "refresh": "30s",
  "schemaVersion": 40,
  "tags": [
    "${NAMESPACE}",
    "${SERVICE_NAME}"
  ],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "browser",
  "title": "${TITLE}",
  "uid": "${DASHBOARD_UID}",
  "version": 3,
  "weekStart": ""
}