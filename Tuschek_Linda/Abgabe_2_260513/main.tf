terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "~> 0.54"
    }
  }
}

provider "exoscale" {
  key    = var.exoscale_api_key
  secret = var.exoscale_api_secret
}

resource "exoscale_security_group" "vm_security_group" {
  name = "vm-info-security-group"
}

resource "exoscale_security_group_rule" "http" {
  security_group_id = exoscale_security_group.vm_security_group.id

  type  = "INGRESS"
  protocol = "TCP"

  start_port = 80
  end_port   = 80

  cidr = "0.0.0.0/0"
}

resource "exoscale_security_group_rule" "ssh" {
  security_group_id = exoscale_security_group.vm_security_group.id

  type  = "INGRESS"
  protocol = "TCP"

  start_port = 22
  end_port   = 22

  cidr = "0.0.0.0/0"
}

resource "exoscale_compute_instance" "vm" {
  name        = "vm-info-vm"
  zone        = "de-fra-1"
  type        = "standard.micro"
  template_id = "Linux Ubuntu 22.04 LTS 64-bit"

  disk_size = 10

  security_group_ids = [
    exoscale_security_group.vm_security_group.id
  ]

  user_data = file("cloud-init.yaml")
}
