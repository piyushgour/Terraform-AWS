# Data Source

    - Data sources allow Terraform use information defined outside of Terraform (by Manual Action or Cloudformation), defined by another separate Terraform configuration, or modified by functions.

```HTML

        data "<resource TYPE>" "<resource NAME>" {
            # Block body
            <ARGUMENT> = <resource ID>
        }
        
        ## Sample Code block
        data "aws_vpc" "web-server-vpc"{
            id = "vpc-010101010101"
        }

        ## Recived values from data block
        output "vpc-arn" {
            value = data.aws_vpc.web-server-vpc.arn
        }

        ## Output 
        vpc-arn = arn:aws:ec2:us-west-1:99999999:vpc/vpc-010101010101
```
    - Expression while fatching values from data block
```HTML
        data.<Resource TYPE>.<Resource NAME>.<ATTRIBUTE>

        Example
        data.aws_vpc.web-server-vpc.id
```