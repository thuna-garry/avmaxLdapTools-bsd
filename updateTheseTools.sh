#!/bin/sh

##################################################################
# 
#
#
#
##################################################################
# modified on: 2012-03-09
# modified by: Garry Thuna
##################################################################

gtToolDir=${0%/*}

eval "`$gtToolDir/ldapConf.py \
       MASTER_FQDN            \
       SERVER_SHORT_NAME      \
       TMP_DIR                \
       DOMAIN                 \
     `"


#########################################################################
# copy scripts from master
#########################################################################

#make a quick backup in /tmp (just in case)
tar cvzf /tmp/${0##*/}_`date +%Y%m%d_%H%M`.tgz $gtToolDir

rsync -rltpgoDhv                                                       \
      -e "ssh -i /data/sambaFiles/home/updateTools/updateTools.key"    \
      --exclude 'emptyScans.sh'                                        \
      --exclude 'updateAC_Manuals.sh'                                  \
      --exclude 'ldapConf.py'                                          \
      updateTools@${MASTER_FQDN}:/data/disks/avmaxLdapTools            \
      /data/disks	

#########################################################################
# repair the shortname in the ldapConf file with that of this server
#########################################################################

shortName=`hostname | sed "s/\.$DOMAIN//"`
sed -i "s/^SERVER_SHORT_NAME.*$/SERVER_SHORT_NAME = '$shortName'/"  $gtToolDir/ldapConf.py

