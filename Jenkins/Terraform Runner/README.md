# Jenkins Terraform Runner — README

This setup provides a simple Jenkins pipeline for running Terraform in a controlled and repeatable way. The pipeline:

1. **Cleans the workspace**
2. **Checks out the repository**
3. **Executes Terraform** using a wrapper script (`terraformw`) that ensures the correct Terraform version is installed
   via **tfswitch**
4. **Cleans the workspace again** after the job completes

## How it works

* The `terraformw` script installs `tfswitch` locally, pins Terraform to the required version (`1.0.0`), and then
  forwards any arguments to Terraform.
* Jenkins calls this wrapper script during the `terraform` stage:

  ```sh
  ./terraformw apply -auto-approve -no-color
  ```
* Terraform outputs a simple value:

  ```hcl
  output "jenkins_terraform" {
    value = "running Terraform from Jenkins"
  }
  ```