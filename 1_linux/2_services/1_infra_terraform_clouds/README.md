#### Cloud providers and IaC

```
.
├── cloud-init      - cloud-init basics/commands
├── digitalocean    - doctl / DigitalOcean commands
├── kvm             - KVM/libvirt commands
└── terraform
    ├── terraform.sh
    └── examples
        ├── aws        - IAM user, ECR, EFS, EKS (terraform + eksctl), S3
        ├── libvirt     - cloud-init + libvirt VMs, k8s-on-libvirt
        ├── vmware      - vSphere (terraform, Ansible role, Dockerfile), vRA
        └── yandex-cloud - security groups, managed Kubernetes
```

1. [cloud-init/cloud-init.sh](cloud-init/cloud-init.sh) - cloud-init basics
2. [digitalocean/digitalocean.sh](digitalocean/digitalocean.sh) - DigitalOcean CLI (`doctl`) commands
3. [kvm/kvm.sh](kvm/kvm.sh) - KVM/libvirt commands
4. [terraform](terraform) - Terraform commands (`terraform.sh`) and worked examples:
   * `examples/aws` - IAM CI/CD user, ECR, EFS, EKS cluster (Terraform and eksctl), S3
   * `examples/libvirt` - libvirt VMs via cloud-init (CentOS/Ubuntu), a small k8s-on-libvirt lab
   * `examples/vmware/vshpere` - vSphere VM provisioning (Terraform, Ansible role wrapper, Dockerfile runner)
   * `examples/vmware/vra` - vRealize Automation example
   * `examples/yandex-cloud` - security groups, managed Kubernetes cluster

Note: pinned provider/module versions in these examples are point-in-time snapshots
from when each example was written - check current versions before reuse.
