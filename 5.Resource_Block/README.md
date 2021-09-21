# Resource Block

    - Resource block describes one or more infrastructure objects, such as virtual networks, compute instances, or higher-level components such as DNS records.


```HTML
 <resource> "<resource TYPE>" "<resource NAME>" {
  # Block body
  <ARGUMENT> = <EXPRESSION/VALUE>
}

Example- 

resource "aws_instance" "web_server" {
  ami           = "ami-abc1234"
  instance_type = "t2.micro"
}

```
- A "resource" block declares a resource of a given type ("aws_instance") with a given local name ("web_server"). 

- Within the block body (between { and }) are the configuration arguments for the resource itself. 

## Resource Arguments

    - Most of the arguments within the body of a resource block are specific to the selected resource type. 


## Meta-Arguments

    - Terraform also support meta-arguments. which can be used with any resource type to change the behavior of resources.

The following meta-arguments are :

1. **depends_on** - for specifying hidden dependencies.
2. **count** - for creating multiple resource instances according to a count.
3. **for_each** - to create multiple instances according to a map, or set of strings.
4. **provider** - for selecting a non-default provider configuration.
5. **lifecycle** - for lifecycle customizations.
6. **provisioner and connection** - for taking extra actions after resource creation.


## Timeouts Operation

    - Some resource types provide a special timeouts nested block argument. This allows you to how long operation can considered.

    ```HTML
        resource "aws_db_instance" "example" {
        # Some Code...

        timeouts {
            create = "600s"     # 600 seconds
            update = "60m"      # 60 minutes
            delete = "2h"       # 2 hours
        }
    }
    ```