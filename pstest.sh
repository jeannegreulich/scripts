#!/bin/bash
#
# This command will check if puppet is running before changing the status of the service.
# You can't disable the puppet service from inside a puppet run.
# See https://tickets.puppetlabs.com/browse/PUP-1320 for more information
#

PATH="/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin";

#puppet_run_lockfile="$(puppet config print agent_catalog_run_lockfile)";
puppet_run_lockfile="/tmp/pstest";

# wait for any current puppet run to finish
countdown=120
while [ -f ${puppet_run_lockfile} -a $countdown -gt 0 ]; do
 /bin/sleep 5
 ((countdown--))
done

if [ $countdown -gt 0 ]; then
  puppet resource service puppet enable=false ensure=false 2>&1 > /dev/null
else
  /bin/logger -s -p 'local6.warn' -t 'puppet' "$0 :Script could not stop puppet service.  Lock file, ${puppet_run_lockfile},  remained longer than 10 minutes."
fi
