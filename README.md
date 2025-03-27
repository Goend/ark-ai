# 模型部署 Helm Chart

这个 Helm chart 用于在 Kubernetes 集群中部署 Ollama 和 vLLM 模型服务。

## 前置条件

- Kubernetes 1.19+
- Helm 3.0+
- NVIDIA GPU 驱动和 CUDA
- 配置好的 `nvidia` RuntimeClass
- Nginx Ingress Controller（如果使用 Ingress）

## 安装

```bash
# 使用本地chart目录安装
helm install model-deployment ./model-deployment

# 或指定values文件
helm install model-deployment ./model-deployment -f custom-values.yaml
```

## 配置

可以通过修改 `values.yaml` 文件来自定义配置：

### 基础配置(默认参数一般不修改)

```yaml
baseConfig:
  ollama:
    enabled: true
    containerPort: 11434    # Ollama 容器端口
    image:
      repository: hub.ecns.io/ai
    service:
      type: ClusterIP
  vllm:
    enabled: true
    containerPort: 8000     # vLLM 容器端口
    image:
      repository: hub.ecns.io/ai
    service:
      type: ClusterIP
```

### 模型配置（提供给用户的修改入口）

```yaml
modelConfig:
  current:
    name: "qwen2.5"    # 模型名称
    size: "7b"          # 模型大小
    serviceType: "ollama"     # 推理服务类型：ollama/vllm
    servicePort: 11435        # 服务端口（Service 端口）
    resources:
      requests:
        cpu: "4"
        memory: "16Gi"
        nvidia.com/gpu: "1"
      limits:
        cpu: "8"
        memory: "32Gi"
        nvidia.com/gpu: "1"
```

## 使用

### 通过 Ingress 访问

当启用 Ingress 后，可以通过以下域名访问服务：

#### Ollama API 端点
- 生成文本：`https://ai.<release_name>.io/api/generate`

示例请求：
```bash
curl https://ai.<release_name>.io/api/generate -d '{
  "model": "qwen2.5:<model size>",
  "prompt": "Hello, how are you?"
}'
```

#### vLLM API 端点
- 聊天补全：`https://ai.<release_name>.io/vllm/v1/chat/completions`

示例请求：
```bash
curl https://ai.<release_name>.io/vllm/v1/chat/completions -H "Content-Type: application/json" -d '{
  "messages": [{"role": "user", "content": "Hello, how are you?"}],
  "max_tokens": 100
}'
```

### 直接访问 Service

#### Ollama API

当 `serviceType: "ollama"` 时，可以使用以下命令访问：

```bash
curl http://<ollama svc ip>:11435/api/generate -d '{
  "model": "qwen2.5:<model size>",
  "prompt": "Hello, how are you?"
}'
```

#### vLLM API

当 `serviceType: "vllm"` 时，可以使用以下命令访问：

```bash
curl http://model-deployment-vllm:11435/v1/chat/completions -H "Content-Type: application/json" -d '{
  "messages": [{"role": "user", "content": "Hello, how are you?"}],
  "max_tokens": 100
}'
```

## 卸载

```bash
helm uninstall model-deployment
``` 