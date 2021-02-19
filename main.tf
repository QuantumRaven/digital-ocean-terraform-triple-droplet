variable "token" {}
variable "pubkey" {}

#
# Run terraform init to install/download provider libraries.
#
provider "digitalocean" {

    token = var.token

}

resource "digitalocean_ssh_key" "my-vpc" {

    name       = "test-1"
    public_key = var.pubkey

}

resource "digitalocean_droplet" "dropletz" {

    count = length(local.droplets)

    image  = "ubuntu-18-04-x64"
    name   = local.droplets[count.index].name
    region = "nyc3"
    size   = "s-1vcpu-1gb"

    ssh_keys = [
        digitalocean_ssh_key.my-vpc.id
    ]

}

resource "digitalocean_firewall" "test-1" {

    name        = "test-1"
    droplet_ids = digitalocean_droplet.dropletz[*].id

    inbound_rule {

        protocol         = "tcp"
        port_range       = "22"
        source_addresses = local.whitelist_ips


    }

    inbound_rule {

        protocol         = "icmp"
        source_addresses = local.whitelist_ips

    }

}

output "test-asdfasdf" {

    value = digitalocean_droplet.dropletz[*].ipv4_address

}