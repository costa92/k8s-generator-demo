package main

import (
	"context"
	"fmt"
	"github.com/costa92/k8s-generator-demo/deepcopy-demo/pkg/generated/clientset/versioned"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/tools/clientcmd"
	"log"
)

func main() {
	config, err := clientcmd.BuildConfigFromFlags("", clientcmd.RecommendedHomeFile)
	if err != nil {
		log.Fatalln(err)
	}
	// 创建 clientset
	clientset, err := versioned.NewForConfig(config)
	if err != nil {
		log.Fatalln(err)
	}

	nodecode, err := clientset.NodecachesV1().NodeCaches("default").Get(context.TODO(), "example-nodecache", metav1.GetOptions{})
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(nodecode)
}
