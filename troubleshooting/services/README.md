# Service Troubleshooting

This section contains Linux service troubleshooting concepts, workflows, and operational examples.

---

## Service Basics

Services are background processes responsible for providing system functionality.

Common Linux services include:
- SSH
- networking
- web servers
- databases
- virtualization services

Services commonly start automatically during boot.

Common Service Examples:
|Service|Purpose|
|---|---|
|`sshd`|Remote SSH access|
|`NetworkManager`|Network management|
|`cron`|Scheduled tasks|
|`docker`|Container management|
|`libvirtd`|Virtualization management|

Key lesson:  
Linux systems rely heavily on services for operational functionality.

---

## systemd Basics

`systemd` is the default Linux init system responsible for:
- starting services
- managing system targets
- handling boot operations
- tracking logs

`systemd` replaced older init systems such as SysVinit.

Common systemd Components:
|Component|Purpose|
|---|---|
|service units|Manage services|
|targets|Define operating modes|
|journal|Store system logs|

Common Commands:
```bash
systemctl
journalctl
```

Key lesson:  
Most modern Linux service management is handled through systemd.

---

## Service States

Services can exist in different operational states.

Common Service States:
|State|Meaning|
|---|---|
|active (running)|Service operational|
|inactive|Service stopped|
|failed|Service encountered error|
|enabled|Starts automatically during boot|
|disabled|Does not start automatically|

Common Command:
```bash
systemctl status ssh
```

Key lesson:  
Understanding service states is important during troubleshooting.

---

## Service Management

Servces can be:
- started
- stopped
- restarted
- enabled
- disabled

Common Commands:
```bash
systemctl start ssh
systemctl stop ssh
systemctl restart ssh
systemctl enable ssh
systemctl disable ssh
```

Common Troubleshooting Areas:
- service startup failures
- incorrect configuration
- failed dependencies
- permission problems

Key lesson:  
Restarting services is common during troubleshooting and configuration changes.

---

## Service Logs

Service logs help identify:
- startup failures
- configuration errors
- dependency problems
- runtime failures

Common Commands:
```bash
journalctl
journalctl -u ssh
journalctl -xe
journalctl -f
```

Common Troubleshooting Areas:
- service crashes
- authentication failures
- missing configuration files
- port binding issues

---

## Startup and Boot Services

Many services automatically start during boot.  

systemd controls which service start and when.

Common Commands:
```bash
systemctl list-unit-files
systemctl get-default
```

Common Troubleshooting Areas:
- service fails during boot
- serivce starts too early
- missing dependencies
- boot delays

Key lesson:  
Boot problems commonly involve failed or delayed services.

---
## Service Dependencies

Some services depend on other services before they can function correctly.

Example:
- web server depends on networking
- virtualization service depends on kernel modules
- database service depends on storage availability

Common Commands:
```bash
systemctl list-dependencies
```

Common Troubleshooting Areas:
- dependency failures
- startup ordering problems
- required services unavailable

Key lesson:  
Service failure may originate from dependency problems rather than the service itself.

---

## Common Service Troubleshooting Examples

### SSH Service Not Running

Common Symptoms:
- unable to SSH into server
- connection refused
- remote access unavailable

Common Checks:
```bash
systemctl status ssh
ss -tuln
journalctl -u ssh
```

Common Causes:
- ssh service stopped
- invalid configuration
- firewall issue
- port conflict

Key lesson:  
Remote access depends on both service availability and network connectivity.

---

### Service Fails To Start

Common Symptoms:
- service enters failed state
- application unavailable
- repeated restart attempts

Common Checks:
```bash
systemctl status
journalctl -xe
journalctl -u service_name
```

Common Causes:
- invalid configuration
- missing dependencies
- permission issues
- missing files

Key lesson:  
Logs usually contain the most useful information during service failures.

---

### Service Starts But Functionality Fails

Common Symptoms:
- service active but unusable
- application inaccessible
- incomplete functionality

Common Checks:
```bash
systemctl status
ss -tuln
journalctl
```

Common Causes:
- firewall restrictions
- incorrect configuration
- dependency issues
- permission problems

Key lesson:  
An active service does not always guarantee operational functionality.

---

### Service Fails During Boot

Common Symptoms:
- service unavailable after reboot
- delayed startup
- dependency errors during boot

Common Checks:
```bash
systemctl status
journalctl -b
systemctl list-dependencies
```

Common Causes:
- incorrect startup order
- dependency failure
- unavailable storage/network

Key lesson:  
Some service depend heavily on successful system initialization during boot.

---

### High Resource Usage By Service

Common Symptoms:
- high CPU usage
- excessive memory consumption
- slow system performance

Common Checks:
```bash
top
htop
ps aux
systemctl status
```

Common Causes:
- runaway process
- memory leak
- execessive requests
- application issue

Key lesson:  
Services can impact overall system stability and performance.

---

Common Service Commands
|Command|Purpose|
|---|---|
|`systemctl status`|Show service status|
|`systemctl start`|Start service|
|`systemctl stop`|Stop service|
|`systemctl restart`|Restart service|
|`systemctl enable`|Enable service at boot|
|`systemctl disable`|Disable service at boot|
|`journalctl`|View system logs|
|`journalctl -u`|View service logs|
|`journalctl -xe`|View detailed recent logs|
|`journalctl -f`|Live log monitoring|
|`systemctl list-unit-files`|List available services|
|`systemctl list-dependencies`|Show service dependencies|

---

