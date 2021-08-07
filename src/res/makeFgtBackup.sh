#!/bin/bash




makeFgtBackup (){

	echo "### MAKING BACKUP ###"

	echo "INFO | VALIDATING BACKUP DIRECTORY"
	regLog "OTHER" "$DATE | INFO | VALIDATING BACKUP DIRECTORY" "$PATH_LOG"

	if [[ -d $dirBackup ]]; then
	   	sleep 1		
	    echo echo "INFO | Backup directory validation was successful! | $dirBackup"
	    regLog "OTHER" "$DATE | INFO | Backup directory validation was successful!" "$PATH_LOG"

	    sleep 1
		echo "INFO | TRY CONNECT REMOTE SITE"
		regLog "OTHER" "$DATE | INFO | TRY CONNECT REMOTE SITE" "$PATH_LOG"

		timeout 5 bash -c "</dev/tcp/$conIP/$conPort"
		if [[ $? == 0 ]];then
			sleep 1

			echo "SSH Connection to $conIP over port $conPort is possible"
			regLog "OTHER" "$DATE | INFO | SSH Connection to $conIP over port $conPort is possible" "$PATH_LOG"

			echo "Try connection by SSH protocol to $conIP over port $conPort and user $conUser"
			regLog "OTHER" "$DATE | INFO | Try connection by SSH protocol to $conIP over port $conPort and user $conUser" "$PATH_LOG"

			trySshCom=$(sshpass -p $conPass ssh -q -p $conPort $conUser@$conIP exit 2>&1)
			#$trySshCom
			if [[ $trySshCom && $? == 0 ]]; then
				sleep 1 
				
				echo "SSH connection to $conIP over port $conPort and user $conUser is established"
		   		regLog "OTHER" "$DATE | INFO | SSH connection to $conIP over port $conPort and user $conUser is established" "$PATH_LOG"

		   		sleep 1
		   		printf "INFO | MAKING BACKUP ."
		   		sleep 1
		   		printf "...."

		   		tryScpCom=$(sshpass -p $conPass scp -q -P $conPort $conUser@$conIP:sys_config $dirBackup/$moduleName-$DATE_DAY 2>&1)
		   		$tryScpCom
		   		if [[ $? == 0 ]]; then
		   			
		   			dirBackup="$dirBackup$moduleName-$DATE_DAY"

		   			statusBackup=true;
		   			valBackupDone

		   		else
		   			echo "ERROR | THE SCP COMMAND COULD NOT BE EXECUTED IN REMOTE HOST | $tryScpCom"

		   			dirBackup="$dirBackup/$moduleName-$DATE_DAY"

		   			statusBackup=false;
		   			valBackupDone "ERROR | THE SCP COMMAND COULD NOT BE EXECUTED IN REMOTE HOST | $tryScpCom"
		   		fi

		   	else
		   		echo "SSH connection to $conIP over port $conPort and user $conUser is not possible to establish | $trySshCom"
		   		regLog "OTHER" "$DATE | ERROR | SSH connection to $conIP over port $conPort and user $conUser is not possible to establish" "$PATH_LOG"

		   		dirBackup="$dirBackup/$moduleName-$DATE_DAY"

		   		statusBackup=false;
		   		valBackupDone "SSH connection to $conIP over port $conPort and user $conUser is not possible to establish | $trySshCom"
			fi

		else
		   echo "ERROR | SSH connection to $conIP over port $conPort is not possible"
		   regLog "OTHER" "$DATE | ERROR | SSH connection to $conIP over port $conPort is not possible" "$PATH_LOG"

		   dirBackup="$dirBackup/$moduleName-$DATE_DAY"

		   statusBackup=false;
		   valBackupDone "ERROR | SSH connection to $conIP over port $conPort is not possible"
		fi


	elif [[ ! -d  $dirBackup ]]; then
	    echo "ERROR | THE ROUTE -- $dirBackup -- DOES NOT EXIST"
		regLog "OTHER" "$DATE | ERROR | THE ROUTE -- $dirBackup -- DOES NOT EXIST" "$PATH_LOG"

		statusBackup=false;
		valBackupDone echo "ERROR | THE ROUTE -- $dirBackup -- DOES NOT EXIST"
	fi

}

valBackupDone (){

	local msg="$1"

	if [[ -f $dirBackup ]]; then
		printf '.. 100%%'
		sleep 1
		echo ""
		echo "SUCCESSFUL BACKUP"
		regLog "OTHER" "$DATE | INFO | SUCCESSFUL BACKUP" "$PATH_LOG"

		printReport "$msg"
	
	elif [[ ! -f $1 ]]; then
		echo ""
		echo "BACKUP NOT FOUND"
		regLog "OTHER" "$DATE | INFO | BACKUP NOT FOUND" "$PATH_LOG"

		printReport "$msg"
	fi
}


printReport (){

	local msg="$1"

	echo "Entidad: <$entityName>" >> "$PATH_REPORT/Report-$DATE_DAY"
	echo "IP dispositivo: <$conIP>" >> "$PATH_REPORT/Report-$DATE_DAY"
	echo "Puerto de conexión: <$conPort>" >> "$PATH_REPORT/Report-$DATE_DAY"
	echo "Estado del backup: <$statusBackup>" >> "$PATH_REPORT/Report-$DATE_DAY"

	if [[ $statusBackup == true ]]; then

		local backupSize=$(du -bsh $dirBackup | awk '{print $1}')

		echo "Fecha de creación: <$DATE_REPORT>" >> "$PATH_REPORT/Report-$DATE_DAY"
		echo "Ubicación del backup: <$dirBackup>" >> "$PATH_REPORT/Report-$DATE_DAY"
		echo "Peso del archivo: <$backupSize>" >> "$PATH_REPORT/Report-$DATE_DAY"
		echo " " >> "$PATH_REPORT/Report-$DATE_DAY"
		echo "------------------------------------------------------------------------------------" >> "$PATH_REPORT/Report-$DATE_DAY"

	elif [[ $statusBackup == false ]]; then
		echo "Fecha de ejecución: <$DATE_REPORT>" >> "$PATH_REPORT/Report-$DATE_DAY"
		echo "Ubicación destinada del backup: <$dirBackup>" >> "$PATH_REPORT/Report-$DATE_DAY"
		echo "LA CREACIÓN DEL BACKUP FALLÓ | log del error: <$msg>" >> "$PATH_REPORT/Report-$DATE_DAY"
		echo " " >> "$PATH_REPORT/Report-$DATE_DAY"
		echo "------------------------------------------------------------------------------------" >> "$PATH_REPORT/Report-$DATE_DAY"

	fi
}

