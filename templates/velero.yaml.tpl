##
## Configuration settings that directly affect the Velero deployment YAML.
##

# Information about the Kubernetes service account Velero uses.
serviceAccount:
  server:
    create: true
    annotations: 
      eks.amazonaws.com/role-arn: "${eks_service_account}"

podSecurityContext:
  runAsUser: 1000
  fsGroup: 1337

containerSecurityContext:
  capabilities:
    drop: ["NET_RAW"]

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 2048Mi

initContainers:
  - name: velero-plugin-for-aws
    image: velero/velero-plugin-for-aws:v1.9.0
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - mountPath: /target
        name: plugins

# Settings for Velero's prometheus metrics. Disabled by default.
metrics:
  enabled: true
  scrapeInterval: 30s

  # Pod annotations for Prometheus
  podAnnotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8085"
    prometheus.io/path: "/metrics"

  serviceMonitor:
    enabled: true
    additionalLabels: {}

configuration:
  # Parameters for the `default` BackupStorageLocation. See
  # https://velero.io/docs/v1.11/api-types/backupstoragelocation/
  backupStorageLocation:
  - name: default
    provider: aws
    # Bucket to store backups in. Required.
    bucket: cloud-platform-velero-backups
    # Prefix within bucket under which to store backups. Optional.
    prefix: ${cluster_name}
    config:
      region: eu-west-2

  backupSyncPeriod:
  # `velero server` default: 1h
  fsBackupTimeout:
  # `velero server` default: namespaces,persistentvolumes,persistentvolumeclaims,secrets,configmaps,serviceaccounts,limitranges,pods
  restoreResourcePriorities:
  # `velero server` default: false
  restoreOnlyMode:
  # additional key/value pairs to be used as environment variables such as "AWS_CLUSTER_NAME: 'yourcluster.domain.tld'"
  extraEnvVars: {}

rbac:
  create: true

credentials:
  useSecret: false
  existingSecret:
  secretContents:
snapshotsEnabled: false

deployNodeAgent: true

nodeAgent:
  resources:
    requests:
      cpu: "${node_agent_cpu_requests}"
      memory: 512Mi
    limits:
      cpu: 1000m
      memory: 1024Mi
  
# Backup schedules to create.
# Eg:
# schedules:
#   mybackup:
#     schedule: "0 0 * * *"
#     template:
#       ttl: "240h"
#       includedNamespaces:
#        - foo
schedules:
  allnamespacebackup:
    schedule: "0 0/3 * * *"
    template:
      ttl: "720h"

configMaps:
  fs-restore-action-config:
    labels:
      velero.io/plugin-config: ""
      velero.io/pod-volume-restore: RestoreItemAction
    data:
      image: velero/velero-restore-helper:v1.10.2

nodeAgent:
  containerSecurityContext:
    capabilities:
      drop: ["NET_RAW"]