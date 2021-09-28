# Basic configuration without variables

#### VM CREATION ####

# Set vm parameters
resource "vsphere_virtual_machine" "vm-two" {
  name             = "vm-two"
  num_cpus         = 1 
  memory           = 1024
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
    label = "vm-two.vmdk"
    size = "10"
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

  }

}
