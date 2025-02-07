apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{.Name}}
  namespace: {{.Namespace}}
  labels:
    app: {{.Name}}
spec:
  replicas: {{.Replicas}}
  revisionHistoryLimit: {{.Revisions}}
  selector:
    matchLabels:
      app: {{.Name}}
  template:
    metadata:
      labels:
        app: {{.Name}}
    spec:{{if .ServiceAccount}}
      serviceAccountName: {{.ServiceAccount}}{{end}}
      initContainers:
      - name: init-coredump
        image: {{.Image}}
        command: ['sh', '-c', "sysctl -w kernel.core_pattern=/tmp/cores/core.%e.%p.%t"]
        securityContext:
            privileged: true
      containers:
      - name: {{.Name}}
        image: {{.Image}}
        securityContext:
            privileged: true
        env:
          - name: GOTRACEBACK
            value: crash
          - name: MYSQL_PASSWORD
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: mysql-password
                optional: true
          - name: REDIS_PASSWORD
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: redis-password
                optional: true
          - name: JWT_ACCESS_SECRET
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: jwt-access-secret
                optional: true
          - name: JWT_ADMIN_ACCESS_SECRET
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: jwt-admin-access-secret
                optional: true
          - name: TX_COS_SECRETKEY
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: tx-cos-secretkey
                optional: true
          - name: TX_LOG_SECRETKEY
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: tx-log-secretkey
                optional: true
          - name: STOREKIT_SECRETKEY
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: storekit-secretkey
                optional: true
          - name: PULSAR_AUTH_TOKEN
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: pulsar-auth-token
                optional: true
          - name: QINIU_ACCESS_KEY
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: qiniu-access-key
                optional: true
          - name: QINIU_SECRETKEY
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: qiniu-secretkey
                optional: true
          - name: PUSHKIT_SECRETKEY
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: pushKit-secretkey
                optional: true
          - name: TX_CLOUD_BASE_SECRET_ID
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: tx_cloud_base_secret_id
                optional: true
          - name: TX_CLOUD_BASE_SECRET_KEY
            valueFrom:
              secretKeyRef:
                name: moodji-secret
                key: tx_cloud_base_secret_key
                optional: true
        {{if .ImagePullPolicy}}imagePullPolicy: {{.ImagePullPolicy}}
        {{end}}ports:
        - containerPort: {{.Port}}
        readinessProbe:
          tcpSocket:
            port: {{.Port}}
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          tcpSocket:
            port: {{.Port}}
          initialDelaySeconds: 15
          periodSeconds: 20
        resources:
          requests:
            cpu: {{.RequestCpu}}m
            memory: {{.RequestMem}}Mi
          limits:
            cpu: {{.LimitCpu}}m
            memory: {{.LimitMem}}Mi
        volumeMounts:
        - mountPath: /tmp/cores
          name: core-path
        - name: timezone
          mountPath: /etc/localtime
        - name: kubeconfig-dev
          mountPath: /app/kubeconfig-dev
          readOnly: true
        - name: kubeconfig-pre
          mountPath: /app/kubeconfig-pre
          readOnly: true
        - name: kubeconfig-prod
          mountPath: /app/kubeconfig-prod
          readOnly: true
      {{if .Secret}}imagePullSecrets:
      - name: {{.Secret}}
      {{end}}volumes:
        - name: core-path
          hostPath:
            path: /home/ubuntu/crash-info
        - name: timezone
          hostPath:
            path: /usr/share/zoneinfo/Asia/Shanghai
        - name: kubeconfig-dev
          secret:
            secretName: kubeconfig-dev
        - name: kubeconfig-pre
          secret:
            secretName: kubeconfig-pre
        - name: kubeconfig-prod
          secret:
            secretName: kubeconfig-prod

---

apiVersion: v1
kind: Service
metadata:
  name: {{.Name}}-svc
  namespace: {{.Namespace}}
spec:
  ports:
  {{if .UseNodePort}}- nodePort: {{.NodePort}}
    port: {{.Port}}
    protocol: TCP
    targetPort: {{.TargetPort}}
  type: NodePort{{else}}- port: {{.Port}}
    targetPort: {{.TargetPort}}{{end}}
  selector:
    app: {{.Name}}

---

apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{.Name}}-hpa-c
  namespace: {{.Namespace}}
  labels:
    app: {{.Name}}-hpa-c
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{.Name}}
  minReplicas: {{.MinReplicas}}
  maxReplicas: {{.MaxReplicas}}
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 80

---

apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{.Name}}-hpa-m
  namespace: {{.Namespace}}
  labels:
    app: {{.Name}}-hpa-m
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{.Name}}
  minReplicas: {{.MinReplicas}}
  maxReplicas: {{.MaxReplicas}}
  metrics:
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
