
.PHONY: all
all:
	go run cmd/main.go

.PHONY: clean
clean:
	rm -rf pkg/generated


#  paths=./... 表示将当前目录下的所有子目录都包括在生成过程中
# output:crd:dir=config/crd 指定了输出目录为 config/crd
.PHONY: controller-gen
controller-gen:
	@which controller-gen > /dev/null || go install sigs.k8s.io/controller-tools/cmd/controller-gen@latest
	controller-gen crd paths=./... output:crd:dir=config/crds 
	controller-gen object paths=./...


.PHONY: k8s-deploy
k8s-deploy:
	kubectl apply -f config/crds/appcontroller.k8s.io_applications.yaml 
	kubectl apply -f config/example/test_app.yaml

.PHONY: k8s-delete
k8s-delete:
	kubectl delete -f config/example/test_app.yaml
	kubectl delete -f config/crds/appcontroller.k8s.io_applications.yaml





.PHONY: type-scaffold
type-scaffold:
	@which type-scaffold > /dev/null || go install k8s.io/code-generator/cmd/type-scaffold@latest
	type-scaffold --kind=Application 