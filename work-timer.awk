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
    if (ARGC != 2) {
            print "Usage information: blah blah blah, boring "
            exit 1
        }
    # parse the command line options.
    if (ARGV[1] == "start") {
            print "Starting the clock for today."
            # Check if the log-file is present.
            logf = ENVIRON["WORK_LOG_FILE"]
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
            cmd = sprintf("echo \"$(date -R) # working\" >> %s", logf)
            print cmd
            system(cmd)

            exit 0
        }
    if (ARGV[1] == "stop") {
            # Make sure that the time has been started (TODO)
            print "Stopping the clock for today"
            exit 0
        }
    if (ARGV[1] == "stats") {
            print "No stats implemented thus far"
            exit 1
        }
    exit 1
}

function startready() {
    # Use a '#' as the seperator for each line, denoting the
    # end of a datetime, and the start of the metadata.

    # system('FS="#" awk -f ')

}
