###################################################
# Token and Pubkey Info:
###################################################

variable "do_token" {}
variable "pubkey" {}

################################
# Specifies do_token variable
# for SSH
################################

provider "digitalocean" {

    token = var.do_token

}

################################################
# VPC Key Info:
# Used for remoting in to the created droplets
################################################

resource "digitalocean_ssh_key" "do-vpc" {

    name = "test-1"
    public_key = file(var.pubkey)

}

############################################
# Droplet Info:
# Used to define the OS, Region, and Size
# based on data in locals.tf file
############################################

resource "digitalocean_droplet" "dropletz" {

    count = length(local.droplets)

    image  = "ubuntu-18-04-x64"
    name   = local.droplets[count.index].name
    region = "nyc3"
    size   = "s-1vcpu-1gb"

    ssh_keys = [
        digitalocean_ssh_key.do-vpc.id
    ]

}

###########################################
# Firewall Info:
# Firewall info that sits between clients
# and the Floating IP and Bastion VPS
###########################################

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

#################################################
# Informs user of when creation starts and ends
# and if there are any errors
#################################################

output "test-droplet-deployment" {

    value = digitalocean_droplet.dropletz[*].ipv4_address

}
