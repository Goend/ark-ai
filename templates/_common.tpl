{{/*
获取镜像仓库地址
*/}}
{{- define "model.image.repository" -}}
{{- if eq .Values.modelConfig.current.serviceType "ollama" -}}
{{- .Values.baseConfig.ollama.image.repository -}}
{{- else -}}
{{- .Values.baseConfig.vllm.image.repository -}}
{{- end -}}
{{- end -}}

{{/*
获取服务类型
*/}}
{{- define "model.service.type" -}}
{{- if eq .Values.modelConfig.current.serviceType "ollama" -}}
{{- .Values.baseConfig.ollama.service.type -}}
{{- else -}}
{{- .Values.baseConfig.vllm.service.type -}}
{{- end -}}
{{- end -}}

{{/*
获取完整的镜像名称
*/}}
{{- define "model.image.fullName" -}}
{{- template "model.image.repository" . -}}/{{- .Values.modelConfig.current.serviceType -}}-{{- .Values.modelConfig.current.name -}}:{{- .Values.modelConfig.current.size -}}
{{- end -}} 