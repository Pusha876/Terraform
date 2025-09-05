# Day 19 — Terraform Provisioners

This project demonstrates the use of Terraform provisioners to configure infrastructure after deployment. It creates a Linux VM on Azure and uses various provisioner types to install and configure software.

## Purpose

This mini-project showcases three types of Terraform provisioners:
- **local-exec**: Executes commands on the machine running Terraform
- **remote-exec**: Executes commands on the remote resource via SSH
- **file**: Copies files from local machine to the remote resource

The example provisions a Ubuntu VM and automatically installs Nginx web server with a custom welcome page.

## Project Structure

```
day_19_Terraform_Provisioners/
├── main.tf          # Core infrastructure and provisioner configuration
├── provider.tf      # Terraform and provider version requirements
├── variables.tf     # Input variables (common_tags)
├── outputs.tf       # Output values for easy access
├── backend.tf       # Remote state configuration
├── config/
│   └── sample.conf  # Sample Nginx configuration file
└── README.md        # This file
```

## Resources Created

- **Resource Group** (`provisioners-rg` in East US 2)
- **Virtual Network** with subnet
- **Network Security Group** (allows SSH port 22 and HTTP port 80)
- **Public IP** (static allocation)
- **Network Interface** 
- **Linux Virtual Machine** (Ubuntu 22.04 LTS, Standard_B1s)
- **null_resource** for deployment preparation logging

## Provisioner Workflow

1. **local-exec**: Creates a timestamped deployment log file locally
2. **remote-exec**: Connects via SSH to:
   - Update package lists
   - Install Nginx web server
   - Create custom HTML welcome page
   - Start and enable Nginx service
3. **file**: Copies `config/sample.conf` to the VM home directory

## Prerequisites

- Terraform >= 1.5.0
- Azure CLI authenticated (`az login`)
- SSH key pair at `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`

## Usage

### 1. Initialize Terraform
```bash
tf init
```

### 2. Plan deployment
```bash
tf plan
```

### 3. Deploy infrastructure
```bash
tf apply --auto-approve
```

### 4. Access the server
After deployment, use the output values:
```bash
# SSH into the VM
ssh -i ~/.ssh/id_rsa adminuser@<public_ip>

# View the Nginx welcome page
curl http://<public_ip>
# Or open http://<public_ip> in your browser
```

### 5. Clean up
```bash
tf destroy --auto-approve
```

## Key Configuration Details

### Authentication
- VM uses SSH key authentication (no passwords)
- Username: `adminuser`
- SSH key path: `~/.ssh/id_rsa.pub`

### Network Security
- SSH access: Port 22 (for provisioners and manual access)
- HTTP access: Port 80 (for Nginx web server)
- Source: Any IP address (0.0.0.0/0)

### Tagging
All resources are tagged with:
- Environment: Development
- Project: Terraform-Provisioners
- Owner: DevOps-Team
- CreatedBy: Terraform

## Outputs

The configuration provides useful outputs:
- `vm_public_ip`: Public IP address of the VM
- `ssh_connection_command`: Ready-to-use SSH command
- `nginx_server_url`: Direct URL to test the web server
- Resource names and network information

## Learning Objectives

This project demonstrates:
- ✅ Using multiple provisioner types together
- ✅ SSH connection configuration for remote provisioners
- ✅ File transfer from local to remote systems
- ✅ Automated software installation and configuration
- ✅ Dependency management between provisioners
- ✅ Error handling and timeout configuration

## Common Issues & Solutions

### SSH Connection Timeouts
- Ensure SSH key exists at `~/.ssh/id_rsa`
- Check Network Security Group allows port 22
- VM may need time to boot (10-minute timeout configured)

### File Provisioner Errors
- Ensure `config/sample.conf` exists locally
- Check file permissions and paths

### Nginx Not Accessible
- Verify Network Security Group allows port 80
- Check VM's public IP in outputs
- Ensure Nginx service started successfully

## Next Steps

Consider extending this project by:
- Adding more complex application deployments
- Using cloud-init for faster VM configuration
- Implementing blue/green deployment patterns
- Adding monitoring and logging configuration