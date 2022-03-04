# Provider
- Terraform relies on plugins called "providers" to interact with cloud providers, SaaS providers, and other APIs.

- Terraform configurations must declare which providers they require, so that Terraform can install and use them. Additionally, some providers require configuration (like endpoint URLs or cloud regions) before they can be used.


## What Providers Do
- Each provider adds a set of resource types and/or data sources that Terraform can manage.

- Every resource type is implemented by a provider; without providers, Terraform can't manage any kind of infrastructure.

## Authentication
- The AWS provider offers a flexible means of providing credentials for authentication. The following methods are supported, in this order, and explained below:

    - Static credentials  : Static credentials can be provided by adding an access_key and secret_key in-line in the AWS provider block.

    - Environment variables  : you can provide your credentials via the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, environment variables, representing your AWS Access Key and AWS Secret Key, respectively.
    
    - Shared credentials/configuration file  : You can use an AWS credentials or configuration file to specify your credentials. The default location is $HOME/.aws/credentials on Linux and macOS, or "%USERPROFILE%\.aws\credentials" on Windows. 