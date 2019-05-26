# work-timer.awk is a simple script for keeping track of the hours worked.
#
# Usage:
# work-timer [start|stop|stats]
#
# File-format
# The tool reads and collects work information in a text-file of the following format.
#
# datetime [hours-worked|in-progress]

# date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s" // Handy for calculating time differences.

# Return codes:
# 0 - Success
# 1 - Error

BEGIN {
    print ARGC
    print length(ARGV[1])
    print length(ENVIRON["WORK_LOG_FILE"])
    # logf = ENVIRON["WORK_LOG_FILE"]
    logf =ARGV[1]
    if (length(cliarg) == 0) {
            print "Usage information: blah blah blah, boring "
            exit 1
        }
    # parse the command line options.
    if (cliarg == "start") {
            print "Starting the clock for today."
            # Check if the log-file is present.
            if (length(logf) == 0) {
                print "Please set the WORK_LOG_FILE variable"
                exit 1
            }
            # Check that the time has not been finished previously.
            while ((getline fline < logf)) {}

            print "The line: " fline

            if (match(fline, "working")) {
                print "Cannot start another working session while one is open"
                print "Please check your log file."
                exit 1
            }

            # Start the working day \o/
            # str = sprintf("")
            tformat = "%h:%s"
            cmd = sprintf("echo \"$(date) ? working\" >> %s", logf)
            print cmd
            system(cmd)

            exit 0
        }
    if (cliarg == "stop") {
        # Make sure that the time has been started (TODO)
        # Check that the time has not been finished previously.
        while ((getline fline < logf)) {}
        print fline
        if (match(fline, "working") == 0) {
            print "Cannot stop the time, when it has not been started."
            print "usage string. blah blah blah."
            exit 1
        }
        # if (match(fline, "done")) {
        #     print "Cannot stop the time, when it has already been stopped."
        #     print "usage string. blah blah blah."
        #     exit 1
        # }
        print "Stopping the clock for today"
        # Calculate the hours and minutes worked today
        # TODO - How to do this using the date cli tool.
        # date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s" // Handy for calculating time differences.
        cmd = sprintf("echo \"$(date) ? done\" >> %s", logf)
        print cmd
        system(cmd)
        exit 0
    }
    if (cliarg == "stats") {
        print "Sum all the hours worked"
        FS="?"
    } else {
        print "Unrecognized option"
        print "Usage string. Blah blah blah."
        exit 1
    }
}

# For all the lines, sum the hours worked.
{
    print "line: " $0
    # Sum all the hours worked
    if (match($2, "working")) {
        # Use awk's two-way IO for getting the Epoch time from the date command line utility.
        cmd =  "date -j -f \"%a %b %d %T %Z %Y\" \"`date`\" \"+%s\""  | getline resout
        print "resout " resout
        workstart = resout
        close(cmd)
        # work-start = system(date -j -f "%a %b %d %T %Z %Y" $1 "+%s") # Convert the time-string to Epoch time.
        # print systime()
        print "Working!!!"
    } else if (match($2, "done")) {
        # print systime()
        cmd =  "date -j -f \"%a %b %d %T %Z %Y\" \"`date`\" \"+%s\""  | getline resout
        print "resout " resout
        workend = resout
        close(cmd)
        print "Done for the day!!!"
        timeworked = workend - workstart
        print "The time difference is: " timeworked
        # work-end = system(date -j -f "%a %b %d %T %Z %Y" $1 "+%s") # Convert the time-string to Epoch time.
        # cmd = sprintf("echo %s - %s | bc", work-end, work-start)
        # seconds-worked = system(cmd)
        # Convert the seconds to hours.
        # cmdm = sprintf("date -j -f %s +%m")
        # cmdh = sprintf("date -j -f %s +%h")
        # hours-worked = system(cmdh)
        # minutes-worked = system(cmdm)
    } else {
        print "The log-file is corrupted. plz fix."
        exit 1
    }
}

function startready() {
    # Use a '#' as the seperator for each line, denoting the
    # end of a datetime, and the start of the metadata.

    # system('FS="#" awk -f ')

}
