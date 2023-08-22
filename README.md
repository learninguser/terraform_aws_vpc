# VPC Module

This module creates the following resources. It automatically fetches the first 2 AZ's and create the resources.

* VPC
* Internet Gateway
* 2 public subnets
* 1 public route table
* 2 private subnets
* 1 private route table
* 2 database subnets
* 1 database route table
* 1 Elastic IP
* 1 NAT gateway in 1a az.
* Assocition between public subnets and public route table
* Assocition between private subnets and private route table
* Assocition between database subnets and database route table

## Name format for the resources
**for subnets:** [project_name]-public/private/database-1a/1b <br/>
**for route tables:** [project_name]-public/private/database

## Arguments

**Project_name** (Required) - User must provide his project name <br/>

**vpc_cidr** (Optional) - Default value is 10.0.0.0/16 <br/>

**vpc_tags** (Optional) - User can provide tags, other wise empty <br/>

**public_subnet_cidr** (Required) - User must provide 2 valid subnet CIDR <br/>

**public_subnet_tags** (Optional) - User can provide tags, other wise empty <br/>

**private_subnet_cidr** (Required) - User must provide 2 valid subnet CIDR <br/>

**private_subnet_tags** (Optional) - User can provide tags, other wise empty <br/>

**database_subnet_cidr** (Required) - User must provide 2 valid subnet CIDR <br/>

**database_subnet_tags** (Optional) - User can provide tags, other wise empty <br/>

**private_route_table_tags** (Optional) - User can provide tags, other wise empty <br/>

**public_route_table_tags** (Optional) - User can provide tags, other wise empty <br/>

**database_route_table_tags** (Optional) - User can provide tags, other wise empty <br/>

### Outputs

vpc_id -  This is the ID of VPC created
