##
## Configuration settings that directly affect the Velero deployment YAML.
##

# Details of the container image to use in the Velero deployment & daemonset (if
# enabling restic). Required.
# image:
#   repository: gcr.io/heptio-images/velero
#   tag: v1.1.0
#   pullPolicy: IfNotPresent

%{ if eks == false ~}
podAnnotations:
  iam.amazonaws.com/role: ${velero_iam_role}
%{ endif ~}

%{ if eks ~}
serviceAccount:
  server:
    create: true
    annotations: 
      eks.amazonaws.com/role-arn: "${eks_service_account}"
securityContext:
  fsGroup: 1337
%{ endif ~}

initContainers:
  - name: velero-plugin-for-aws
    image: velero/velero-plugin-for-aws:v1.0.1
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

# # Information about the Kubernetes service account Velero uses.
# serviceAccount:
#   server:
#     create: true
#     name:

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


