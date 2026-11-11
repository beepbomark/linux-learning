# Monitoring

Source: CompTIA Linux+ XK0-006, objective 5.1

## Service monitoring
### What it is
THe process of tracking the status, performance, and availability of system services to ensure they are running correctly.
### Purpose
- Ensure critical services are running
- Detect failures or downtimes quickly
- Maintain system reliability and uptime
- Trigger alerts or automated recovery
### Key concepts
- Service state -> active, inactive, failed
- Uptime monitoring -> ensure continuous operation
- Health checks -> verify service functionality
- ALerts -> notify when issues occur
### Common services monitored
- Web servers -> Apache, Nginx
- Database services -> MySQL, PostgreSQL
- SSH service -> remote access
- System services -> cron, networking
### Tools
#### systemd (primary tool)
```bash
systemctl status ssh
systemctl is-active nginx
systemctl list-units --type=service
```
#### Check if service is running
```bash
systemctl is-active apache2
```
#### Restart service
```bash
systemctl restart nginx
```
### Process monitoring
```bash
ps aux | grep nginx
top
htop
```
### Port/service checks
```bash
ss -tulnp
netstat -tulnp
```
### Log monitoring
```bash
journalctl -u nginx
tail -f /var/log/syslog
```
### Automation tools
- Nagios -> monitoring and alerting
- Prometheus -> metrics collection
- Zabbix -> enterprise monitoring
- systemd timers -> scheduled checks
### Best practices
- Monitor critical services continuously
- Configure automatic restart for failed services
- Use centralized logging
- Set up alerts for failures
- Monitor both service status and performance
### Notes
- A service may be "running" but not healthy -> require deeper checks
- Combine multiple monitoring methods (status + logs + ports)
- systemd is standard in most modern Linux systems
### Common pitfalls
- Only checking service status without logs
- Not setting alerts -> delayed response
- Ignoring resource usage (CPU, memory)
- Monitoring too many non-critical services
### Real-world scenario
1. Admin monitors web server using `sytemctl status`
2. Detects service failure (inactive/failed)
3. Checks logs using `journalctl`
4. Restarts service and verifies port is listening
5. Configures monitoring tool to alert if service fails again
---
## Data acquisition methods
### What it is
Techniques used to collect system and service data for monitoring, analysis, and troubleshooting.
### Purpose
- Gather system performance metrics
- Detect issues and anomalies
- Provide data for alerts and reporting
- Support troubleshooting and capacity planning
### Types of data collected
- CPU usage
- Memory usage
- Disk I/O and storage
- Network activity
- Service status and logs
### Common data acquisition methods
#### 1. Polling
- Regularly checks system metrics at intervals
```bash
top
vmstat 5
iostat 5
```
- Example: check CPU usage every 5 seconds
#### 2. Event-drive (push-based)
- System generates events when changes occur
```bash
journalctl -f
```
- Example: log entries generated on service failure
#### 3. Agent-based monitoring
- Installed agents collect and send data to central system
- Examples:
  - Zabbix agent
  - Prometheus node exporter
#### 4. Agentless monitoring
- Uses protocols like SSH, SNMP to collect data remotely
```bash
ssh user@server "uptime"
```
#### 5. Log-based monitoring
- Analyzes system and application logs
```bash
tail -f /var/log/syslog
grep "error" /var/log/auth.log
```
#### 6. Metrics collection tools
```bash
free -h
df -h
uptime
```
- Provide snapshot of system state
### Tools
```bash
# CPU and memory
top
htop

# disk usage
df -h

# memory
free -h

# network
ss -s
```
### Best practices
- Combine multiple methods (polling + logs + events)
- Set appropriate polling intervals (avoid overload)
- Centralize data collection for analysis
- Use automation tools for large environments
- Monitor both real-time and historical data
### Notes
- Polling is simple but may miss sudden events
- Event-driven is efficient but depends on proper logging
- Agents provide detailed metrics but add overhead
- Agentless is simpler but less detailed
### Common pitfalls
- Polling too frequently -> system overhead
- Missing critical logs -> incomplete monitoring
- Relying on only one method
- Not storing historical data for analysis
### Real-world scenario
1. Admin collects system metrics using polling tools (`top`, `vmstat`)
2. Monitors logs for errors using `journalctl`
3. Uses agent-based tool to send metrics to central server
4. Combines data to troubleshoot performance issues
---
## Configurations
### What it is
The setup and customization of monitoring tools, services, and parameters to ensure effective system observation and alerting.
### Purpose
- Define what to monitor and how
- Set thresholds and alerts
- Ensure accurate and consistent monitoring
- Enable automated responses to issues
### Key configuration areas
- Services -> which services to monitor
- Metrics -> CPU, memory, disk, network
- Logs -> system and application logs
- Alerts -> triggers and notification methods
- Intervals -> how often data is collected
### systemd service configuration
```bash
systemctl enable nginx
systemctl start nginx
systemctl status nginx
```
#### Auto-restart on failure
```bash
systemctl edit nginx
```
#### Example override:
```INI
[Service]
Restart=always
```
### Logging configuration
#### journalctl (systemd logs)
```bash
journalctl -u nginx
journalctl -f
```
#### rsyslog configuration file
```bash
/etc/rsyslog.conf
```
- Controls where logs are stored and forwarded
### Monitoring thresholds
- Examples:
  - CPU > 80%
  - Disk usage > 90%
  - Memory usage > 85%
- Used to trigger alerts or actions
### Scheduling monitoring tasks
#### cron jobs
```bash
crontab -e
```
#### Example:
```bash
*/5 * * * * /usr/local/bin/check_service.sh
```
### Network/service checks
```bash
ss -tulnp
ping -c 4 host
```
### Monitoring tools configuration
- Nagios -> define hosts, services, thresholds
- Prometheus -> configure scrape targets
- Zabbix -> define items, triggers, actions
### Alert configuration
- Email notifications
- SMS alerts
- Dashboard alerts
#### Example concept:
- If service down -> send alert
- If CPU high -> notify admin
### Tools
```bash
# check services
systemctl list-units --type=service

# disk monitoring
df -h

# memory monitoring
free -h

# logs
journalctl -xe
```
### Best practices
- Monitor critical services and resources
- Set realistic thresholds (avoid alert fatigue)
- Use centralized logging and monitoring
- Enable automatic recovery where possible
- Regularly review and update configurations
### Notes
- Poor configuration leads to missed issues or too many alerts
- Monitoring should be proactive, not reactive
- Combine logs, metrics, and service checks
### Common pitfalls
- Incorrect thresholds -> too many or too few alerts
- Not enabling logging or monitoring for key services
- Ignoring alerts
- Lack of testing for monitoring setup
### Real-world scenario
1. Admin configures monitoring for web server and database
2. Sets CPU and disk usage thresholds
3. Enables auto-restart for critical services
4. Configures alerts via email
5. System notifies admin immediately when service fails
---
