Name: {{.serviceName}}-rpc
ListenOn: 0.0.0.0:${{"{"}}{{.serviceName}}-rpc-port{{"}"}}
Mode: ${env-mode}

Log:
  ServiceName: {{.serviceName}}-rpc
  Level: ${log-level}
  