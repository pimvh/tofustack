variable "ansible_playbook_name" {
  description = "Ansible playbook name to run"
  default     = "provision"
  type        = string
}

variable "ansible_directory" {
  description = "Target directory of Ansible"
  default     = "../ansiblestack"
  type        = string
}
