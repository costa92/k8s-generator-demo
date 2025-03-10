# Kubernetes 代码生成器演示

这个项目演示了如何使用 Kubernetes 代码生成器来创建自定义资源(CRDs)并生成与这些资源交互所需的客户端代码。

## 概述

code-generator-demo 项目展示了如何：

1. 使用 Go 结构体定义自定义 Kubernetes 资源
2. 使用 Kubernetes 代码生成器生成客户端库、informers 和 listers
3. 创建并部署自定义资源定义(CRDs)到 Kubernetes 集群
4. 使用生成的客户端代码与自定义资源交互

## 项目结构

```sh
code-generator-demo/
├── cmd/
│   └── main.go                  # 应用程序入口点
├── config/
│   ├── crds/                    # 生成的 CRD YAML 文件
│   └── example/                 # 自定义资源实例示例
├── hack/                        # 代码生成脚本
├── pkg/
│   ├── apis/                    # 自定义 API 定义
│   │   └── appcontroller/       # API 组
│   │       ├── register.go      # API 组注册
│   │       └── v1alpha1/        # API 版本
│   │           ├── doc.go       # 代码生成标签
│   │           ├── register.go  # 类型注册
│   │           └── types.go     # 自定义资源类型定义
│   └── generated/               # 自动生成的客户端代码
├── go.mod                       # Go 模块定义
├── go.sum                       # Go 模块校验和
├── Makefile                     # 构建自动化
└── README.md                    # 本文件
```

## 自定义资源

本项目在 `appcontroller.k8s.io` API 组中定义了一个 `Application` 自定义资源：

```go
type Application struct {
    metav1.TypeMeta   `json:",inline"`
    metav1.ObjectMeta `json:"metadata,omitempty"`
    Spec              ApplicationSpec   `json:"spec,omitempty"`
    Status            ApplicationStatus `json:"status,omitempty"`
}

type ApplicationSpec struct {
    DeploymentName string `json:"deploymentName"`
    Replicas       *int32 `json:"replicas"`
}

type ApplicationStatus struct {
    AvailableReplicas int32 `json:"availableReplicas"`
}
```

## 前提条件

- Go 1.22 或更高版本
- 可访问的 Kubernetes 集群
- 配置好与集群通信的 kubectl
- controller-gen（通过 make 命令安装）

## 快速开始

### 安装

1. 克隆仓库：
  
   ```bash
   git clone https://github.com/costa92/k8s-generator-demo.git
   cd code-generator-demo
   ```

2. 生成客户端代码和 CRDs：

   ```bash
   make controller-gen
   ```

### 部署到 Kubernetes

1. 将 CRD 应用到集群：
   
   ```bash
   make k8s-deploy
   ```

2. 验证 CRD 已安装：
   
   ```bash
   kubectl get crds | grep applications.appcontroller.k8s.io
   ```

3. 创建示例 Application 资源：
   
   ```bash
   kubectl apply -f config/example/test_app.yaml
   ```

4. 列出 Application 资源：
   
   ```bash
   kubectl get applications
   ```

### 运行演示应用

演示应用展示了如何使用生成的客户端代码与自定义资源交互：

```bash
make all
```

这将运行 main.go 程序，列出默认命名空间中的所有 Application 资源。

## 可用的 Make 命令

- `make all`：运行演示应用
- `make clean`：删除生成的代码
- `make controller-gen`：生成 CRDs 和 DeepCopy 方法
- `make k8s-deploy`：将 CRDs 和示例资源部署到 Kubernetes
- `make k8s-delete`：从 Kubernetes 中删除 CRDs 和示例资源
- `make type-scaffold`：为新类型生成类型脚手架

注意: 运行 `make k8s-deploy`

错误：

```sh
The CustomResourceDefinition "applications.appcontroller.k8s.io" is invalid: metadata.annotations[api-approved.kubernetes.io]: Required value: protected groups must have approval annotation "api-approved.kubernetes.io", see https://github.com/kubernetes/enhancements/pull/1111

```

解决：报错中已经给了提示，查看github：https://github.com/kubernetes/enhancements/pull/1111
只需要在crd中，添加一条 annotation，然后再执行 kubectl apply -f 命令就可以了

```sh
metadata:
  annotations:
    api-approved.kubernetes.io: "https://github.com/kubernetes/kubernetes/pull/78458"
```

## 工作原理

1. 自定义资源类型在 `pkg/apis/appcontroller/v1alpha1/types.go` 中定义
2. doc.go 和 register.go 文件中的代码生成标签指导代码生成器
3. controller-gen 工具生成：
   - 类型的 DeepCopy 方法
   - config/crds 目录中的 CRD YAML 文件
4. pkg/generated 中生成的客户端代码允许以编程方式与自定义资源交互

## 参考资料

- [Kubernetes 代码生成器](https://github.com/kubernetes/code-generator)
- [Kubernetes 自定义资源](https://kubernetes.io/zh/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
- [Controller Runtime](https://github.com/kubernetes-sigs/controller-runtime)

## 许可证

本项目采用 MIT 许可证 - 详情请参阅 LICENSE 文件。