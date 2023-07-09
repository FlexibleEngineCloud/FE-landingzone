#!/bin/bash
# Install ICAgent client on Hosts to collect and send logs to LTS
# Run this script on hosts.
# You can either set AK/SK or using IAM Agency. more details, https://docs.prod-cloud-ocb.orange-business.com/fr-fr/usermanual/lts/lts_03_0002.html

ak="AK_HERE"
sk="SK_HERE"
projectid="XXXXXXXXXXXX"
region="eu-west-0"

command="curl http://icagent-eu-west-0.oss.eu-west-0.prod-cloud-ocb.orange-business.com/ICAgent_linux/apm_agent_install.sh > apm_agent_install.sh && REGION=eu-west-0 bash apm_agent_install.sh -ak $ak -sk $sk -region $region -projectid $projectid -accessip 100.125.0.94 -obsdomain oss.eu-west-0.prod-cloud-ocb.orange-business.com"

# Run the command
$command