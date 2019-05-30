# README

## Work-Timer

Work timer is a simple awk-script for keeping track of overtime at work.

### Usage
Usage can be found running awk -f work-timer.awk

### Storage-Format
The hours worked are stored in the .log.work file, and is simply storing the
output of the systems date command, along with a seperator '?' and following metadata,
most notably the info of whether the line is a login, or a logout.

