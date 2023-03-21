package tests

import (
	"os"
	"path"
	"testing"

	"github.com/defdevio/terratest-helpers/pkg/helpers"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

var (
	subscriptionID = os.Getenv("ARM_SUBSCRIPTION_ID")
	workDir, _     = os.Getwd()
)

// The variables to pass in to the Terraform runs
func terraformVars() map[string]any {
	testVars := map[string]any{
		"environment":         "test",
		"location":            "westus",
		"resource_count":      0,
		"resource_group_name": "test",
		"create_law":          true,
	}

	return testVars
}

func TestCreateLogAnalyticsWorkspace(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "",
		Vars:         terraformVars(),
	})

	testFiles := []string{
		"provider.tf",
		"terraform.tfstate",
		"terraform.tfstate.backup",
		".terraform.lock.hcl",
		".terraform",
		".kube",
		"config",
	}

	// Defer cleaning up the test files created during the test
	defer helpers.CleanUpTestFiles(t, testFiles, workDir)

	// Create the provider file
	err := helpers.CreateAzureProviderFile(path.Join(workDir, "provider.tf"), t)
	if err != nil {
		t.Fatal(err)
	}

	// Use type assertions to ensure the interface values are the expected type for the given
	// terraform variable value
	location, ok := terraformOptions.Vars["location"].(string)
	if !ok {
		t.Fatal("A value type of 'string' was expected for 'location'")
	}

	resourceGroup, ok := terraformOptions.Vars["resource_group_name"].(string)
	if !ok {
		t.Fatal("A value type of 'string' was expected for 'resourceGroup'")
	}

	// Defer the deletion of the resource group until all test functions have finished
	defer helpers.DeleteAzureResourceGroup(t, subscriptionID, resourceGroup)

	// Create the resource group
	err = helpers.CreateAzureResourceGroup(t, subscriptionID, resourceGroup, &location)
	if err != nil {
		t.Fatal(err)
	}

	// Defer destroying the terraform resources until the rest of the test functions finish
	defer terraform.Destroy(t, terraformOptions)

	// Init and apply the terraform module
	terraform.InitAndApply(t, terraformOptions)
}
