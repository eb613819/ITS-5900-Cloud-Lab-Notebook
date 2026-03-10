# Cloud Architecture Lab Notebook

This repository contains lab notes, config notes, and supporting files for ITS5900 - Cloud Architecture. All work is completed on the provided gHost GNS3 VM unless otherwise noted.

Each lab/deliverable is documented in its own directory using Markdown files that are automatically rendered by GitHub.

## Repository structure
```bash
ITS-5900-Cloud-Lab-Journal/
├── README.md
│
├── pre-deliverable-setup/
│   ├── README.md
│   ├── /images
│   ├── /scripts
│   └── del01_submission_evanB.md
│
├── deliverable-01/
│   ├── README.md
│   └── /images
│
├── deliverable-02/
│   ├── deliverable-02A/
│   │   └── README.md
│   │
│   └── deliverable-02B/
│       ├── README.md
│       └── /src
│           ├── main.tf
│           ├── providers.tf
│           └── variables.tf
│
├── deliverable-03/
│   ├── deliverable-03A/
│   │   └── README.md
│   │
│   └── deliverable-03B/
|       ├── README.md
|       └── /src
│
│
└── .gitignore
```

## Conventions
- Each deliverable directory contains a `README.md` that serves as the lab notebook.
- Steps, commands, observations, and problems/solutions are documented in the notebook as they occur.
- Related scripts, config files, diagrams, etc. are stored alongside the notebook.

## Environment
- **Dev Environment**: GNS3 gHost
- **Code Editor**: Visual Studio Code
- **Scripting Language**: Python
- **Cloud Platform**: Microsoft Azure
- **Version Control**: GitHub
