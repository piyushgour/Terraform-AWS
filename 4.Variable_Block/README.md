# Variable

- variables are used to store information to be referenced. 

## Variables Declarations

    - Input Variable
    - Input Variables using .tf/.tfvars file
    - Local Variable
    - Output Variable

## Input Variable

#### You can use Input variable with in the code (.tf) file mentining variable block.
```HTML
    variable "variable-name" {
        type = string
        default = "default-value"
        description = "variable description."
    }

    variable "region" {
        type = string
        default = "us-west-1"
        description = "AWS Region."
    }
```
## Calling Variable using .tf/.tfvars file

#### for getting value of variable you can used "var." as prefix then "Variable-name". like below code 
```HTML
# In main.tf file variable block is present.

    variable "region" {
        type = string
        default = "us-west-1"
        description = "AWS Region."
    }

    provider "aws" {
        region = var.region
    }
```

#### Calling Variable using variables.tf file
#####  Variable can maintain by seprate file "variables.tf" file. 

```HTML
# In variables.tf file
    variable "aws_region" {
        type    = string
        default = "us-west-1" 
    }

# In main.tf file you can call variable value 
provider "aws" {
  region = var.aws_region  
}

```

##### Calling Variable using terraform.tfvars file

```HTML
# In variables.tf file
    variable "aws_region" {
        type    = string
    }

# In terraform.tfvars file
    aws_region = us-west-1

# In main.tf
    provider "aws" {
    region = var.aws_region   
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}
```


## Local Variable

#### These vaiable using "Locals" Block.
#### Calling variable using prefix "local".

```HTML

    locals {
        aws_region = "us-west-1"
    }

    provider "aws" {
        region = local.aws_region  
    }

```

## Output Variable

    - Output values are like the return values of a Terraform code.

```HTML

    resource "aws_instance" "web-server" {
        ami = "ami-123456789"
        instance_type = "t2.micro"
        # some other code ...  
    }


# This give Instance ID (id-) as output value after the deployment of above resource.
    
    output "Instance_id" {
         value = aws_instance.web-server.id
    }
```


## Variable Precedence

    - High -> Any -var and -var-file options on the command line, in the order they are provided.

    - Medium -> The terraform.tfvars file, if present.
    
    - low -> The variables.tf file, if present.
    
    - last -> Environment variables. 