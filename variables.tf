variable "access_key" {
    type = "string"
    default = "AKIA45MIFH5SGG6Q6WOA"
    description = "Access Key"
}

variable "secret_key" {
    type = "string"
    default = "r6GtHL8Cjm3ml/iak4PirNjiBU1NHJChudAK+gr9"
    description = "Secret Access Key"
}

variable "region" {
    type = "string"
    default = "ap-south-1"
    description = "Region"
}

variable "instance_type" {
    type = "string"
    default = "t2.micro"
    description = "EC2 Instance type"
}

variable "engine_version" {
  default     = "10.6"
  type        = string
  description = "Database engine version"
}

variable "instance_type" {
  default     = "db.t2.micro"
  type        = string
  description = "Instance type for database instance"
}

variable "database_username" {
  default     = "postgres"
  type        = string
  description = "Name of user inside storage engine"
}

variable "database_password" {
  default     = "postgres"
  type        = string
  description = "Database password inside storage engine"
}

variable "database_port" {
  default     = 5432
  type        = number
  description = "Port on which database will accept connections"
}


