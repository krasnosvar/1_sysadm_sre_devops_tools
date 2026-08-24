# Clouds и IaC — что изучать

> Практическая база знаний:
> **[5_devops_sre_knowledgebase/4_iac/](../../5_devops_sre_knowledgebase/4_iac/)**
> **[5_devops_sre_knowledgebase/6_compute_platforms/](../../5_devops_sre_knowledgebase/6_compute_platforms/)**

## AWS

### Изучение

- [roadmap.sh/aws](https://roadmap.sh/aws) — интерактивная карта AWS
- [AWS Skill Builder](https://skillbuilder.aws/) — бесплатные официальные курсы от AWS
- [AWS Free Tier](https://aws.amazon.com/free/) — 12 месяцев бесплатных ресурсов для практики

### Сертификации AWS

- **AWS Cloud Practitioner** — $100, начальный уровень, хорошо для знакомства с AWS
- **AWS Solutions Architect Associate** — $300, самая популярная, рекомендуется
- **AWS DevOps Engineer Professional** — $300, CI/CD + IaC + операции, для опытных

Лучший курс для SAA: [Adrian Cantrill](https://learn.cantrill.io/) (платный, высокое качество)
или Stephane Maarek на Udemy.

## Terraform / OpenTofu

- [developer.hashicorp.com/terraform/tutorials](https://developer.hashicorp.com/terraform/tutorials) — бесплатные официальные туториалы
- [terraform-best-practices.com](https://www.terraform-best-practices.com/) — best practices
- [registry.terraform.io](https://registry.terraform.io/) — публичный реестр модулей и провайдеров
- **Terraform Associate** — $70, онлайн тест, хорошее начало для IaC
- **OpenTofu** (форк, MIT лицензия) — [opentofu.org](https://opentofu.org/)

## GCP

- [cloud.google.com/training](https://cloud.google.com/training) — бесплатные курсы Google
- Уникальные сильные стороны: BigQuery, Vertex AI, GKE Autopilot

## Azure

- [learn.microsoft.com](https://learn.microsoft.com/azure/) — бесплатное обучение Microsoft
- Сильные стороны: Active Directory, .NET экосистема, AKS

## Инструменты (шпаргалки)

- Terraform команды → `../1_linux/2_services/1_infra_terraform_clouds/terraform/terraform.sh`
- Terraform примеры (AWS/libvirt/VMware/Yandex) → `../1_linux/2_services/1_infra_terraform_clouds/terraform/examples/`
- AWS CLI, doctl, cloud-init → `../1_linux/2_services/1_infra_terraform_clouds/`
