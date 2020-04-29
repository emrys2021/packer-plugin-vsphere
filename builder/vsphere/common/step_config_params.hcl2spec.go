// Code generated by "mapstructure-to-hcl2 -type ConfigParamsConfig"; DO NOT EDIT.
package common

import (
	"github.com/hashicorp/hcl/v2/hcldec"
	"github.com/zclconf/go-cty/cty"
)

// FlatConfigParamsConfig is an auto-generated flat version of ConfigParamsConfig.
// Where the contents of a field with a `mapstructure:,squash` tag are bubbled up.
type FlatConfigParamsConfig struct {
	ConfigParams map[string]string `mapstructure:"configuration_parameters" cty:"configuration_parameters"`
}

// FlatMapstructure returns a new FlatConfigParamsConfig.
// FlatConfigParamsConfig is an auto-generated flat version of ConfigParamsConfig.
// Where the contents a fields with a `mapstructure:,squash` tag are bubbled up.
func (*ConfigParamsConfig) FlatMapstructure() interface{ HCL2Spec() map[string]hcldec.Spec } {
	return new(FlatConfigParamsConfig)
}

// HCL2Spec returns the hcl spec of a ConfigParamsConfig.
// This spec is used by HCL to read the fields of ConfigParamsConfig.
// The decoded values from this spec will then be applied to a FlatConfigParamsConfig.
func (*FlatConfigParamsConfig) HCL2Spec() map[string]hcldec.Spec {
	s := map[string]hcldec.Spec{
		"configuration_parameters": &hcldec.AttrSpec{Name: "configuration_parameters", Type: cty.Map(cty.String), Required: false},
	}
	return s
}