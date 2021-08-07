#!/bin/bash

getModulesInfo (){

	echo "### GET MODULES INFO ###"

	regLog "OTHER" "===================================================" "$PATH_LOG"
	regLog "OTHER" "$DATE | INFO | ### GET MODULES INFO ###" "$PATH_LOG"

	makeReport

	local i=1;
	for dir in $(ls $PATH_MODULES)
	   	do
	    	moduleName=$(ls $PATH_MODULES | sed -n "$i p");

	    	entityName=$(cat ${PATH_MODULES}/$moduleName | sed -n "1 p" | cut -d'=' -f2 | sed 's/"//g')
	    	conIP=$(cat ${PATH_MODULES}/$moduleName | sed -n "2 p" | cut -d'=' -f2 | sed 's/"//g')
	    	conPort=$(cat ${PATH_MODULES}/$moduleName | sed -n "3 p" | cut -d'=' -f2 | sed 's/"//g')
	    	conUser=$(cat ${PATH_MODULES}/$moduleName | sed -n "4 p" | cut -d'=' -f2 | sed 's/"//g')
	    	conPass=$(cat ${PATH_MODULES}/$moduleName | sed -n "5 p" | cut -d'=' -f2 | sed 's/"//g')
	    	dirBackup=$(cat ${PATH_MODULES}/$moduleName | sed -n "6 p" | cut -d'=' -f2 | sed 's/"//g')

	    	echo "================="
	    	echo "MODULE: $moduleName"
	    	echo "entity: $entityName"
	    	echo "ip: $conIP"
	    	echo "port: $conPort"
	    	echo "user: $conUser"
	    	echo "password: $conPass"
	    	echo "backup directory: $dirBackup"

	    	regLog "OTHER" "$DATE | INFO | GET MODULE $moduleName" "$PATH_LOG"
	    	regLog "OTHER" "$DATE | INFO | GET entity: $entityName" "$PATH_LOG"
	    	regLog "OTHER" "$DATE | INFO | GET ip: $conIP" "$PATH_LOG"
	    	regLog "OTHER" "$DATE | INFO | GET port: $conPort" "$PATH_LOG"
	    	regLog "OTHER" "$DATE | INFO | GET user: $conUser" "$PATH_LOG"
	    	regLog "OTHER" "$DATE | INFO | GET password: $conPass" "$PATH_LOG"
	    	regLog "OTHER" "$DATE | INFO | GET backup directory: $dirBackup" "$PATH_LOG"

	    	makeFgtBackup

	     	((i=i+1))
	done
}


makeReport(){
	echo "From: Notificaciones SOC <email.mail@gmail.com>" >> "$PATH_REPORT/Report-$DATE_DAY"
	echo "To: Soporte SOC <email.mail@gmail.com>" >> "$PATH_REPORT/Report-$DATE_DAY"
	echo "Subject: REPORTE DE BACKUPS FORTIGATE | $DATE" >> "$PATH_REPORT/Report-$DATE_DAY"
	echo "Date: $DATE_REPORT" >> "$PATH_REPORT/Report-$DATE_DAY"
	echo " " >> "$PATH_REPORT/Report-$DATE_DAY"
	echo " " >> "$PATH_REPORT/Report-$DATE_DAY"
	echo "Reporte de la creación de backups automaticos de los Firewall fortigates de las diferentes entidades." >> "$PATH_REPORT/Report-$DATE_DAY"
	echo " " >> "$PATH_REPORT/Report-$DATE_DAY"
}
