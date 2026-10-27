# Linux Cron Jobs

## Common

```bash
crontab -l                         # list my jobs
crontab -e                         # edit my jobs
sudo crontab -u alice -l           # another user's jobs
# m  h  dom mon dow  command
*/5 *  *   *   *    /usr/local/bin/check.sh >> /var/log/check.log 2>&1
0   2  *   *   *    /usr/local/bin/backup.sh
journalctl -u cron                 # Ubuntu (RHEL: -u crond)
```

## Gotchas

- Cron runs with a minimal PATH. Use absolute paths in commands and scripts.
- `%` is special in crontab lines. Escape it as `\%`, for example in `date +\%F`.
- Output is mailed or lost unless you redirect it.

---

## What is Cron?

`cron` is a Linux service used to automatically run commands or scripts at scheduled times.

Common uses include:
- Backups
- Log cleanup
- Database maintenance
- Security scans
- Data updates
- Running scripts automatically
- Sending reports

The background service is usually called:
```bash
cron

# or on some distributions

crond
```

---

## Cron Components

|Component|Purpose|
|---|---|
|`cron`/`crond`|Background daemon that executes scheduled jobs|
|`crontab`|Command used to manage user cron jobs|
|`/etc/crontab`|System-wide cron configuration|
|`/etc/cron.d`/|Directory containing additional system cron files|
|`/etc/cron.daily/`|Scripts run daily|
|`/etc/cron.weekly/`|Scripts run weekly|
|`/etc/cron.monthly/`|Scripts run monthly|
|`/etc/cron.hourly/`|Scripts run hourly|

---

## Check Cron Service

### Ubuntu / Debian

```bash
systemctl status cron           # check

sudo systemctl start cron       # start

sudo systemctl enable cron      # enable

sudo systemctl restart cron     # restart
```

---

### RHEL / Rocky / AlmaLinux

The service is normally called: `crond`

```bash
systemctl status crond          # check

sudo systemctl start crond      # start

sudo systemctl enable crond     # enable
```

---

## `crontab` Command

The `crontab` command manages scheduled jobs belonging to individual users.

```bash
cron -l         # View Your Cron Jobs

crontab -e      # Edit Your Cron Jobs

crontab -r      # removes the entire crontab without opening an editor

crontab -i -r   # request confirmation first

# Managing Another User's Crontab
# Root can manage another user's cron jobs
sudo crontab -u username -l     # view

sudo crontab -u username -e     # edit
```

---

## Cron Syntax

A normal user crontab contains **5 scheduling fields followed by the command**.
```
┌───────────── Minute (0-59)
|┌───────────── Hour (0-23)
||┌───────────── Day of month (1-31)
|||┌───────────── Month (1-12)
||||┌───────────── Day of week (0-7)
|||||
***** command
```

The five fields are:
```
Minute Hour Day-of-Month Month Day-of-Week
```

---

### Day of Week

|Value|Day|
|---|---|
|`0`|Sunday|
|`1`|Monday|
|`2`|Tuesday|
|`3`|Wednesday|
|`4`|Thursday|
|`5`|Friday|
|`6`|Saturday|
|`7`|Sunday|

---

### Basic Example

Run a script every day at 5:00 AM:
```
0 5 * * * /home/hanlong/scripts/backup.sh
```

Breakdown:
|Field|Value|Meaning|
|---|---|---|
|Minute|`0`|Minute 00|
|Hour|`5`|05:00|
|Day|`*`|Every day|
|Month|`*`|Every month|
|Weekday|`*`|`Every weekday|

Result:
```
Every day at 05:00
```

---

### Special Characters

`*` - Every Value

```
* * * * * command
```

Runs every minute.

`,` - Multiple Values

```
0 8,12,18 * * * command
```

Runs every day at:
```
08:00
12:00
18:00
```

`-` - Range

```
0 9 * * 1-5 command
```

Runs:
```
Monday-Friday at 09:00
```

`/` - Step / Interval

```
*/15 * * * * command
```

Runs every 15 minutes:

```
00
15
30
45
```

---

## Special Cron Keywords

Cron supports keywords instead of the normal five scheduling fields.

|Keyword|Equivalent|
|---|---|
|`@reboot`|Run when cron starts after boot|
|`@yearly`|`0 0 1 1 *`|
|`@annually`|`0 0 1 1 *`|
|`@monthly`|`0 0 1 * *`|
|`@weekly`|`0 0 * * 0`|
|`@daily`|`0 0 * * *`|
|`@midnight`|`0 0 * * *`|
|`@hourly`|`0 * * * *`|

Example:
```bash
@reboot /home/user/start-app.sh
```

---

## Redirecting Cron Output

Cron jobs may generate standard output and standard error.

Redirect output to a log file:
```bash
0 5 * * * /home/user/backup.sh >> /home/user/backup.log 2>&1
```

Explanation:
```
>>      ->  Appends stdout to the file.

2>&1    -> Redirects stderr to the same destination as stdout.
```

## Discarding Output

If no output is required:
```bash
0 5 * * * /home/user/script.sh > /dev/null 2>&1
```

`/dev/null` discards the output.

---

## Environment Variables

Cron runs with a more limited environment than an interactive shell.

A command that works manually therefore fail when run by cron.

For example, define `PATH` inside the crontab:
```bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```
Then add the job:
```bash
0 5 * * * /home/user/script.sh
```

---

## Use Absolute Paths

Use:
```bash
0 5 * * * /usr/bin/python3 /home/user/scripts/script.py
```

---

## Script Permissions

```bash
ls -l script.sh     # check permissions

chmod +x script.sh  # make the script executable
```

---

## `/etc/crontab`

The system-wide crontab is: `/etc/crontab`

View it: `cat /etc/crontab`

Unlike a user's crontab, `/etc/crontab` has an additional **user field**.

Syntax:
```
minute hour day month weekday user command

# Example
0 5 * * * root /usr/local/bin/backup.sh
```

Here: `root` specifies which user runs the command.

Additional system cron files may be placed in: `/etc/cron.d/`.

They normally use the same format as `/etc/crontab`.

---

## Cron Access Control

Cron access can be controlled with `/etc/cron.allow` and `/etc/cron.deny`.

If `/etc/cron.allow` exists, only users listed in it are allowed to use `crontab`.

Users listed in `/etc/cron.deny` are denied access to `crontab`.

---

## Cron Logs

### Debian / Ubuntu

```bash
# Cron activity may appear in:
/var/log/syslog

# Search for cron entries:
sudo grep CRON /var/log/syslog

# Follow the log:
sudo tail -f /var/log/syslog
```

### RHEL-Based Systems

```bash
# Cron logs are commonly stored in
/var/log/cron

# View:
sudo cat /var/log/cron

# Follow:
sudo tail -f /var/log/cron
```

---

## Using journalctl

Because cron runs as a systemd-managed service on managed systems, its logs can also be viewed with `journalctl`.

```bash
# Ubuntu
journalctl -u cron

# RHEL
journalctl -u crond
```

## Troubleshooting Cron Jobs

If a cron job does not run, check the following:
```bash
# 1. Check the service
## Ubuntu
systemctl status cron

## RHEL
systmctl status crond

# 2. Check the Crontab
crontab -l

# 3. Run the Script Manually
/home/user/scripts/script.sh    # if the script does not work manually, it will not work through cron.

# 4. Check Execute Permission
ls -l script.sh     

# 5. Use Absolute Paths

# 6. Check File Permissions
## User running the cron job must have permission to:
# - execute the script
# - Read required files
# - Write to required files/directories
# - Access required resources

# 7. Check Logs
## Ubuntu:
grep CRON /var/log/syslog

## RHEL:
cat /var/log/cron

## Or:
journalctl -u cron
```

## See also

- [systemd](systemd.md)
- [Processes and Jobs](processes-and-jobs.md)
