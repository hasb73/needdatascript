#!/bin/bash


#author: hasan.b


#########Archive utility function#############

function archive_util () {

echo -e  "\n\n*******WELCOME TO ARCHIVE UTILITY***************\n\n"
echo -e  "The contents of \e[96m/abusedatathree/$DOMAIN\e[0m are as follows\n$(ls -ltrh /abusedatathree/$DOMAIN)\n"
read -p "Create an archive of /abusedatathree/${DOMAIN}: y/n " ARCHIVERESP
  

case $ARCHIVERESP in 

  [yY] )

create_archive
   
   ;;

  [nN] )

echo "*********GOODBYE***********"
exit 1

 ;;

 *)

  #####CASE:invalid #################


echo "Invalid response"
exit 1

;;

esac

}

##########Archive zip/download function###########

function create_archive () {


  echo "Creating Archive. . . . . . . . "

tar -czf ${DOMAIN}.tar.gz /abusedatathree/$DOMAIN>/dev/null 2>&1
cp -r ${DOMAIN}.tar.gz /var/www/html

IP=$(hostname -i)

sleep 1s

CURLRES="$(curl -s -o /dev/null -w "%{http_code}" http://$IP/${DOMAIN}.tar.gz)"

echo "HTTP status code is $CURLRES"

if [[ $CURLRES -eq 200 ]]

then

echo -e "Downloadable Link is: \e[32mhttp://$IP/${DOMAIN}.tar.gz\e[0m\n\n\e[96mPlease download to your PC and delete the zip file from /var/www/html/\n\n\e[0m"

else

  echo -e "\ndownloadable link from /var/www/html could not be created.\nPlease Delete the zip file from /var/www/html/\nData is generated under \e[32m/abusedatathree\${DOMAIN}.tar.gz\e[0m"

fi

}

#############################Initializing########################################

read -p "Welcome!. Enter domain name: " DOMAIN

echo -e "\n\n"

mkdir -p /abusedatathree/$DOMAIN


#checking error status...

if [ $? -ne 0 ]
then
   echo -e "\e[32mUnable to create the base file\e[0m".
   exit 1

else

        echo -e "created base data directory: \e[32m/abusedatathree/$DOMAIN\e[0m"

fi

echo -e "Generating domain access logs under \e[32m/abusedatathree/$DOMAIN/domain_access\e[0m"



##################Getting Username####################################

USER=$(grep $DOMAIN /etc/userdomains | cut -d ":" -f 2 | head -n1 | awk '{ print $1}')


##################Getting Homedir####################################

HOMEDIR=$(grep "$USER:" /etc/passwd | cut -d: -f6)

sleep 1s

echo -e "username is \e[32m$USER\e[0m"


sleep 1s

echo -e  "Homedir is \e[32m$HOMEDIR\e[0m"                                                                          



##########Checking if addon or truedomain####################

grep "^$DOMAIN" /etc/domainusers>/dev/null 2>&1

if [ $? -eq 0 ]

#Truedomain? Yes....

then  #####THEN######



#######listing domlogs in homedir(main domain)

/bin/ls  $HOMEDIR/logs | /bin/grep "^$DOMAIN">homedirdomlogs.txt

 if [ -s homedirdomlogs.txt ] 

     then 

      mkdir -p /abusedatathree/$DOMAIN/domain_access
      echo "Logs found under $HOMEDIR/logs"
 
   #copying cpanel domlogs(main domain)..................................................

   for file in `cat homedirdomlogs.txt`

  do
   /bin/cp $HOMEDIR/logs/$file /abusedatathree/$DOMAIN/domain_access/

  done

     if [ $? -eq 0 ]
        then
        echo -e "logs in $HOMEDIR/logs copied to \e[32m/abusedatathree/$DOMAIN/domain_access\e[0m"
      fi

  else

     echo -e "\e[31mNo logs found in $HOMEDIR/logs\e[0m"

  fi



#######listing apache domlogs(main domain)########


   /bin/ls /var/log/apache2/domlogs | /bin/grep "^$DOMAIN">apachedomlogs.txt


     if [ -s apachedomlogs.txt ] 

     then 
      mkdir -p /abusedatathree/$DOMAIN/domain_access
      echo "Logs found under var/log/apache2/domlogs "

##########copying apache domlogs (main domain)#########

     for file in `cat apachedomlogs.txt`

     do

    cd /var/log/apache2/domlogs
   /bin/cp $file /abusedatathree/$DOMAIN/domain_access/

    done

   if [ $? -eq 0 ]

   then
        echo -e "logs in /var/log/apache2/domlogs copied to \e[32m/abusedatathree/$DOMAIN/domain_access\e[0m"
   fi


 else

      echo -e "\e[31mNo logs found under var/log/apache2/domlogs\e[0m"   

fi

cd ~

  else  ###########ELSE################

    #Not a truedomain...its an addon

    SUBDOMAIN=$(grep $DOMAIN /var/cpanel/userdata/$USER/main | cut -d ":" -f2 | awk '{print $1}')

    echo -e "domain is a addon with subdomain: \e[32m$SUBDOMAIN\e[0m"


    ########listing logs in homedir(addon)###################

    /bin/ls  $HOMEDIR/logs | /bin/grep "^$SUBDOMAIN">homedirdomlogs.txt


     if [ -s homedirdomlogs.txt ] 

     then 
      mkdir -p /abusedatathree/$DOMAIN/domain_access
      echo "Logs found under $HOMEDIR/logs"

      #copying homedir domlogs(addon)..................................................


        for file in `cat homedirdomlogs.txt`

        do
         
         /bin/cp $HOMEDIR/logs/$file /abusedatathree/$DOMAIN/domain_access/

        done

         if [ $? -eq 0 ]
           then
            echo -e  "logs in $HOMEDIR/logs copied to \e[32m/abusedatathree/$DOMAIN/domain_access\e[0m"
         fi

      else

      echo -e "\e[31mNo logs found under $HOMEDIR/logs\e[0m "

     fi


  ###Listing Apache Logs(addon)

    /bin/ls /var/log/apache2/domlogs | /bin/grep "^$SUBDOMAIN">apachedomlogs.txt


     if [ -s apachedomlogs.txt ] 

     then 
      mkdir -p /abusedatathree/$DOMAIN/domain_access
      echo "Logs found under var/log/apache2/domlogs"

  #copying apache domlogs (addon)

     for file in `cat apachedomlogs.txt`

     do

    cd /var/log/apache2/domlogs
   /bin/cp $file /abusedatathree/$DOMAIN/domain_access/

    done

   if [ $? -eq 0 ]
   then
        echo -e "logs in /var/log/apache2/domlogs copied to \e[32m/abusedatathree/$DOMAIN/domain_access\e[0m"
   fi


    else

      echo -e "\e[31mNo logs found under var/log/apache2/domlogs\e[0m "   

  fi



fi  #FINISSSHHHHH

cd ~





#SSH logs:########################################################################


echo -e "\n\n*********Generating SSH logs*********"

/bin/grep "Accepted password for $USER from" /var/log/secure>sshlog.txt

if [ $? -eq 0 ]
   then
        echo "SSH logs found in /var/log/secure"

   else  
  echo -e "\e[31mNo ssh logs found in /var/log/secure\e[0m"
fi


echo "Searching archives of /var/log/secure*.gz"
/usr/bin/zgrep "Accepted password for $USER from" /var/log/secure*.gz>>sshlog.txt

 
if [ -s sshlog.txt ] 

then

  mkdir -p /abusedatathree/$DOMAIN/SSH_logs/
  echo -e "Copying ssh logs to \e[32m/abusedatathree/$DOMAIN/SSH_logs/\e[0m"
 /bin/cp -r  sshlog.txt /abusedatathree/$DOMAIN/SSH_logs/

else
echo -e "\e[31mNo ssh logs found for $USER on the server\e[0m"
fi 







#FTP Logs######################################################################


echo -e  "\n\n*********Generating FTP logs*********" 

echo -e "Generating FTP logs under: \e[32m/abusedatathree/$DOMAIN/FTP_logs/\e[0m"

/bin/egrep "$USER|$DOMAIN" /var/log/messages | grep ftp >ftplogs.txt

if [ $? -eq 0 ]
   then
        echo "FTP logs found in /var/log/messages"

   else  
  echo -e "\e[31mNo FTP logs found in /var/log/messages.\e[0m"
fi

echo "Searching archives of /var/log/messages-*"
/usr/bin/zgrep "$USER\|$DOMAIN" /var/log/messages*.gz | grep ftp>>ftplogs.txt

if [ -s ftplogs.txt ] 
then

 mkdir -p /abusedatathree/$DOMAIN/FTP_logs/
 echo -e "Copying FTP logs to \e[32m/abusedatathree/$DOMAIN/FTP_logs/\e[0m"
 /bin/cp -r  ftplogs.txt /abusedatathree/$DOMAIN/FTP_logs/

else
echo -e  "\e[31mNo FTP logs found for $DOMAIN on the server\e[0m"
fi 





#EXIM LOGS###############################################################################


echo -e "\n\n*********Generating EXIM Logs*********"

mkdir -p /abusedatathree/$DOMAIN/emaillogs/

/bin/grep $DOMAIN /var/log/exim_mainlog>email_log.txt

if [ $? -eq 0 ]
   then
        echo "email logs found in /var/log/exim_mainlog"

   else  
  echo -e "\e[31mNo logs found in exim_mainlog..\e[0m"
fi

echo "Checking exim_mainlog archives.."

/usr/bin/zgrep $DOMAIN /var/log/exim_mainlog*.gz>>email_log.txt


if [ -s email_log.txt ] 
then

echo -e "Copying Email logs to \e[32m/abusedatathree/$DOMAIN/emaillogs\e[0m"
 /bin/cp -r email_log.txt  /abusedatathree/$DOMAIN/emaillogs

else
echo -e "\e[31mNo exim logs found for $DOMAIN on the server \e[0m"
fi











#MAIL ACCESS (POP3/IMAP/Localhost)#########################################################


echo -e  "\n\n*********Generating Mail Access(login) Logs*********"

echo -e "Generating Mail Access logs under: \e[32m/abusedatathree/$DOMAIN/mail_access/"

/bin/grep $DOMAIN /var/log/maillog| grep login>mail_access.txt;

if [ $? -eq 0 ]
   then
        echo "mail access logs found in /var/log/maillog"

   else  
  echo -e "\e[31mNo logs found in /var/log/maillog\e[0m"
fi


echo "Searching maillog Archives"

/usr/bin/zgrep $DOMAIN /var/log/maillog*.gz | grep login*>>mail_access.txt


if [ -s mail_access.txt ] 

then

mkdir -p /abusedatathree/$DOMAIN/mail_access
echo -e "Copying Email logs to \e[32m/abusedatathree/$DOMAIN/mail_access\e[0m"
/bin/cp -r mail_access.txt  /abusedatathree/$DOMAIN/mail_access

else
echo -e "\e[31mNo mail-access logs found for $DOMAIN on the server \e[0m"
fi




###########Mailbox generation!###########

echo -e "\n\n**********Mailbox Generation*****************\n"

read -p "Mailbox required for $DOMAIN?: y/n: " RESPMBOX


case "$RESPMBOX" in
#####CASE:y #################

   [nN] )

    echo -e "\nAlright.Moving forward to Database generation utility\n"

    ;;

   [yY] ) 
   
    ls $HOMEDIR/mail/$DOMAIN>/dev/null 2>&1

    if [ $? -ne 0 ]

      then

     	echo "Mailfolder not found for $DOMAIN"
      
      sleep 1s

      else

      	LISTMBOX=$(ls $HOMEDIR/mail/$DOMAIN)

      	if [ -z "$LISTMBOX" ]

      	then

      	   echo "No mailboxes under $HOMEDIR/mail/$DOMAIN"
           
           sleep 1s

           else

      	 echo -e "Mailboxes for $DOMAIN are as listed\n\n$LISTMBOX"
         mkdir -p /abusedatathree/$DOMAIN/mailbox
         echo -e "Copying mailboxes to \e[32m/abusedatathree/$DOMAIN/mailbox\e[0m"
         cp -r $HOMEDIR/mail/$DOMAIN/*  /abusedatathree/$DOMAIN/mailbox
       
      fi

    fi  

      ;;
esac




############DATABASE GENERATION UTILITY##########################################################





############INITIALIZING##############

echo -e  "\n\n*************Welcome to Database Dump Generation utility*************"



#list of databases.............................


ALLDB=$(ls /var/lib/mysql | grep $USER)

if [ -z "$ALLDB" ]

then  

  echo -e "\e[31mNo active databases found for $USER\e[0m"

else

echo -e "The databases associated with the user are\n$ALLDB\n"

read -p "All databases required?: y/n: " RESPONSE


case "$RESPONSE" in

#####CASE:y #################

[yY] )

  echo "Generating archive of all databases:"

  mkdir -p /abusedatathree/$DOMAIN/databases

echo "$ALLDB">dblist.txt

for db in $(cat dblist.txt)

   do
    
    mysqldump $db>$db.sql
    zip ${db}.sql.zip ${db}.sql
    cp -r ${db}.sql.zip /abusedatathree/$DOMAIN/databases/

  if [ $? -eq 0 ]
   then
        echo -e "DB dump generated for ${db}.sql.zip under \e[32m/abusedatathree/$DOMAIN/databases/\e[0m"
        
  else  

  echo -e "\e[31mFailed to create DB dump for $db\e[0m."
  fi

done

;;

  #####CASE:n #################


[nN] )


read -p "mention databases associated with the domain, seperated by space(press enter for no selection): " CHOSENDB


mkdir -p /abusedatathree/$DOMAIN/databases

echo "$CHOSENDB">dblist.txt

for db in $(cat dblist.txt)

 do
    
    mysqldump $db>$db.sql
    zip ${db}.sql.zip ${db}.sql
    cp -r ${db}.sql.zip /abusedatathree/$DOMAIN/databases/


   if [ $? -eq 0 ]

   then
        echo -e "DB dump generated for ${db}.sql.zip under \e[32m/abusedatathree/$DOMAIN/databases/\e[0m"
   else  

      echo -e "\e[31mFailed to create DB dump $db.\e[0m"

   fi

 done

;;


#####CASE:invalid #################

*)



echo "Invalid response"

;;

esac

fi


################DATACYCLEBACKUPS#################################################


echo -e "\n\n"

read -p "Check for datacycle backups?: y/n " REPLY

case "$REPLY" in


[nN] )  #NO

echo  "Going to Archive utility"

archive_util

exit 1

;;




########case-check#####################################

[yY] )   #YES

#######check-server on datacycle?#####################

   sshrestore>/dev/null 2>&1

    if [ $? -ne 0 ]

      then

       echo "\e[31mDatacycle Unavailable\e[0m"
       echo  -e "\n\nGoing to Archive utility"


       archive_util

       exit 1

      else

      echo -e "\e[32mDatacycle Available\e[0m\nCreating datacycle archives under \e[32m/abusedatathree/$DOMAIN/databases/backupDB\e[0m\n"

      ls /backup/cpbackup/*/$USER/mysql | grep ".sql" | grep -v "daily\|monthly\|weekly\|seed" | sort | uniq | sed 's/.sql//g'>dbdc.txt

       DBDC=$(cat dbdc.txt)

       if [ -z "$DBDC" ]

         then 
         echo -e "\e[31mNo databases found for $USER in datacycle\e[0m in"
  
         else 

   #################################BACKUP DC START############################################
         echo -e "The databases in datacycle backup are are\n$DBDC\n"
 
         read -p "All above datacycle databases required?: y/n: " RESPDBDC

         case "$RESPONSE" in

#####CASE:y #################

          [yY] )

           echo "*****Generating archive of all the user's databases in datacycle******:"

           mkdir -p /abusedatathree/$DOMAIN/databases/backupDB


           for db in $(cat dbdc.txt)

            do 

    ###########DAILY_ALLDBDC########################

              cp -a  /backup/cpbackup/daily/$USER/mysql/${db}.sql "/abusedatathree/$DOMAIN/databases/backupDB/$db.$(stat /backup/cpbackup/daily/$USER/mysql/${db}.sql  | grep Modify  |  awk '{print $2}')-daily.sql"



                 if [ $? -eq 0 ]

                    then

                   echo "Copied Daily backup for $db"

                    else

                    echo "Could not copy Daily backup for $db. It may not exist or copy failed"

                  fi

             done



#########WEEKLY_ALLDBDC#######################################

              for db in $(cat dbdc.txt)

                do 

                   cp -a  /backup/cpbackup/weekly/$USER/mysql/${db}.sql "/abusedatathree/$DOMAIN/databases/backupDB/$db.$(stat /backup/cpbackup/weekly/$USER/mysql/${db}.sql  | grep Modify  |  awk '{print $2}')-weekly.sql"

                 if [ $? -eq 0 ]

                 then

                  echo "Copied Weekly backup for $db"

                 else

                 echo "Could not copy Weekly backup for $db. It may not exist or copy failed"

                fi
             
              done



###########MONTHLY_ALLDBDC##############################################

               for db in $(cat dbdc.txt)

                 do 

                  cp -a  /backup/cpbackup/monthly/$USER/mysql/${db}.sql "/abusedatathree/$DOMAIN/databases/backupDB/$db.$(stat /backup/cpbackup/monthly/$USER/mysql/${db}.sql  | grep Modify  |  awk '{print $2}')-monthly.sql"

                 if [ $? -eq 0 ]

                 then

                echo "Copied Monthly backup for $db"

                else

               echo "Could not copy Monthly backup for $db. It may not exist or copy failed"

             fi

           done

           ;;
          
          [nN] )
           

           read -p "mention databases from the above list seperated by space.(press enter for no selection): " SELDBDC
            
           mkdir -p /abusedatathree/$DOMAIN/databases/backupDB

           echo "$SELDBDC">selectdbdc.txt



           for db in $(cat selectdbdc.txt)

            do 

    ###########DAILY_SELDBDC########################

              cp -a  /backup/cpbackup/daily/$USER/mysql/${db}.sql "/abusedatathree/$DOMAIN/databases/backupDB/$db.$(stat /backup/cpbackup/daily/$USER/mysql/${db}.sql  | grep Modify  |  awk '{print $2}')-daily.sql"



                 if [ $? -eq 0 ]

                    then

                   echo "Copied Daily backup for $db"

                    else

                    echo "Could not copy Daily backup for $db. It may not exist or copy failed"

                  fi

             done



#########WEEKLY_SELDBDC#######################################

              for db in $(cat selectdbdc.txt)

                do 

                   cp -a  /backup/cpbackup/weekly/$USER/mysql/${db}.sql "/abusedatathree/$DOMAIN/databases/backupDB/$db.$(stat /backup/cpbackup/weekly/$USER/mysql/${db}.sql  | grep Modify  |  awk '{print $2}')-weekly.sql"

                 if [ $? -eq 0 ]

                 then

                  echo "Copied Weekly backup for $db"

                 else

                 echo "Could not copy Weekly backup for $db. It may not exist or copy failed"

                fi
             
              done



###########MONTHLY_SELDBDC##############################################

               for db in $(cat selectdbdc.txt)

                 do 

                  cp -a  /backup/cpbackup/monthly/$USER/mysql/${db}.sql "/abusedatathree/$DOMAIN/databases/backupDB/$db.$(stat /backup/cpbackup/monthly/$USER/mysql/${db}.sql  | grep Modify  |  awk '{print $2}')-monthly.sql"

                 if [ $? -eq 0 ]

                 then

                echo "Copied Monthly backup for $db"

                else

                echo "Could not copy Monthly backup for $db. It may not exist or copy failed"

               fi

              done

           ;;

        esac

      fi

    fi

  esac


    

#############Calling Archive#####################

echo -e "\ncalling archive utility\n"

archive_util
