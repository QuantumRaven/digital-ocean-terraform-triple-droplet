locals {

    whitelist_ips = [

        #######################################################
        # Replace below with: public_ip_address_goes_here/32:
        # Example:
        # "0.0.0.0/32"
        #######################################################

    ]

    ###################################
    # Name of each droplet:
    # Created during terraform apply
    ###################################

    droplets = [

        {

            name = "test-1"

        },
        {

            name = "test-2"

        },
        {

            name = "test-3"

        }

    ]

}
