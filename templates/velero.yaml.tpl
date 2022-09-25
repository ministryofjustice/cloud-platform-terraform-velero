##
## Configuration settings that directly affect the Velero deployment YAML.
##

# Information about the Kubernetes service account Velero uses.

serviceAccount:
  server:
    create: true
    annotations: 
      eks.amazonaws.com/role-arn: "${eks_service_account}"
securityContext:
  fsGroup: 1337

resources:
  requests:
    cpu: 500m
    memory: 256Mi
  limits:
    cpu: 1000m
    memory: 1024Mi

initContainers:
  - name: velero-plugin-for-csi
    image: velero/velero-plugin-for-csi:v0.3.0
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - mountPath: /target
        name: plugins
  - name: velero-plugin-for-aws
    image: velero/velero-plugin-for-aws:v1.5.0
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
  provider: aws

  # Parameters for the `default` BackupStorageLocation. See
  # https://velero.io/docs/v1.0.0/api-types/backupstoragelocation/
  backupStorageLocation:
    name: default
  
    # Bucket to store backups in. Required.
    bucket: cloud-platform-velero-backups
    # Prefix within bucket under which to store backups. Optional.
    prefix: ${cluster_name}
    config:
      region: eu-west-2
    #  s3ForcePathStyle:
    #  s3Url:
    #  kmsKeyId:
    #  resourceGroup:
    #  storageAccount:
    #  publicUrl:

  volumeSnapshotLocation:
    name: default
    config:
      region: eu-west-2
  #    apitimeout:
  #    resourceGroup:
  #    snapshotLocation:
  #    project:

  backupSyncPeriod:
  # `velero server` default: 1h
  resticTimeout:
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
snapshotsEnabled: true

deployRestic: false

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

configMaps: {}
