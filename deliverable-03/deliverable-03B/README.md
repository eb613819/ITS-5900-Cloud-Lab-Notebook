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
- [Task 1 – Clone Class GitHub Repo](#task-1)
   - [Authenticate Git](#authenticate-git)
   - [Create Directory](#create-directory)
   - [Clone Repository](#clone-repository)
- [Task 2 - Build an SSH key](#task-2)
   - [Generate the SSH Key](#generate-the-ssh-key)
   - [Start the SSH Agent](#start-the-ssh-agent)
   - [Add the SSH Key to the Agent](#add-the-ssh-key-to-the-agent)
   - [Verify the Key is Loaded](#verify-the-key-is-loaded)
   - [Start SSH Agent Automatically on Login](#start-ssh-agent-automatically-on-login)
  
---

<a id="task-1"></a>
## Task 1 - Clone Class GitHub Repo
The first step of this deliverable is to clone the class repo.

### **Authenticate Git**
First, we must check if the gHost's GitHub CLI (`gh`) is authenticated to GitHub:
```bash
gh auth status
```

If it is not, follow the steps from the [Pre-deliverable Setup](../../pre-deliverable-setup/README.md#authentication)

### **Create Directory**
We want a standard directory structure for the homework assignments. The homework will assume a structure like `~/Cloud/<GITHUB_REPO_NAME>`. We will match that to keep things simple:
```bash
mkdir ~/Cloud
cd ~/Cloud
```

### **Clone Repository**
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
   - `-h` specifies the GitHub host
   - `-s` adds specific OAuth scopes
     
Then try cloning the repo again.

<a id="task-2"></a>
## Task 2 - Build an SSH Key
We will generate an SSH key to securely access the virtual machines provisioned by Tofu, eliminating the need for password-based authentication.

### Generate the SSH Key
We can generate an SSH key with the following command:
```bash
ssh-keygen -t ed25519 -C "itsclass"
```
- `t` specifies the key type
- `-C` adds a comment to the key
  
**Note**: Use the default file location when prompted and give it a passphrase that you can remember.

### Start the SSH Agent
Start the SSH agent and set the necessary environment variables:
```bash
eval $(ssh-agent -s)
```
- `eval` executes the output of the command in the current shell
- `ssh-agent -s` starts the SSH agent and outputs the environment variables

### Add the SSH Key to the Agent
Add the generated private key to the running SSH agent:
```bash
ssh-add ~/.ssh/id_ed25519
```
- `ssh-add` loads a private key into the SSH agent
- `~/.ssh/id_ed25519` is the default private key generated earlier

### Verify the Key is Loaded
To confirm the key was successfully added:
```bash
ssh-add -l
```
- `-l` lists the fingerprints of all loaded keys

If successful, you should see your key fingerprint displayed.

### Start SSH Agent Automatically on Login
So that we do not have to manually start the SSH agent on every login, we can append the commands to `.bashrc`:
```bash
cat >> ~/.bashrc << 'EOF'

# Auto-start ssh-agent if not running
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent -s)
    ssh-add ~/.ssh/id_ed25519
fi
EOF
```
- `cat >> ~/.bashrc` appends content to your shell configuration file
- The conditional checks whether the SSH agent is already running
- If not, it starts the agent and loads your key

