# Deploy Nginx on AWS EC2 with Terraform

This training lab creates one Ubuntu 22.04 LTS t2.micro instance and one security group. The AWS provider defaults to Mumbai (ap-south-1). Terraform looks up Canonical's Ubuntu AMI in SSM Parameter Store and reuses your public subnet and EC2 key pair. The security group permits HTTP on TCP 80 from any IPv4 address and SSH on TCP 22 from your public IPv4 address. EC2 user data installs Nginx and writes a custom HTML page. Terraform outputs the public IPv4 address and URL and tags the instance, security group, and encrypted root volume.

## 1. Set up AWS

Install Terraform 1.6 or newer, AWS CLI v2, and Git. Run the commands from the project root in Bash. Sign in to AWS and check access with `aws sts get-caller-identity`. Your identity needs permissions to read the Ubuntu SSM parameter and manage the EC2 resources.

Choose an existing subnet with a route from 0.0.0.0/0 to an internet gateway and an EC2 key pair in the same region. The availability zone must offer t2.micro. Use your public IPv4 address with /32 as the SSH CIDR. Keep the private key outside Git. EC2, EBS, and public IP usage may incur charges.

```bash
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

Replace the sample subnet, key pair, and SSH CIDR with your values.

## 2. Deploy and verify

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -out=nginx.tfplan
terraform apply nginx.tfplan
terraform output -raw instance_public_ip
terraform output -raw nginx_url
```

A fresh plan should show two resources to add. Wait for cloud-init to finish, then open the output URL in your browser. The page should show **Terraform Nginx Lab**. You can also run `curl -fsS "$(terraform output -raw nginx_url)"`.

Capture the browser displaying the custom page and its public IP in the address bar. Save the screenshot as [nginx-running.png](screenshots/nginx-running.png). If the page takes longer than a few minutes, check the subnet route and HTTP rule. Over SSH, sign in as ubuntu and inspect /var/log/cloud-init-output.log.

## 3. Destroy the lab

```bash
terraform destroy
terraform state list
```

Review the plan and type yes. Confirm Terraform reports two resources destroyed and the state list is empty. Save terminal evidence as [terraform-destroy.png](screenshots/terraform-destroy.png).

## 4. Publish and submit

Create an empty GitHub repository and use its URL below. If you extracted the ZIP into a fresh folder, initialize Git with `git init -b main` first.

```bash
git add .
git commit -m "Publish Terraform Nginx lab and deployment evidence"
git remote add origin https://github.com/YOUR-USERNAME/terraform-nginx-lab.git
git push -u origin main
```

Confirm your evaluator can open the repository and both screenshots, then submit the URL through the course portal. Check the deadline in the portal.
