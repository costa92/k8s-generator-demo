/*
Copyright The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
// Code generated by informer-gen. DO NOT EDIT.

package v1

import (
	"context"
	time "time"

	apisv1 "github.com/costa92/k8s-generator-demo/deepcopy-demo/pkg/apis/v1"
	versioned "github.com/costa92/k8s-generator-demo/deepcopy-demo/pkg/clientset/versioned"
	internalinterfaces "github.com/costa92/k8s-generator-demo/deepcopy-demo/pkg/informers/externalversions/internalinterfaces"
	v1 "github.com/costa92/k8s-generator-demo/deepcopy-demo/pkg/listers/apis/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	runtime "k8s.io/apimachinery/pkg/runtime"
	watch "k8s.io/apimachinery/pkg/watch"
	cache "k8s.io/client-go/tools/cache"
)

// NodeCacheInformer provides access to a shared informer and lister for
// NodeCaches.
type NodeCacheInformer interface {
	Informer() cache.SharedIndexInformer
	Lister() v1.NodeCacheLister
}

type nodeCacheInformer struct {
	factory          internalinterfaces.SharedInformerFactory
	tweakListOptions internalinterfaces.TweakListOptionsFunc
	namespace        string
}

// NewNodeCacheInformer constructs a new informer for NodeCache type.
// Always prefer using an informer factory to get a shared informer instead of getting an independent
// one. This reduces memory footprint and number of connections to the server.
func NewNodeCacheInformer(client versioned.Interface, namespace string, resyncPeriod time.Duration, indexers cache.Indexers) cache.SharedIndexInformer {
	return NewFilteredNodeCacheInformer(client, namespace, resyncPeriod, indexers, nil)
}

// NewFilteredNodeCacheInformer constructs a new informer for NodeCache type.
// Always prefer using an informer factory to get a shared informer instead of getting an independent
// one. This reduces memory footprint and number of connections to the server.
func NewFilteredNodeCacheInformer(client versioned.Interface, namespace string, resyncPeriod time.Duration, indexers cache.Indexers, tweakListOptions internalinterfaces.TweakListOptionsFunc) cache.SharedIndexInformer {
	return cache.NewSharedIndexInformer(
		&cache.ListWatch{
			ListFunc: func(options metav1.ListOptions) (runtime.Object, error) {
				if tweakListOptions != nil {
					tweakListOptions(&options)
				}
				return client.ExampleV1().NodeCaches(namespace).List(context.TODO(), options)
			},
			WatchFunc: func(options metav1.ListOptions) (watch.Interface, error) {
				if tweakListOptions != nil {
					tweakListOptions(&options)
				}
				return client.ExampleV1().NodeCaches(namespace).Watch(context.TODO(), options)
			},
		},
		&apisv1.NodeCache{},
		resyncPeriod,
		indexers,
	)
}

func (f *nodeCacheInformer) defaultInformer(client versioned.Interface, resyncPeriod time.Duration) cache.SharedIndexInformer {
	return NewFilteredNodeCacheInformer(client, f.namespace, resyncPeriod, cache.Indexers{cache.NamespaceIndex: cache.MetaNamespaceIndexFunc}, f.tweakListOptions)
}

func (f *nodeCacheInformer) Informer() cache.SharedIndexInformer {
	return f.factory.InformerFor(&apisv1.NodeCache{}, f.defaultInformer)
}

func (f *nodeCacheInformer) Lister() v1.NodeCacheLister {
	return v1.NewNodeCacheLister(f.Informer().GetIndexer())
}
