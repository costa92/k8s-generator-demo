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

package fake

import (
	"context"

	v1 "github.com/costa92/k8s-generator-demo/deepcopy-demo/pkg/apis/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	labels "k8s.io/apimachinery/pkg/labels"
	types "k8s.io/apimachinery/pkg/types"
	watch "k8s.io/apimachinery/pkg/watch"
	testing "k8s.io/client-go/testing"
)

// FakeNodeCaches implements NodeCacheInterface
type FakeNodeCaches struct {
	Fake *FakeNodecachesV1
	ns   string
}

var nodecachesResource = v1.SchemeGroupVersion.WithResource("nodecaches")

var nodecachesKind = v1.SchemeGroupVersion.WithKind("NodeCache")

// Get takes name of the nodeCache, and returns the corresponding nodeCache object, and an error if there is any.
func (c *FakeNodeCaches) Get(ctx context.Context, name string, options metav1.GetOptions) (result *v1.NodeCache, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewGetAction(nodecachesResource, c.ns, name), &v1.NodeCache{})

	if obj == nil {
		return nil, err
	}
	return obj.(*v1.NodeCache), err
}

// List takes label and field selectors, and returns the list of NodeCaches that match those selectors.
func (c *FakeNodeCaches) List(ctx context.Context, opts metav1.ListOptions) (result *v1.NodeCacheList, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewListAction(nodecachesResource, nodecachesKind, c.ns, opts), &v1.NodeCacheList{})

	if obj == nil {
		return nil, err
	}

	label, _, _ := testing.ExtractFromListOptions(opts)
	if label == nil {
		label = labels.Everything()
	}
	list := &v1.NodeCacheList{ListMeta: obj.(*v1.NodeCacheList).ListMeta}
	for _, item := range obj.(*v1.NodeCacheList).Items {
		if label.Matches(labels.Set(item.Labels)) {
			list.Items = append(list.Items, item)
		}
	}
	return list, err
}

// Watch returns a watch.Interface that watches the requested nodeCaches.
func (c *FakeNodeCaches) Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error) {
	return c.Fake.
		InvokesWatch(testing.NewWatchAction(nodecachesResource, c.ns, opts))

}

// Create takes the representation of a nodeCache and creates it.  Returns the server's representation of the nodeCache, and an error, if there is any.
func (c *FakeNodeCaches) Create(ctx context.Context, nodeCache *v1.NodeCache, opts metav1.CreateOptions) (result *v1.NodeCache, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewCreateAction(nodecachesResource, c.ns, nodeCache), &v1.NodeCache{})

	if obj == nil {
		return nil, err
	}
	return obj.(*v1.NodeCache), err
}

// Update takes the representation of a nodeCache and updates it. Returns the server's representation of the nodeCache, and an error, if there is any.
func (c *FakeNodeCaches) Update(ctx context.Context, nodeCache *v1.NodeCache, opts metav1.UpdateOptions) (result *v1.NodeCache, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewUpdateAction(nodecachesResource, c.ns, nodeCache), &v1.NodeCache{})

	if obj == nil {
		return nil, err
	}
	return obj.(*v1.NodeCache), err
}

// UpdateStatus was generated because the type contains a Status member.
// Add a +genclient:noStatus comment above the type to avoid generating UpdateStatus().
func (c *FakeNodeCaches) UpdateStatus(ctx context.Context, nodeCache *v1.NodeCache, opts metav1.UpdateOptions) (*v1.NodeCache, error) {
	obj, err := c.Fake.
		Invokes(testing.NewUpdateSubresourceAction(nodecachesResource, "status", c.ns, nodeCache), &v1.NodeCache{})

	if obj == nil {
		return nil, err
	}
	return obj.(*v1.NodeCache), err
}

// Delete takes name of the nodeCache and deletes it. Returns an error if one occurs.
func (c *FakeNodeCaches) Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error {
	_, err := c.Fake.
		Invokes(testing.NewDeleteActionWithOptions(nodecachesResource, c.ns, name, opts), &v1.NodeCache{})

	return err
}

// DeleteCollection deletes a collection of objects.
func (c *FakeNodeCaches) DeleteCollection(ctx context.Context, opts metav1.DeleteOptions, listOpts metav1.ListOptions) error {
	action := testing.NewDeleteCollectionAction(nodecachesResource, c.ns, listOpts)

	_, err := c.Fake.Invokes(action, &v1.NodeCacheList{})
	return err
}

// Patch applies the patch and returns the patched nodeCache.
func (c *FakeNodeCaches) Patch(ctx context.Context, name string, pt types.PatchType, data []byte, opts metav1.PatchOptions, subresources ...string) (result *v1.NodeCache, err error) {
	obj, err := c.Fake.
		Invokes(testing.NewPatchSubresourceAction(nodecachesResource, c.ns, name, pt, data, subresources...), &v1.NodeCache{})

	if obj == nil {
		return nil, err
	}
	return obj.(*v1.NodeCache), err
}
