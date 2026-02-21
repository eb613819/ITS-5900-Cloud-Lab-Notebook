# Deliverable 3B - Ansible Automation

## Objective
The purpose of this deliverable is to 

---

## Reference Documentation
- [Ansible VyOS Module](https://docs.ansible.com/ansible/latest/collections/vyos/vyos)
- [YAML Lint](https://www.yamllint.com) – YAML syntax checker
- [JinjaFx](https://jinjafx.io) – Jinja syntax checker
- [Ansible Overview](https://medium.com/@denot/ansible-101-d6dc9f86df0a)
- [JSON Structure Overview](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/JSON)

---

## Table of Contents
- [Objective](#objective)
- [Reference Documentation](#reference-documentation)
- [Task 1 – Clone the class GitHub repo and install Ansible](#task-1)

---

<a id="task-1"></a>
## Task 1 - Clone the class GitHub repo and install Ansible
### Clone Class Repo
The first step of this deliverable is to clone the class repo.

1. **Authenticate Git**
   First, we must check if the gHost's CLI Git client is authenticated to GitHub:
  ```bash
  gh auth status
  ```
  
  If it is not, follow the steps from the [Pre-deliverable Setup](../../pre-deliverable-setup/README.md#authentication)

2. **Create Directory**
  We want a standard directory structure for the homework assignments. The homework will assume a structure like `~/Cloud/<GITHUB_REPO_NAME>`. We will match that to keep things simple:
  ```bash
  mkdir ~/Cloud
  cd ~/Cloud
```

3. **Clone Repository**

   
