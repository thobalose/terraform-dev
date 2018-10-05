# terraform-dev

Terraform on OpenStack

## Usage

Assumptions:

- Enabled SSH and ICMP access to instances
- Added and imported Keypairs
- Have floating IPs

Download and install [Terraform](https://www.terraform.io/downloads.html):

```sh
$ wget -P /tmp/ https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
--
$ unzip /tmp/terraform_0.11.8_linux_amd64.zip
$ sudo mv terraform /usr/local/bin/
$ terraform --version
```

Log in to the OpenStack dashboard, choose the project for which you want to download the OpenStack RC file, and run the following commands:

```sh
$ source ~/Downloads/PROJECT-openrc.sh
Please enter your OpenStack Password for project PROJECT as user username:
```

Initialize Terraform:

- Initialize a new or existing Terraform working directory by creating
  initial files, loading any remote state, downloading modules, etc.

```sh
$ terraform init
Initializing...
```

Generate an execution Plan:

- This execution plan can be reviewed prior to running apply to get a sense for what Terraform will do

```sh
$ terraform plan
...
```

Apply changes:

- Builds or changes infrastructure according to Terraform configuration files in DIR.

```sh
$ terraform apply
```

:rocket::boom:
