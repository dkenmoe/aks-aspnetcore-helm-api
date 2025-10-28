{{/*
    Expand the name of the chart.
    */}}
    {{- define "myapi.name" -}}
    {{- default .Chart.Name .Values.name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
    
    {{/*
    Create a default fully qualified app name.
    We truncate at 63 chars because of K8s name limits.
    */}}
    {{- define "myapi.fullname" -}}
    {{- if .Values.fullnameOverride -}}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
    {{- $name := default .Chart.Name .Values.name -}}
    {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
    {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
    {{- end -}}
    {{- end -}}