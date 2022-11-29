# Note

When you get the following error creating VMs using terraform:

```
Could not open '/var/lib/libvirt/vm_images/ubuntu_jammy.qcow2': Permission denied
```

Edit /etc/libvirt/qemu.conf

```
security_driver = "none"
```

This disables SELinux. Afterwards you can reload libvirt.
