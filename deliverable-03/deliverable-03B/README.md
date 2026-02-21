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
   - [Clone Class Repo](#clone-class-repo)
---

<a id="task-1"></a>
## Task 1 - Clone the class GitHub repo and install Ansible
### Clone Class Repo
The first step of this deliverable is to clone the class repo.

#### **Authenticate Git**
First, we must check if the gHost's GitHub CLI (`gh`) is authenticated to GitHub:
```bash
gh auth status
```

If it is not, follow the steps from the [Pre-deliverable Setup](../../pre-deliverable-setup/README.md#authentication)

#### **Create Directory**
We want a standard directory structure for the homework assignments. The homework will assume a structure like `~/Cloud/<GITHUB_REPO_NAME>`. We will match that to keep things simple:
```bash
mkdir ~/Cloud
cd ~/Cloud
```

#### **Clone Repository**
From inside the newly created directory we can clone the deliverable repository:
```bash
gh repo clone OHIO-ECT/ITS-4900-Cloud-Release
```
   
**Note**: for an error like:
```bash
GraphQL: Resource protected by organization SAML enforcement. You must grant your OAuth token access to this organization. (repository)
Authorize in your web browser:  https://github.com/enterprises/ohiouniversity/sso?authorization_request=AQX5XL3U5VNYBPQIFEN66KLJTEWS3A5PN5ZGOYLONF5GC5DJN5XF62LEZYCUOQUJVVRXEZLEMVXHI2LBNRPWSZGOY2LJAKNPMNZGKZDFNZ2GSYLML52HS4DFVNHWC5LUNBAWGY3FONZQ
```
1. Open the exact URL shown
2. Click `Continue`
3. Sign in
4. Refresh the token:
   ```bash
   gh auth refresh -h github.com -s repo
   ```
Then try cloning the repo again.
