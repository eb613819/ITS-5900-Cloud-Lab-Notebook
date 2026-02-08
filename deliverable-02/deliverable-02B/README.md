# Deliverable 2B - Infrastructure as Code

## Objective
The purpose of this deliverable is to get OpenTofu setup on the gHost and use it to provision a VM in Azure.

---

## Table of Contents
- [Objective](#objective)
- [OpenTofu Setup](#opentofu-setup)
  - [Installation](#installation)
---

## OpenTofu Setup
### Installation
These steps can be used to install OpenTofu on the gHost running Ubuntu 24.04.3 LTS.
1.) Download the installer script:
  ```bash
  curl -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
  ```
2.) Grant execute permissions and review the script:
  ```bash
  chmod +x install-opentofu.sh && less install-opentofu.sh
  ```
3.) Install using the script:
  ```bash
  ./install-opentofu.sh --install-method standalone
  ```
4.) Check that OpenTofu is installed:
  ```bash
  tofu version
  ```
  If everything worked, a version will show:
  ```bash
  itsvm@ITS-4900-Cloud-GNS3-015-eb613819:~$ tofu version
  OpenTofu v1.11.4
  on linux_amd64
  ```
5.) Remove the installer:
  ```bash
  rm -f install-opentofu.sh
  ```
