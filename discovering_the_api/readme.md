# LAB: discover the API of Flexible Engine

This lab will help you to use various API of Flexible Engine with various tools available for you. You can do it on your local machine or creating a ECS with an EIP and connect to do it.
You can clone this repository or download the resources as zip.

## Set environment variables

First you need to set variable in configuration file "setenv.sh", you can find all the information in my credential (top right on the Flexible Engine Console).

You need at least to change the value of:

- OS_USER_DOMAIN_ID (line 8)
- OS_PROJECT_ID (line 9)
- OS_PROJECT_NAME (line 10)
- OS_USERNAME (line 16).
- S3_ACCESS_KEY_ID (line 18)
- S3_SECRET_ACCESS_KEY (line 19)  

If you're not doing on eu-west-0, you also need to change:

- OS_AUTH_URL (line 5)
- OS_REGION_NAME (line 13)

Then you should source the parameters and enter your API password

```shell
$ source setenv.sh
Please enter your OpenStack Password:
***********
$
```

## Openstackcli

> you need to install openstackcli for this part.
> if you are using linux, juste type "sudo apt install python3-openstackclient"
> overwise follow openstack documentation https://docs.openstack.org/newton/user-guide/common/cli-install-openstack-command-line-clients.html

OpenStackClient (aka OSC) is a command-line client for OpenStack that brings the command together in a single shell with a uniform command structure.

Query all the image of the plateform

```shell
openstack image list
```

Create a router/VPC

```shell
$ openstack router create <your_router_name>
+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                   |
+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| admin_state_up          | UP    
.....
```

List all router

```shell
$ openstack router list
+--------------------------------------+--------------------+--------+-------+----------------------------------+
| ID                                   | Name               | Status | State | Project                          |
+--------------------------------------+--------------------+--------+-------+----------------------------------+
| 1d87c119-XXX-4bXXX-8496-3803XXXX886b | <your_router_name> | ACTIVE | UP    | 00000000cxxxxxxxxxxx3e1e7cdd7c28 |
+--------------------------------------+--------------------+--------+-------+----------------------------------+
```

Delete router

```shell
openstack router delete <your_router_name>
```

Openstackcli is an easy way to use the API but having some issue to create a lot of resources as one call means one resource.
list of all the command available: https://docs.openstack.org/python-openstackclient/latest/cli/command-list.html (FE don't support all of them)

## Curl

It's possible to use API without abstraction tools. To try them, there is few script in folder curl. All script look the same:

- Action and target services as the name file.
- First lines of script are variables for target services, there is few change depending of action and service.
- In the middle, there is the token request as it's mandatory to use api.
- Last line is the wanted api of the script.

Get the image list with script **get_image.sh**

```shell
bash curl/get_image.sh
```

as you can see with raw usage of API and no tools, the output is hard to read.

Create an EIP

```shell
bash curl/create_eip.sh
```

Get a list of all the eip, it should be easier to read because you have less elements.

```shell
bash curl/get_eip.sh
```

Delete the eip, The script will ask for the eip id, copy/past id from the last output (be careful of empty space and quote)

```shell
$ bash curl/delete_eip.sh
Please enter the eip id to delete:
91216f81-xxxx-aaaa-bbbb-f668a4c84ce3
$
```

The usage of the API like that are more time consuming but allow you to use and integrate it with anything able to use web services.

## Terraform

> you need to install terraform for this part.

If you are using ubuntu 64bit, you can do:

```shell
wget https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip
sudo apt install unzip  (if needed)
unzip terraform_1.5.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/terraform
```

> if you are using something else, follow official documentation https://learn.hashicorp.com/terraform/getting-started/install.html

### with flexibleegine provider

> Documentation of terraform flexible engine provider https://www.terraform.io/docs/providers/flexibleengine/index.html

Go to terraform-fe folder and edit configuration file **config.tf**. Change value of variable **keypair** with the name of an existing keypair.

```shell
vi terraform-fe/config.tf
```

Then go inside the folder to init environment of terraform:

```shell
cd terraform-fe/
terraform init
```

Plan and/or apply to see change and deploy the infrastructure. Before any change, terraform will ask for confirmation before changing, but you can by-pass this by adding "-auto-approve"

```shell
terraform plan
terraform apply -auto-approve
```

The deployed infrastructure is described in ".tf" file. If you want, you can edit the file to change a parameter like a name or an IP. After each change you need to reapply, it will show you the change : edition, deletion, deletion with re-creation, etc.

```shell
terraform apply
```

When you've finished, delete all the resources

```shell
terraform destroy -auto-approve
```

## Use Object Storage API with s3cmd

> S3cmd is a free command line tool and client for uploading, retrieving and managing data in cloud storage service providers that use the S3 protocol.  
> if you are using linux, you can get it from linux. example for ubuntu: 

```shell
sudo apt install s3cmd
```

> or from official website https://s3tools.org/s3cmd  
> This part will also use sourced setenv with S3_ACCESS_KEY_ID and S3_SECRET_ACCESS_KEY in the setenv file.

Copy the file .s3cfg at the root of your user, or add "-c s3cmd/.s3cfg" at the end of each command.

List and show information of bucket

```shell
s3cmd ls
s3cmd ls -c s3cmd/.s3cfg
s3cmd info s3://<name-of-bucket>
```

Then create a bucket, upload a local file, delete a file &  the bucket.

```shell
s3cmd mb s3://<your-bucket-name>
s3cmd put readme.md s3://<your-bucket-name>
s3cmd ls s3://<your-bucket-name>
s3cmd rm s3://<your-bucket-name>/readme.md
s3cmd rb s3://<your-bucket-name>
```

You can find all the usage at https://s3tools.org/usage
