#!/bin/bash

PATH_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# Se agregan los recursos a los cuales accede el programa, los cuales tienen funciones adicionales
source $PATH_ROOT/src/res/globalVariables.sh
source $PATH_ROOT/src/res/regLog.sh
source $PATH_ROOT/src/res/getModulesInfo.sh
source $PATH_ROOT/src/res/makeFgtBackup.sh


# Verificar arbol de directorios
# Arbol de directorios del programa
valDirectoryTree (){

	echo "### VALIDATING EXECUTION INTEGRITY ###"
	while
		sleep 1
		do
			if [[ -d $PATH_LOG && -d $PATH_SRC ]]; then

				echo "INFO | $PATH_LOG EXIST"
				echo "INFO | $PATH_SRC EXIST"
				
				regLog "OTHER" "$DATE | INFO | ### VALIDATE DIRECTORY TREE" "$PATH_LOG"
				regLog "OTHER" "$DATE | INFO | $PATH_SRC EXIST" "$PATH_LOG"
				regLog "OTHER" "$DATE | INFO | $PATH_LOG EXIST" "$PATH_LOG"

				sleep 1
				break



			elif [[ ! -d $PATH_LOG ]]; then

				echo "ERROR | $PATH_LOG NOT EXIST"

				while
					echo "INFO | $PATH_LOG IS CREATED"
					sleep 1
					do 
						mkdir $PATH_LOG
						regLog "OTHER" "$DATE | INFO | ### VALIDATE DIRECTORY TREE ###" "$PATH_LOG"
						regLog "OTHER" "$DATE | ERROR | $PATH_LOG NOT EXIST" "$PATH_LOG"
						regLog "OTHER" "$DATE | INFO | $PATH_LOG IS CREATED" "$PATH_LOG"

						break
				done

				break

			elif [[ ! -d $PATH_SRC ]]; then
				sleep 1

				echo "ERROR | $PATH_SRC NOT EXIST"
				
				regLog "OTHER" "$DATE | ERROR | $PATH_SRC NOT EXIST" "$PATH_LOG"

				break

				exit 1
			fi
	done
}





# Ejecucion del metodo valDirectoryTree
valDirectoryTree


# Ejecucion del recurso que trae la informacion de los modulos
getModulesInfo


curl --ssl smtp://smtp.gmail.com --mail-from email.mail@gmail.com: --mail-rcpt email.mail@gmail.com: --upload-file "$PATH_REPORT/Report-$DATE_DAY" --user 'email.mail@gmail.com:P4$$W0rd'
