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

Based on the above data, the script then generates a base directory(*/needdatadump/domain_name*) where all susbsequent logs and DB will be stored.

**Domain acces**

Domain access logs are stored at 2 locations on the server:

1. Homedir/logs(archived and current)
2. /var/log/apache/domlogs(recent)

The script will copy the logs for in those locations to a domain_access folder in the base directory created earlier.

**FTP**

The script searches FTP logs and its archives with username and domain. In case no logs are found, a message will be displayed.It will copy the retrieved logs under /basedir/FTP_logs

**SSH**

The script searches SSH logs under /var/log/secure and its archives with username. In case no logs are found, a message will be displayed. It will copy the retrieved logs under /basedir/ssh_logs

**Exim (email)**

The script searches exim_mainlog and its archives with the domain name. In case no logs are found, a message will be displayed.It will copy the retrieved logs under /basedir/email_logs

**Mail access**(imap/pop/webmail-localhost)

The script searches maillog and its archives with the domain name. In case no logs are found, a message will be displayed.It will copy the retrieved logs under /basedir/mail_access

**Mailbox**:

The script will list mailboxes for a domain as under /homedir/mail/domain. If mailboxes are available, they will be copied to /basedir/mailbox

**Databases**

The Workflow is as follows:

-The script lists databases for the user
-Provides an option to generate a zip dump of all or chosen databases.
-Generates zip dump of the databases under /basedir/databases

**Datacycle DB**

Abuse team mentionds that they need backup DB as well. Here the script scans through datacycle mysql backups

-Checks if datacycle is active on the server
-Checks for databases present in datacycle mount
-Provides an option to generate a zip dump of all or chosen databases.
-Copies the daily/weekly/monthly db to /basedir/databases/backupDB

**Archive Utility**

The function is defined at the beginning of the script and has 2 roles:
1. Create a .tar.gz archive or /basedir
2. Create a downloadable link by copying the archive to /var/www/html directory of the server

Note: On Cloud and Rock servers, the downloadable link gives a 302 redirect to a 404.html page. 

Please revert for any bugs or suggestions
