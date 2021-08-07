#!/bin/bash

DATE_REPORT="$(date +"%A %d, %B %Y %T")"
DATE="$(date +"%Y-%m-%d %T")"
DATE_DAY="$(date +"%Y-%m-%d")"

PATH_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )"
PATH_SRC="$PATH_ROOT/src"
PATH_LOG="$PATH_ROOT/log"
PATH_REPORT="$PATH_ROOT/reports"
PATH_MODULES="$PATH_ROOT/src/modules"

moduleName="";
entityName="";
conIP="";
conPort="";
conUser="";
conPass="";
dirBackup="";

statusBackup=false;