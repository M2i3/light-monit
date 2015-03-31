# light-monit
A very light process monitoring utility (entirely in bash). 


It will send notification on stage changes for the process being monitored.

## Triggering the utility

The utility is triggered through CRON, preferably every 1 minutes. So add the following to your root crontab.

* *  *   *   *     light-monit  > /dev/null 2>&1

## Configuring the utility

All configuration takes place in the /etc/light-monit folder

In there you will find three sub-folders

**./notifiers.d/** The list of notifiers currently configured and available. These are bash script to send the notifications. One is predefined to add the entries to the syslog.

**./processes.d/** The list of processes to monitor. These are configuration files with the checks to perform. Each process to monitor will identify one of many notifiers and a single check to utilize
  
**./checks.d/** The list of checks to be performed. Each process can return one of three values: 
  * running: the process is live and running
  * dead: the process should be running but it not
  * not-running: the process is not running and is not expected to be running
  



