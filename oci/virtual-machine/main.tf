provider "oci" {
  tenancy_ocid         = "your-tenancy-ocid"
  user_ocid            = "your-user-ocid"
  fingerprint          = "your-api-fingerprint"
  private_key_path     = "key.pem"
  region               = "your-oci-region"
}

# Add the following network configuration
resource "oci_core_virtual_network" "example_vcn" {
  compartment_id = "your-compartment-ocid"
  cidr_block     = "10.0.0.0/16"
  display_name   = "example-vcn"
}

resource "oci_core_subnet" "example_subnet" {
  compartment_id  = "your-compartment-ocid"
  vcn_id          = oci_core_virtual_network.example_vcn.id
  cidr_block      = "10.0.0.0/24"
  availability_domain = "your-availability-domain"
  display_name    = "example-subnet"
}

resource "oci_core_security_list" "example_security_list" {
  compartment_id = "your-compartment-ocid"
  display_name   = "example-security-list"
  vcn_id         = oci_core_virtual_network.example_vcn.id

  ingress_security_rules {
    source_type = "CIDR_BLOCK"
    source      = "0.0.0.0/0"
    protocol    = "6"  # TCP
    is_stateless = false
    tcp_options {
      destination_port_range {
        min = 22
        max = 22
      }
    }
  }
}

resource "oci_core_instance" "example_vm" {
  availability_domain = "your-availability-domain"
  compartment_id      = "your-compartment-ocid"
  shape               = "VM.Standard2.1"  # VM shape/type
  display_name        = "example-vm"
  image_id            = "your-oci-image-ocid"
  subnet_id           = oci_core_subnet.example_subnet.id
  ssh_authorized_keys = ["your-ssh-public-key"]

  timeouts {
    create = "10m"
  }
}
