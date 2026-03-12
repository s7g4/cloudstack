package test

import (
	"crypto/tls"
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAwsWeb(t *testing.T) {
	t.Parallel()

	// Pick a random AWS region to test in. This helps ensure your code doesn't depend on a specific region.
	awsRegion := "us-east-1"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../terraform",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"project_name": fmt.Sprintf("test-%s", random.UniqueId()),
			"aws_region":   awsRegion,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	url := terraform.Output(t, terraformOptions, "web_alb_url")

	// Validate the Web Server returns a 200 OK
	// It can take a minute for the App to boot up, so retry a few times
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second

	http_helper.HttpGetWithRetry(t, url, &tls.Config{}, 200, "CloudStack Demo", maxRetries, timeBetweenRetries)
}
