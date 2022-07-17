terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "public_read" {
  bucket = "my-tf-log-bucket"
  acl = "private"
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket" "public_read_log_bucket" {
  bucket = "public_read-log-bucket"
}

resource "aws_s3_bucket_logging" "public_read" {
  bucket = aws_s3_bucket.public_read.id

  target_bucket = aws_s3_bucket.public_read_log_bucket.id
  target_prefix = "log/"
}


resource "aws_s3_bucket_server_side_encryption_configuration" "public_read" {
  bucket = aws_s3_bucket.public_read.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket" "public_read_write" {
  acl = "private"

  bucket = "foo_name"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "public_read_write" {
  bucket = aws_s3_bucket.public_read_write.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "public_read_write" {
  bucket = aws_s3_bucket.public_read_write.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_security_group" "allow_tcp" {
  name = "allow_tcp"
  description = "Allow TCP inbound traffic"
  vpc_id = aws_vpc.foo_vpc.id
  ingress {
    description = "TCP from VPC"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = 69
    to_port = 69
    protocol = "udp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}