# Checkpoint Firewall Automation with Ansible

This project demonstrates automated management of Check Point firewalls using Ansible. It provides a reproducible development environment and example playbooks for both SSH and API-based firewall management.

## Prerequisites

- Nix package manager with flakes enabled
- SSH access to target firewalls
- Check Point management server (MDS) credentials (to run the MDS playbooks)

## Quick Start

1. Clone the repository and enter the development environment:

```bash
git clone <repository-url>
cd <repository-name>
nix develop
```

2. Set up your Check Point management credentials (CheckPoint Mgmt SSH/WebGUI ReadWriteAccess in keeper) :

```bash
export CHECKPOINT_PASSWORD='your_password_here'
```

## Project Structure

```
checkpoint-ansible-mgmt/
├── ansible.cfg             # Ansible configuration file
├── flake.lock              # Nix flake lock file
├── flake.nix               # Main Nix development environment definition
├── inventory.yml           # Ansible inventory with Check Point devices
├── nix/
│   └── pkgs/
│       └── checkpoint-sdk/ # Check Point SDK Nix package
│           ├── flake.lock
│           └── flake.nix
├── playbooks/
│   ├── fetch_backups.yml  # Grabs backup files from hosts listed in inventory.yml 
│   ├── test_chkp_gaia.yml # API-based management tests
│   └── test_chkp_ssh.yml  # SSH-based firewall tests
└── README.md              # Project documentation
```

## Running Playbooks

Before running playbooks, ensure you update `inventory.yml` with the appropriate targets. 

Test fetching backups from firewalls (requires ssh key in ~/.ssh/ directory):
```bash
ansible-playbook playbooks/fetch_backups.yml
```

Test SSH connectivity to firewalls (requires Check Point mgmt password set):

```bash
ansible-playbook playbooks/test_chkp_ssh.yml
```

Test API connectivity to management server (requires Check Point mgmt password set):

```bash
ansible-playbook playbooks/test_chkp_gaia.yml
```

## Development Environment

The project uses Nix flakes to provide a consistent development environment with:

- Python 3 with Ansible
- Check Point Management API SDK as a Nix Flake
- Check Point Ansible collections 
  - check_point.mgmt
  - check_point.gaia

All of this is automatically installed with the `nix develop` command.

## Security Notes

- SSH host key checking is disabled by default for testing (`host_key_checking = False`)
- Enable host key checking in production by removing this setting from `ansible.cfg`
- SSL certificate validation is disabled for API testing
- Credentials are managed through environment variables for security

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request


---

For questions or issues, please open a GitHub issue.

## TODO

- Push files to S3 bucket
- Gather information on S3 versioning-> are files with same hashed updated? We want files only updated when changed
- Create github action with an internal runner. 
