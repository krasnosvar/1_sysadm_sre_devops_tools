
vsphere_user = "service_account"
vsphere_password = "{{ service_account_passw }}"
vsphere_server = "vcenter.local"
# hostname = "u2004vm"
hostname = "{{ vm_hostname }}"

# vm_count = 2
# vm_cpu = 2
# vm_memory = 4
# vm_disk_os_size = 50
# vm_disk_data_size = 1

ssh_key = ""

vsphere_datacenter = "Production"
vsphere_compute_cluster = "vmw-PROD-DELL"
vsphere_network = "VLAN_2343(Production)"
vsphere_datastore = "PROD-Store-01"
vsphere_res_pool = "PROD-POOL"
vsphere_ubuntu_template = "ubuntu-focal-20.04-for-devops"
# vsphere_ubuntu_template = "ubuntu-focal-20.04-cloudimg"
# vsphere_folder = "Tests VMs(TST-NO-PROD)/000-005"
