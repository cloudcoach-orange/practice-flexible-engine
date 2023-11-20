# To use OpenStack cli, you need to authenticate against the Identity Service, than you can use all the services API
# This file is customize for FE and to provide some env var for terraform too ()

# IAM uri for authentification (for eu-west-0)
export OS_AUTH_URL=https://iam.eu-west-0.prod-cloud-ocb.orange-business.com/v3

# Domain and Projet ID of the tenant, you can retrieve it from console > top right user connected > My Credential
export OS_USER_DOMAIN_ID= # Account ID
export OS_PROJECT_ID=     # Project ID of eu-west-0_stud0x
export OS_PROJECT_NAME=eu-west-0_stud0X

# Region should be same of Auth url
export OS_REGION_NAME="eu-west-0"

# User/password (from my credential session too)
export OS_USERNAME=user.name

# Global Training AccessKey / SecretKey
export S3_ACCESS_KEY_ID=     # AK
export S3_SECRET_ACCESS_KEY= # SK

# get password by typing with uncomment next 2 lines and comment 3rd one. Or put your password (/!\less safe)
echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
#OS_PASSWORD_INPUT="Great Password"
export OS_PASSWORD=$OS_PASSWORD_INPUT

#To set version of API, not sure if all theses elements are required
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
export OS_NETWORK_API_VERSION=2

#To make Terraform work for labs example
export TF_VAR_USERNAME=$OS_USERNAME
export TF_VAR_PASSWORD=$OS_PASSWORD
export TF_VAR_DOMAIN_ID=$OS_USER_DOMAIN_ID

