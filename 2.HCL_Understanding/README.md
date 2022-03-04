# HCL
 HCL (HashiCorp Language) is a system for defining configuration languages for applications. The HCL information model is designed to support multiple concrete syntaxes for configuration, but this native syntax is considered the primary format and is optimized for human authoring and maintenance, as opposed to machine generation of configuration.

The language consists of three integrated sub-languages:

- The structural language defines the overall hierarchical configuration structure, and is a serialization of HCL bodies, blocks and attributes.

- The expression language is used to express attribute values, either as literals or as derivations of other values.

- The template language is used to compose values together into strings, as one of several types of expression in the expression language.


A Terraform configuration is a complete document in the Terraform language that tells Terraform how to manage a given collection of infrastructure. A configuration can consist of multiple files and directories.

The syntax of the Terraform language consists of only a few basic elements:

```HTML
 <BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK Name>" {
  # Block body
  <IDENTIFIER> = <EXPRESSION> # Argument
}
```
#### Example-
```sh
resource "aws_instance" "web" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
}
```