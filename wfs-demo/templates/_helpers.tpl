{{/*
Expand the name of the chart.
*/}}
{{- define "wfs-demo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Helper to choose the cluster the deployment should run on
*/}}
{{- define "jupyterBaseUrl" -}}
{{- $clusterNameEmptyString := .Values.clusterNameEmptyString }}
{{- if not .Values.clusterNameEmptyString }}
{{- $ConfigMap := (lookup "v1" "ConfigMap" .Release.Namespace "testmap") }}
{{- if $ConfigMap }}
{{- $clusterNameEmptyString = index $ConfigMap.data "cluster"}}
{{- range $key, $value := .Values.clusterName }}
{{- if eq $key  $clusterNameEmptyString }}
{{- if typeOf $value | eq "string" }}
{{- printf "%s" $value }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}



{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wfs-demo.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wfs-demo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "wfs-demo.labels" -}}
helm.sh/chart: {{ include "wfs-demo.chart" . }}
{{ include "wfs-demo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "wfs-demo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wfs-demo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "wfs-demo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "wfs-demo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
