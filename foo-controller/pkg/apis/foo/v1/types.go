package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

const (
	GroupName string = "foo.example.com"
	Kind      string = "Foo"
	Version   string = "v1"
	Plural    string = "foos"
	Singluar  string = "foo"
	ShortName string = "foo"
	Name      string = Plural + "." + GroupName
)

// +genclient
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

type Foo struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
	Status            FooStatus `json:"status"`
	Spec              FooSpec   `json:"spec"`
}

type FooSpec struct {
	Replicas       *int32 `json:"replicas"`
	DeploymentName string `json:"deploymentName"`
}

// FooStatus is the status for a Foo resource
type FooStatus struct {
	AvailableReplicas int32 `json:"availableReplicas"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object

type FooList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata"`

	Items []Foo `json:"items"`
}
