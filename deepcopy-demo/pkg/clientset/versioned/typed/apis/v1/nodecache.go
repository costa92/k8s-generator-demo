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
// Code generated by client-gen. DO NOT EDIT.

package v1

import (
	"context"
	"time"

	v1 "github.com/costa92/k8s-generator-demo/deepcopy-demo/pkg/apis/v1"
	scheme "github.com/costa92/k8s-generator-demo/deepcopy-demo/pkg/clientset/versioned/scheme"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	types "k8s.io/apimachinery/pkg/types"
	watch "k8s.io/apimachinery/pkg/watch"
	rest "k8s.io/client-go/rest"
)

// NodeCachesGetter has a method to return a NodeCacheInterface.
// A group's client should implement this interface.
type NodeCachesGetter interface {
	NodeCaches(namespace string) NodeCacheInterface
}

// NodeCacheInterface has methods to work with NodeCache resources.
type NodeCacheInterface interface {
	Create(ctx context.Context, nodeCache *v1.NodeCache, opts metav1.CreateOptions) (*v1.NodeCache, error)
	Update(ctx context.Context, nodeCache *v1.NodeCache, opts metav1.UpdateOptions) (*v1.NodeCache, error)
	UpdateStatus(ctx context.Context, nodeCache *v1.NodeCache, opts metav1.UpdateOptions) (*v1.NodeCache, error)
	Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error
	DeleteCollection(ctx context.Context, opts metav1.DeleteOptions, listOpts metav1.ListOptions) error
	Get(ctx context.Context, name string, opts metav1.GetOptions) (*v1.NodeCache, error)
	List(ctx context.Context, opts metav1.ListOptions) (*v1.NodeCacheList, error)
	Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error)
	Patch(ctx context.Context, name string, pt types.PatchType, data []byte, opts metav1.PatchOptions, subresources ...string) (result *v1.NodeCache, err error)
	NodeCacheExpansion
}

// nodeCaches implements NodeCacheInterface
type nodeCaches struct {
	client rest.Interface
	ns     string
}

// newNodeCaches returns a NodeCaches
func newNodeCaches(c *InspurV1Client, namespace string) *nodeCaches {
	return &nodeCaches{
		client: c.RESTClient(),
		ns:     namespace,
	}
}

// Get takes name of the nodeCache, and returns the corresponding nodeCache object, and an error if there is any.
func (c *nodeCaches) Get(ctx context.Context, name string, options metav1.GetOptions) (result *v1.NodeCache, err error) {
	result = &v1.NodeCache{}
	err = c.client.Get().
		Namespace(c.ns).
		Resource("nodecaches").
		Name(name).
		VersionedParams(&options, scheme.ParameterCodec).
		Do(ctx).
		Into(result)
	return
}

// List takes label and field selectors, and returns the list of NodeCaches that match those selectors.
func (c *nodeCaches) List(ctx context.Context, opts metav1.ListOptions) (result *v1.NodeCacheList, err error) {
	var timeout time.Duration
	if opts.TimeoutSeconds != nil {
		timeout = time.Duration(*opts.TimeoutSeconds) * time.Second
	}
	result = &v1.NodeCacheList{}
	err = c.client.Get().
		Namespace(c.ns).
		Resource("nodecaches").
		VersionedParams(&opts, scheme.ParameterCodec).
		Timeout(timeout).
		Do(ctx).
		Into(result)
	return
}

// Watch returns a watch.Interface that watches the requested nodeCaches.
func (c *nodeCaches) Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error) {
	var timeout time.Duration
	if opts.TimeoutSeconds != nil {
		timeout = time.Duration(*opts.TimeoutSeconds) * time.Second
	}
	opts.Watch = true
	return c.client.Get().
		Namespace(c.ns).
		Resource("nodecaches").
		VersionedParams(&opts, scheme.ParameterCodec).
		Timeout(timeout).
		Watch(ctx)
}

// Create takes the representation of a nodeCache and creates it.  Returns the server's representation of the nodeCache, and an error, if there is any.
func (c *nodeCaches) Create(ctx context.Context, nodeCache *v1.NodeCache, opts metav1.CreateOptions) (result *v1.NodeCache, err error) {
	result = &v1.NodeCache{}
	err = c.client.Post().
		Namespace(c.ns).
		Resource("nodecaches").
		VersionedParams(&opts, scheme.ParameterCodec).
		Body(nodeCache).
		Do(ctx).
		Into(result)
	return
}

// Update takes the representation of a nodeCache and updates it. Returns the server's representation of the nodeCache, and an error, if there is any.
func (c *nodeCaches) Update(ctx context.Context, nodeCache *v1.NodeCache, opts metav1.UpdateOptions) (result *v1.NodeCache, err error) {
	result = &v1.NodeCache{}
	err = c.client.Put().
		Namespace(c.ns).
		Resource("nodecaches").
		Name(nodeCache.Name).
		VersionedParams(&opts, scheme.ParameterCodec).
		Body(nodeCache).
		Do(ctx).
		Into(result)
	return
}

// UpdateStatus was generated because the type contains a Status member.
// Add a +genclient:noStatus comment above the type to avoid generating UpdateStatus().
func (c *nodeCaches) UpdateStatus(ctx context.Context, nodeCache *v1.NodeCache, opts metav1.UpdateOptions) (result *v1.NodeCache, err error) {
	result = &v1.NodeCache{}
	err = c.client.Put().
		Namespace(c.ns).
		Resource("nodecaches").
		Name(nodeCache.Name).
		SubResource("status").
		VersionedParams(&opts, scheme.ParameterCodec).
		Body(nodeCache).
		Do(ctx).
		Into(result)
	return
}

// Delete takes name of the nodeCache and deletes it. Returns an error if one occurs.
func (c *nodeCaches) Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error {
	return c.client.Delete().
		Namespace(c.ns).
		Resource("nodecaches").
		Name(name).
		Body(&opts).
		Do(ctx).
		Error()
}

// DeleteCollection deletes a collection of objects.
func (c *nodeCaches) DeleteCollection(ctx context.Context, opts metav1.DeleteOptions, listOpts metav1.ListOptions) error {
	var timeout time.Duration
	if listOpts.TimeoutSeconds != nil {
		timeout = time.Duration(*listOpts.TimeoutSeconds) * time.Second
	}
	return c.client.Delete().
		Namespace(c.ns).
		Resource("nodecaches").
		VersionedParams(&listOpts, scheme.ParameterCodec).
		Timeout(timeout).
		Body(&opts).
		Do(ctx).
		Error()
}

// Patch applies the patch and returns the patched nodeCache.
func (c *nodeCaches) Patch(ctx context.Context, name string, pt types.PatchType, data []byte, opts metav1.PatchOptions, subresources ...string) (result *v1.NodeCache, err error) {
	result = &v1.NodeCache{}
	err = c.client.Patch(pt).
		Namespace(c.ns).
		Resource("nodecaches").
		Name(name).
		SubResource(subresources...).
		VersionedParams(&opts, scheme.ParameterCodec).
		Body(data).
		Do(ctx).
		Into(result)
	return
}
