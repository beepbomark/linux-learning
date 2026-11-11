# Automation and Orchestration

Source: CompTIA Linux+ XK0-006, objective 4.1

## Infrastructure as code
### What it is
The practice of managing and provisioning infrastructure (servers, networks, configurations) using code and automation instead of manual processes.
### Purpose
- Automate infrastructure deployment
- Ensure consistency across environments
- Reduce human error
- Enable version control and repeatability
### Key concepts
- Declarative -> define desired state (e.g., "server should have nginx installed")
- Imperative -> define step-by-step commands to achieve state
- Idempotency -> running the same code multiple times produces the same result
- Version control -> infrastructure stored and tracked in Git
### Components
- Configuration management tools -> manage system state
- Provisioning tools -> create infrastructure resources 
- Templates -> reusable infrastructure definitions
- State files -> track current infrastructure state
### Common tools
- Ansible -> agentless configuration management
- Puppet -> declarative configuration management
- Chef -> infrastructure automation
- Terraform -> infrastructure provisioning (IaC)
### Techniques 
#### 1. Configuration management (example: Ansible)
```bash
# install nginx using ansible
ansible all -m apt -a "name=nginx state=present"
```
#### 2. Declarative infrastructure (example: Terraform)
```bash
# example terraform config
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  }
```
### Benefits
- Consistency -> same configuration across all systems
- Scalability -> easily deploy multiple servers
- Speed -> faster provisioning and updates
- Auditability -> changes tracked in version control
### Hardening techniques
- Store IaC code in secure repositories
- Use access control for infrastructure changes
- Validate and test configurations before deployment
- Avoid hardcoding sensitive data (use secrets management)
- Implement approval workflows (CI/CD pipelines)
### Notes
- IaC enables "treat infrastructure like software"
- Idempotency ensures safe repeated execution
- Combine with CI/CD for automated deployments
- Requires proper versioning and documentation
### Real-world scenario
1. Admin writes Terraform code to define cloud infrastructure
2. Code is stored in Git repository
3. Pipeline runs and provisions servers automatically
4. Ansible configures software on provisioned servers
5. Environment is consitently deployed and easily reproducible
---
## Puppet
### What it is
A configuration management tool that automates the deployment, configuration, and management of systems using a declarative language.
### Purpose
- Maintain consistent system configurations
- Automate repetitive administrative tasks
- Enforce desired system state
- Manage large-scale infrastructure
### Key concepts
- Declarative model -> define what the system should look like
- Idempotency -> repeated runs produce the same result
- Desired state -> Puppet ensures system matches the defined configuration
- Agents -> nodes that receive configurations
- Master (server) -> central system managing configurations
### Architecture
- Puppet Server (Master) -> stores configurations (manifests)
- Puppet Agent -> runs on client nodes and applies configs
- Manifests -> files defining system state
- Modules -> reusable collection of manifests
- Facts -> system information (e.g., OS, IP) used for decisions
### Workflow
1. Agent sends system facts to Puppet Server
2. Server compiles configuration (catalog)
3. Agent retrieves catalog
4. Agent enforces desired state on system
5. Changes are reported back to server
### Tools
```bash
# check puppet agent status
puppet agent --test

# apply a manifest locally
puppet apply site.pp

# view facts about system
facter
```
### Example manifest
```bash
# install and ensure nginx is running
package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  ensure => running,
  enable => true,
}
```
### Benefits
- Consistency across multiple systems
- Centralized configuration management
- Scalable for large environments
- Automated compliance enforcement
### Hardening techniques
- Secure communication between agent and server (TLS)
- Restrict access to Puppet Server
- Use role-based access control (RBAC)
- Validate manifests before deployment
- Store code in version control (e.g., Git)
### Limitations
- Requires agent installation on all nodes
- Learning curve for Puppet DSL
- Infrastructure overhead (server setup)
### Notes
- Puppet uses a pull model (agents request updates)
- Runs periodically to enforce state
- Works well in large enterprise environments
- Alternative tools include Ansible (agentless) and Chef
### Real-world scenario
1. Admin defines system configuration in Puppet manifest
2. Puppet Server distributes configuration to all agents
3. Agents apply configuration automatically
4. Systems remain consistent across environment
5. Any drift is corrected during next Puppet run
---
## OpenTofu
### What it is
An open-source Infrastructure as Code (IaC) tool used to define, provision, and manage infrastructure using declarative configuration files. It is a community-driven fork of Terraform.
### Purpose
- Automate infrastructure provisioning (cloud, on-premises)
- Ensure consistent and repeatable deployments
- Manage infrastructure lifecycle as code
- Enable version-controlled infrastructure changes
### Key concepts
- Declarative configuration -> define desired infrastructure state
- Idempotency -> repeated runs produce consistent results
- State management -> tracks current infrastructure state
- Providers -> plugins that interact with platforms (AWS, Azure, etc)
- Modules -> reusable infrastructure components
### Components 
- Configuration files (`.tf`) -> define infrastructure
- State file (`.tfstate`) -> tracks resources and changes
- Providers -> APIs for infrastructure platforms
- Resources -> individual infrastructure elements (VMs, networks)
### Workflow
1. Write configuration file defining infrastructure
2. Initialize project (`init`)
3. Review execution plan (`plan`)
4. Apply configuration (`apply`)
5. Manage updates and destroy resources if needed
### Tools
```bash
# initialize working directory
tofu init

# preview changes
tofu plan

# apply configuration
tofu apply

# destroy infrastructure
tofu destroy
```
### Example configuration
```bash
# create a cloud instance
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```
### Benefits
- Open-source and community-driven
- Compatibile with Terraform workflows
- Enables infrastructure versioning and automation
- Supports multi-cloud and hybrid environments
### Hardening techniques
- Secure state files (may contain sensitive data)
- Use remote state backends with encryption
- Avoid hardcoding secrets (use environment variables or vaults)
- Implement access control for IaC repositories
- Review and validate plans before applying
### Limitations
- Requires understanding of infrastructure concepts
- State file management can be complex
- Misconfigurations can impact large environments quickly
### Notes
- OpenTofu emerged to maintain open-source IaC ecosystem
- Works similarly to Terraform with minimal changes
- Often used with CI/CD pipelines for automation
- Supports modular and scalable infrastructure design
### Real-world scenario
1. Admin writes OpenTofu configuration for cloud infrastucture
2. Runs `tofu plan` to preview changes
3. Applies configuration to provision resources
4. State file tracks deployed infrastructure
5. Future changes are managed through updated code
---
## Unattended deployment
### What it is
The automated installation and configuration of operating systems or softwares without manual intervention, using predefined configuration files and scripts.
### Purpose
- Automate system provisioning at scale
- Ensure consistent system setups
- Reduce manual effort and human error
- Speed up deployment of servers and environments
### Key concepts
- Preseed / Kickstart -> automated OS installation configurations
- Cloud-init -> initializes cloud instances on first boot
- Answer files -> predefined responses to installation prompts
- Idempotency -> repeated deployments produce identical systems
### Common methods
- Preseed (Debian/Ubuntu) -> automated installer configuration
- Kickstart (RHEL/CentOS/Fedora) -> scripted installation
- Cloud-init -> used in cloud environments for first-time setup
- PXE boot -> network-based automated installation
### Components
- Configuration file -> defines installation settings (packages, users, network)
- Installation source -> ISO, network repository, or image
- Automation scripts -> post-install configuration
- Provisioning tools -> integrate with IaC tools (e.g., Ansible)
### Tools
```bash
# example: cloud-init configuration snippet
#cloud-config
users:
  - name: admin
    sudo: ALL=(ALL) NOPASSWD:ALL

packages:
  - nginx

runcmd:
  - systemctl start nginx
```
### Workflow
1. Define unattended configuration (preseed/kickstart/cloud-init)
2. Boot system (ISO, PXE, or cloud image)
3. Installer reads configuration automatically
4. System installs OS and required packages
5. Post-install scripts configure system
6. System is ready for use without manual setup
### Benefits
- Rapid deployment of multiple systems
- Consistent and repeatable configurations
- Reduced setup time and operational overhead
- Scalable for cloud and enterprise environments 
### Hardening techniques
- Secure unattended configuration files (may contain credentials)
- Use encrypted or hashed passwords
- Restrict network access to installation sources
- Validate configurations before deployment
- Integrate with configuration management for post-install hardening
### Limitations
- Initial setup can be complex
- Errors in configuration can propagate to many systems
- Requires testing to ensure reliability
### Notes
- Common in cloud environments and large data centers
- Often combined with IaC and CI/CD pipelines
- Essential for DevOps and automated infrastructure workflows
- Enables "zero-touch provisioning"
### Real-world scenario
1. Admin creates a cloud-init file for server configuration
2. New virtual machine is launched in cloud
3. Cloud-init automatically installs packages and creates users
4. System is fully configured on first boot
5. Deployment completes without manual intervention
---
## Continuous Integration/Continuous Deployment (CI/CD)
### What it is
A set of practices and pipelines that automate the process of building, testing, and deploying code changes, enabling faster and more reliable software delivery.
### Purpose
- Automate software build, test, and deployment processes
- Detect issues early through continuous testing
- Deliver updates quickly and consistently
- Reduce manual errors and improve reliability
### Key concepts
- Continuous Integration (CI) -> frequent code commits with automated builds/tests
- Continuous Deployment (CD) -> automatic release of code to production
- Continuous Delivery -> code is ready for release but may require approval
- Pipeline -> sequence of automated steps (build -> test -> deploy)
### Components
- Source control -> code repository (e.g., Git)
- Build system -> compiles and packages code
- Test framework -> runs automated tests
- Artifact repository -> stores built packages
- Deployment system -> pushes code to environments
### Workflow
1. Developer commits code to repository
2. CI pipeline triggers automatically
3. Code is built and tested
4. If tests pass -> artifact is created
5. CD pipeline deploys to staging/production
6. Monitoring ensures deployment success
### Common tools
- Jenkins -> widely used CI/CD tool
- GitHub Actions -> integrated with GitHub
- GitLab CI/CD -> built-in GitLab pipelines
- CircleCI -> cloud-based CI/CD
### Example pipeline (conceptual)
```bash
# pseudo workflow
1. git push origin main
2. run build script
3. execute tests
4. package application
5. deploy to server
```
### Benefits
- Faster release cycles
- Early detection of bugs
- Improved code quality
- Consistent and repeatable deployments
### Hardening techniques
- Restrict access to pipeline configurations 
- Use secrets management (avoid hardcoding credentials)
- Validate code with automated security scans
- Require approvals for production deployments
- Monitor pipeline logs and activities
### Limitations
- Requires setup and maintenance effort
- Pipeline failures can block deployments
- Misconfigurations can propagate issues quickly
### Notes
- CI/CD is core to DevOps practices
- Works best with version control and automated testing
- Enables rapid iteration and continuous improvement
- Often integrated with IaC and containerization
### Real-world scenario
1. Developer pushes code to repository
2. CI pipeline builds and tests application automatically
3. Tests pass -> CD pipeline deploys to staging
4. After approval, deployment proceeds to production
5. System is updated with minimal downtime and risk
---
## Deployment orchestration
### What it is
The automated coordination and management of multiple systems, services, and deployment steps to ensure applications are deployed in the correct order and state across environments.
### Purpose
- Coordinate complex deployments across multiple servers/services
- Ensure dependencies are handled correctly
- Automate end-to-end deployment workflows
- Improve reliability and reduce human error
### Key concepts
- Orchestration vs automation ->
  - Automation = individual tasks
  - Orchestration = coordinating multiple automated tasks
- Workflow management -> defines sequence of deployment steps
- Dependency handling -> ensures services start in correct order
- Scaling -> deploy across many nodes simultaneously
### Components
- Orchestrator -> central system managing workflows
- Nodes -> systems where services are deployed
- Playbooks/manifests -> define deployment steps
- State management -> tracks deployment status
### Common tools
- Kubernetes -> container orchestration
- Docker Swarm -> Docker-native orchestration
- Ansible -> orchestration via playbooks
- Puppet -> configuration orchestration
### Example (Ansible playbook snippet)
```bash
- hosts: webservers
  tasks:
    - name: install nginx
      apt:
        name: nginx
        state: present

    - name: start nginx
      service:
        name: nginx
        state: started
```
### Workflow
1. Define deployment workflow (playbook/pipeline)
2. Orchestrator triggers deployment
3. Systems are updated in correct sequence
4. Dependencies are validated (e.g., database before app)
5. Services are started and verified
6. Deployment status is reported
### Benefits
- Consistent multi-system deployments
- Reduced downtime and deployment errors
- Scalable across large environments
- Faster and repeatable release processes
### Hardening techniques
- Use role-based access control (RBAC) for orchestration tools
- Secure communication between orchestrator and nodes
- Validate configurations before deployment
- Monitor deployments and logs
- Implement rollback mechanisms
### Limitations
- Complexity increases with scale
- Requires proper planning and testing
- Misconfiguration can impact multiple systems simultaneously
### Notes
- Essential for microservices and distributed systems
- Often integrated with CI/CD pipelines
- Supports blue-green and rolling deployments
- Combines automation with workflow intelligence
### Real-world scenario
1. Admin defines deployment workflow using orchestration tool
2. CI/CD pipeline triggers orchestration process
3. Database is deployed first, followed by backend and frontend
4. Services are started in correct order
5. System is verified and deployed successfully across all nodes
---
