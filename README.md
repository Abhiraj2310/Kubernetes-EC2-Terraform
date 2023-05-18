# Kubernetes EC2 Terraform

This project provides a Terraform configuration to deploy a Kubernetes cluster on Amazon EC2 instances. It automates the provisioning and configuration of the infrastructure required for setting up a scalable and reliable Kubernetes cluster.

## Prerequisites

Before you begin, ensure you have the following prerequisites installed:

- [Terraform](https://www.terraform.io/downloads.html) (version >= 0.12)

- [AWS CLI](https://aws.amazon.com/cli/) configured with your AWS credentials

- [kubectl](https://kubernetes.io/docs/tasks/tools/) (optional, for interacting with the Kubernetes cluster)

## Getting Started

To get started with this project, follow these steps:

1. Clone this repository to your local machine:

   ```shell

   git clone https://github.com/Abhiraj2310/Kubernetes-EC2-Terraform.git

   ```

2. Change into the project directory:

   ```shell

   cd Kubernetes-EC2-Terraform

   ```

3. Initialize the Terraform configuration:

   ```shell

   terraform init

   ```

4. Modify the `terraform.tfvars` file to customize the cluster configuration. You can adjust the number of worker nodes, EC2 instance types, region, etc. according to your requirements.

5. Review the Terraform plan to ensure everything looks correct:

   ```shell

   terraform plan

   ```

6. Deploy the Kubernetes cluster:

   ```shell

   terraform apply

   ```

   Terraform will provision the necessary EC2 instances, security groups, and other resources on AWS.

7. Once the deployment is complete, you will see the outputs with information about the cluster, such as the cluster endpoint, worker node details, and kubeconfig file location.

8. (Optional) Configure `kubectl` to interact with the newly created Kubernetes cluster. If you already have `kubectl` installed, you can update your kubeconfig file by running the following command:

   ```shell

   aws eks update-kubeconfig --name <cluster-name> --region <region>

   ```

   Replace `<cluster-name>` with the name of your cluster and `<region>` with the AWS region where the cluster was created.

9. You can now use `kubectl` commands to manage and interact with your Kubernetes cluster.

## Cleaning Up

To clean up and destroy the resources created by this project, run the following command:

```shell

terraform destroy

```

**Note:** This will destroy all the resources associated with the Kubernetes cluster, including EC2 instances, security groups, etc. Make sure you have backups or snapshots of any important data before proceeding with the destroy operation.

## Contributing

If you'd like to contribute to this project, please follow the guidelines outlined in [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

We would like to acknowledge the following resources and projects that inspired and helped us in creating this Kubernetes EC2 Terraform configuration:

- [Terraform](https://www.terraform.io)

- [AWS](https://aws.amazon.com)

- [Kubernetes](https://kubernetes.io)

Thank you for using this project! If you have any questions or feedback, please don't hesitate to [open an issue](https://github.com/Abhiraj2310/Kubernetes-EC2-Terraform/issues).
