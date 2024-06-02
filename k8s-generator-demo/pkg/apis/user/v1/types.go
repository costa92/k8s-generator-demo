package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
)

// 生成客户端相关 client informer lister 以及 applyconfiguration
//  func (in *Foo) DeepCopyObject() runtime.Object (实现 interface k8s.io/apimachinery/pkg/runtime.Object

// +genclient
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

// Foo is a struct that represents a foo object
type Foo struct {
	metav1.TypeMeta   `json:",inline"` // TypeMeta is the metadata for the resource, like kind and apiversion
	metav1.ObjectMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`

	Spec FooSpec `json:"spec" protobuf:"bytes,2,opt,name=spec"`
}

// DeepCopyObject implements runtime.Object.
func (f *Foo) DeepCopyObject() runtime.Object {
	panic("unimplemented")
}

// GetObjectKind implements runtime.Object.
// Subtle: this method shadows the method (TypeMeta).GetObjectKind of Foo.TypeMeta.
func (f *Foo) GetObjectKind() schema.ObjectKind {
	panic("unimplemented")
}

type FooSpec struct {
	// Msg says hello world!
	Msg string `json:"msg" protobuf:"bytes,1,opt,name=msg"`
	// Msg1 provides some verbose information
	// +optional
	Msg1 string `json:"msg1" protobuf:"bytes,2,opt,name=msg1"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
type FooList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty" protobuf:"bytes,1,opt,name=metadata"`
	Items           []Foo `json:"items" protobuf:"bytes,2,rep,name=items"`
}

// DeepCopyObject implements runtime.Object.
func (f *FooList) DeepCopyObject() runtime.Object {
	panic("unimplemented")
}

// GetObjectKind implements runtime.Object.
// Subtle: this method shadows the method (TypeMeta).GetObjectKind of FooList.TypeMeta.
func (f *FooList) GetObjectKind() schema.ObjectKind {
	panic("unimplemented")
}
