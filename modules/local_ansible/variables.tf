variable "ansible_playbook_name" {
  type        = string
  description = "The name of the Ansible playbook to run"
}

variable "ansible_directory" {
  type        = string
  description = "The name of the directory to run the Ansible playbook in"
}

variable "ansible_args" {
  type        = string
  description = "The args to pass to the ansible playbook"
  default     = ""
}
