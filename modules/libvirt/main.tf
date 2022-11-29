resource "libvirt_pool" "vm_pool" {
  name = ""
  type = "dir"
  path = "/var/lib/libvirt/vm_images"
}

locals {
  gigabit_in_bytes = 1073741824
}

# Defining VM Volume
resource "libvirt_volume" "ubuntu_jammy_base" {
  name   = "ubuntu_jammy.qcow2"
  pool   = libvirt_pool.vm_pool.name
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
}

# Defining VM Volume
resource "libvirt_volume" "ubuntu_jammy" {
  name           = "tf-test.qcow2"
  pool           = libvirt_pool.vm_pool.name
  base_volume_id = libvirt_volume.ubuntu_jammy_base.id
  format         = "qcow2"
  size           = 20 * local.gigabit_in_bytes
}

# Define libvirt domain to create
resource "libvirt_domain" "ubuntu_jammy" {
  name   = "tf-test"
  memory = "1024"
  vcpu   = 2

  network_interface {
    network_name = "vrbr1" # List networks with virsh net-list
  }

  disk {
    volume_id = libvirt_volume.ubuntu_jammy.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}

# resource "libvirt_cloudinit_disk" "vm_init" {
#   name           = "commoninit.iso"
#   pool           = libvirt_pool.vm_pool
#   user_data      = module.ansible_cloud_init_role.cloud_init_user_data
#   network_config = module.ansible_cloud_init_role.cloud_init_network_data
#
#   depends_on = [
#     # cloud_init must be ready when creating virtual disk
#     module.ansible_cloud_init_role
#
#   ]
# }

module "ansible_cloud_init_role" {
  source            = "./modules/ansible_cloud_init_role"
  ansible_directory = var.ansible_directory
}

# Uncomment later
# module "run_provision_playbook" {
#   source                = "./modules/local_ansible"
#   ansible_playbook_name = var.ansible_playbook_name
#   ansible_directory     = var.ansible_directory
# }
