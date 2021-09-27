# Basic configuration without variables

# Define authentification configuration
provider "vsphere" {
  # If you use a domain set your login like this "Domain\\User"
  user           = "administrator@vsphere.local"
  password       = "HomeLab23!"
  vsphere_server = "10.20.20.196"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

#### RETRIEVE DATA INFORMATION ON VCENTER ####

data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

# If you don't have any resource pools, put "Resources" after cluster name
data "vsphere_resource_pool" "pool" {
  name          = "Homelab/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Retrieve datastore information on vsphere
data "vsphere_datastore" "datastore" {
  name          = "datastore3"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Retrieve network information on vsphere
data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Retrieve template information on vsphere
data "vsphere_virtual_machine" "template" {
  name          = "debian10"
  datacenter_id = data.vsphere_datacenter.dc.id
}

#### VM CREATION ####

# Set vm parameters
resource "vsphere_virtual_machine" "demo" {
  name             = "vm-one"
  num_cpus         = 2
  memory           = 2048 
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type

  # Set network parameters
  network_interface {
    network_id = data.vsphere_network.network.id
  }

  # Use a predefined vmware template as main disk
  disk {
    label = "vm-one.vmdk"
    size = "30"
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

  }

}
