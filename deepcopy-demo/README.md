# deepcopy-demo

This is a demo of how to use the `k8s.io/code-generator` to generate deep copy functions for custom types.

##  准备
    
* golang 1.22+ 
* ks8 环境 （Kind, minikube ）
  
## 执行生成代码工具

* controller-gen
* type-scaffold

```sh
  ./hack/install_tools.sh  install::controller-tools
```


## 生成代码

1. go代码

* 使用type-scaffold工具生成types.go文件
```shell
    ./hack/gen-type.sh
```
 在去pkg/apis/v1/types.go文件中修改 NodeCacheSpec 结构体内容

* 使用controller-gen生成deepcopy.go文件    

```sh
   ./hack/verify-codegen
```
 

2. 生成 crd
    
    ```sh
    ./hack/gen-crd.sh
    ```
    
       
 ##  kubernetes集群中应用CRD

1. kubectl apply crd 资源
    
    ```sh
    kubectl apply -f manifests/crd/nodecaches.example.com_nodecaches.yaml
    ```
2. kubectl apply controller 资源
    
    ```sh
    kubectl apply -f manifests/test_apply.yaml
    ```

3. kubectl get nodecache
    
    ```sh
    kubectl get nodecache
    ```
   
## 运行代码
    
```sh
  go run main.go
```
输出结果：

```sh
&{{ } {example-nodecache  default  e76fd09c-bc75-4349-89bb-2640d6469852 8835 1 2024-06-14 16:32:46 +0800 CST <nil> <nil> map[] map[kubectl.kubernetes.io/last-applied-configuration:{"apiVersion":"nodecaches.example.com/v1","kind":"NodeCache","metadata":{"annotations":{},"name":"example-nodecache","namespace":"default"},"spec":{"allocatablesize":100,"datasets":"dataset1","freesize":50}}
] [] [] [{kubectl-client-side-apply Update nodecaches.example.com/v1 2024-06-14 16:32:46 +0800 CST FieldsV1 {"f:metadata":{"f:annotations":{".":{},"f:kubectl.kubernetes.io/last-applied-configuration":{}}},"f:spec":{".":{},"f:allocatablesize":{},"f:datasets":{},"f:freesize":{}}} }]} {dataset1 50 100} {0 0 0}}

```

## 删除资源

```sh
k delete -f manifests/test_app.yaml  -f manifests/crd/nodecaches.example.com_nodecaches.yaml 
```

## 参考
[Kubernetes operator（四）controller-tools 篇](https://blog.csdn.net/a1369760658/article/details/135932302)