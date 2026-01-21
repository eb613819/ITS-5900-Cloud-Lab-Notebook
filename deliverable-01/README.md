# Deliverable 1 - Tooling, Azure Setup, and Initial VM Deployment

## Objective
The purpose of this deliverable is to select and document the development tools used for this course, configure the Azure development environment on the gHost, and deploy a basic virtual server using Azure CLI.

---

## Task 1 - Select Tools

### Large Language Model (LLM)
**Selected LLM**: ChatGPT (Free Tier)\
**Justification**: I do not expect to use an LLM for this course, but if I do I will use ChatGPT. This is the only LLM I have experience with. If for some reason ChatGPT does not meet my needs, I will switch to the instructor recommendation (Claude).

### Programming Language
**Selected Language**: Python\
**Justification**: Python is widely used in cloud automation and scripting. I also taught a Python programming course last semester, so I am very familiar with it. And, this way I will be on the same page as the instructor.

### Software Development Environment
**Selected Environment**: Visual Studio Code (VSCode)
**Justification**: VSCode supports tight integration with Azure tooling, powershell, and GitHub. Plus, using it will keep me on the same page as the instructor.

### Development Venue
**Selected Venue**: GNS3 gHost
**Justification**: The gHost is a blank slate to develop on, which will make identifying and resolving issues more straightforward. This venue also provides support from the instructor.

### Free Azure Student Account
**Login Info**: OHIO Credentials (eb613819@ohio.edu)
- [x] $100 credit verified.
- [x] Azure Portal accessed.

---

## Task 2 - VSCode Development Environment Setup
- Installed the `Azure App Service` extension in VSCode by following unit 3 of [this guide](https://learn.microsoft.com/en-us/training/modules/prepare-your-dev-environment-for-azure-development/3-exercise-set-up-dev-environment?pivots=vscode).
- Signed in to Azure by clicking the `A` icon in the left toolbar -> `Sign in toAzure...`.
  ![azure_extension](./images/Azure-Extension.png)
- Azure Resources are visable in the extension:
  ![azure_resources](./images/Azure-Resources.png)
