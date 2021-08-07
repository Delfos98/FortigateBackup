#!/bin/bash


# Registro de ejecucion del programa
# $1 = Tipo de log (ERROR - INFO - REPORT)
# $2 = Mensaje de los ("Ejemplo de mensaje")
# $3 = Ubicacion de log ($PATH_ROOT/log/"Error, Info, Report")
regLog (){

	logType="$1"
	logMess="$2"
	logLoc="$3"

	case $logType in 

		"REPORT")
			echo "$logMess" >> "$logLoc/Report.log"
		;;

		"OTHER")
			echo "$logMess" >> "$logLoc/General.log"
		;;
	esac

	### se debe implementar la eliminación periodica de logs, los cuales despues de un mes tendran que ser eliminados
	
}