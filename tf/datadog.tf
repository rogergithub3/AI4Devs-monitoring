terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.30.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.${var.datadog_site}"
}

# Monitor de CPU
resource "datadog_monitor" "cpu" {
  name    = "${var.project_name} - Alta utilización de CPU"
  type    = "metric alert"
  message = "CPU alta en {{host.name}} - Valor: {{value}}%\n@slack-alerts"

  query = "avg(last_5m):avg:system.cpu.user{project:${var.project_name}} by {host} > 80"

  monitor_thresholds {
    critical = 80
    warning  = 70
  }

  notify_no_data    = true
  renotify_interval = 60

  tags = ["project:${var.project_name}", "env:${var.environment}"]
}

# Monitor de Memoria
resource "datadog_monitor" "memory" {
  name    = "${var.project_name} - Alta utilización de Memoria"
  type    = "metric alert"
  message = "Memoria alta en {{host.name}} - Valor: {{value}}%\n@slack-alerts"

  query = "avg(last_5m):avg:system.mem.used{project:${var.project_name}} by {host} > 80"

  monitor_thresholds {
    critical = 80
    warning  = 70
  }

  notify_no_data    = true
  renotify_interval = 60

  tags = ["project:${var.project_name}", "env:${var.environment}"]
}

# Monitor de Disco
resource "datadog_monitor" "disk" {
  name    = "${var.project_name} - Alta utilización de Disco"
  type    = "metric alert"
  message = "Uso de disco alto en {{host.name}} - Valor: {{value}}%\n@slack-alerts"

  query = "avg(last_5m):avg:system.disk.in_use{project:${var.project_name}} by {host} > 80"

  monitor_thresholds {
    critical = 80
    warning  = 70
  }

  notify_no_data    = true
  renotify_interval = 60

  tags = ["project:${var.project_name}", "env:${var.environment}"]
}

# Monitor de Network In/Out
resource "datadog_monitor" "network" {
  name    = "${var.project_name} - Alto tráfico de red"
  type    = "metric alert"
  message = "Tráfico de red alto en {{host.name}} - Valor: {{value}} bytes/s\n@slack-alerts"

  query = "avg(last_5m):avg:aws.ec2.network_in{project:${var.project_name}} by {host} > 1000000000"

  monitor_thresholds {
    critical = 1000000000  # 1GB/s
    warning  = 800000000   # 800MB/s
  }

  notify_no_data    = true
  renotify_interval = 60

  tags = ["project:${var.project_name}", "env:${var.environment}"]
}

# Monitor de S3 Bucket Size
resource "datadog_monitor" "s3_size" {
  name    = "${var.project_name} - Tamaño del bucket S3 alto"
  type    = "metric alert"
  message = "Tamaño del bucket S3 ${var.s3_bucket_name} es alto - Valor: {{value}} bytes\n@slack-alerts"

  query = "avg(last_5m):avg:aws.s3.bucket_size_bytes{bucket:${var.s3_bucket_name}} > 5000000000"

  monitor_thresholds {
    critical = 5000000000  # 5GB
    warning  = 4000000000  # 4GB
  }

  notify_no_data    = true
  renotify_interval = 60

  tags = ["project:${var.project_name}", "env:${var.environment}"]
}

# Monitor de S3 Number of Objects
resource "datadog_monitor" "s3_objects" {
  name    = "${var.project_name} - Número de objetos S3 alto"
  type    = "metric alert"
  message = "Número de objetos en el bucket S3 ${var.s3_bucket_name} es alto - Valor: {{value}}\n@slack-alerts"

  query = "avg(last_5m):avg:aws.s3.number_of_objects{bucket:${var.s3_bucket_name}} > 10000"

  monitor_thresholds {
    critical = 10000
    warning  = 8000
  }

  notify_no_data    = true
  renotify_interval = 60

  tags = ["project:${var.project_name}", "env:${var.environment}"]
}

# Dashboard
resource "datadog_dashboard" "main" {
  title       = "${var.project_name} - Dashboard Principal"
  description = "Dashboard de monitorización principal"
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "CPU Usage"
      request {
        q = "avg:system.cpu.user{project:${var.project_name}} by {host}"
        display_type = "line"
      }
      yaxis {
        max = "100"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Memory Usage"
      request {
        q = "avg:system.mem.used{project:${var.project_name}} by {host}"
        display_type = "line"
      }
      yaxis {
        max = "100"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Disk Usage"
      request {
        q = "avg:system.disk.in_use{project:${var.project_name}} by {host}"
        display_type = "line"
      }
      yaxis {
        max = "100"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Network Traffic"
      request {
        q = "avg:aws.ec2.network_in{project:${var.project_name}} by {host}"
        display_type = "line"
      }
      request {
        q = "avg:aws.ec2.network_out{project:${var.project_name}} by {host}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "EC2 Status Check Failed"
      request {
        q = "avg:aws.ec2.status_check_failed{project:${var.project_name}} by {host}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "S3 Bucket Size"
      request {
        q = "avg:aws.s3.bucket_size_bytes{bucket:${var.s3_bucket_name}}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "S3 Number of Objects"
      request {
        q = "avg:aws.s3.number_of_objects{bucket:${var.s3_bucket_name}}"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "S3 Operations"
      request {
        q = "avg:aws.s3.get_requests{bucket:${var.s3_bucket_name}}"
        display_type = "line"
      }
      request {
        q = "avg:aws.s3.put_requests{bucket:${var.s3_bucket_name}}"
        display_type = "line"
      }
    }
  }
} 