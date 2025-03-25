# Ollama 和 vLLM Helm Chart

这个 Helm chart 用于在 Kubernetes 集群中部署 Ollama 和 vLLM 服务。

## 前置条件

- Kubernetes 1.19+
- Helm 3.0+
- NVIDIA GPU 驱动和 CUDA（用于 vLLM）

## 安装

```bash
# 添加仓库
helm repo add ollama-vllm https://your-repo-url

# 安装 chart
helm install ollama-vllm ollama-vllm/ollama-vllm
```

## 配置

可以通过修改 `values.yaml` 文件来自定义配置：

### Ollama 配置

- 启用/禁用 Ollama 服务
- 配置资源限制
- 设置要下载的模型
- 配置存储大小

### vLLM 配置

- 启用/禁用 vLLM 服务
- 配置 GPU 资源
- 设置模型参数
- 配置存储大小

## 使用

### Ollama API

Ollama 服务将在端口 11434(默认) 上可用。可以使用以下命令访问：

```bash
curl http://ollama-service:11434/api/generate -d '{
  "model": "llama2",
  "prompt": "Hello, how are you?"
}'
```

### vLLM API

vLLM 服务将在端口 8000(默认) 上可用。可以使用以下命令访问：

```bash
curl http://vllm-service:8000/v1/chat/completions -H "Content-Type: application/json" -d '{
  "model": "meta-llama/Llama-2-7b-chat-hf",
  "messages": [{"role": "user", "content": "Hello, how are you?"}]
}'
```

## 卸载

```bash
helm uninstall ollama-vllm
``` 