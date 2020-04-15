# needdatascript
Need data script

Welcome!

This is an interactive bash script that generates the below logs for cpanel based servers:

1.Domain access logs
2.FTP logs
3.SSH logs
4.Exim logs
5.Mail access(IMAP/POP/localhost-webmail) logs
6.Mailbox
7.Databases, current and backup(from datacycle)

Workflow:

The script asks a user for a Domain. Then determines the following details and stores it in variables:

1. Username
2. Homedirectory path
3. Checks if the domain is an addon or subdomain

Based on the above data, the scrit then generates a base directory when all susbsequent logs and DB will be stored.

Domain access:

Domain access logs are stored at 2 locations on the server:

1. Homedir/logs(archived and current)
2. /var/log/apache/domlogs(recent)

The script will copy the logs for in those locations to a domain_access folder in the base directory created earlier.

FTP:

The script searches FTP logs and its archives with username and domain. In case no logs are found, a message will be displayed.It will copy the retrieved logs under /basedir/FTP_logs

SSH:

The script searches SSH logs under /var/log/secure and its archives with username. In case no logs are found, a message will be displayed. It will copy the retrieved logs under /basedir/ssh_logs

Exim (email)

The script searches exim_mainlog and its archives with the domain name. In case no logs are found, a message will be displayed.


