#!/bin/sh

version="0.1"
banner='https://github.com/JeffAlyanak/temp-throttle
Warning: This script was written hastily with minimal testing. Use at your own risk!'

# Super big boy professional exception handling
die()
{
	echo "$*" 1>&2 ; exit 1;
}

# 
print_help()
{
	echo 'Usage: temp-throttle.sh [OPTIONs]...
Provide a process name and a temperature and throttle that process when
the temperature is exceeded.

Mandatory arguments:
  -p, --process         name of the process to throttle
  -t, --temp            temperature as integer. Eg, "--process 75"'
}

maxtemp=
process=

# Handle arguments
while :
do
	case $1 in
		-h|-\?|--help)
			print_help
			exit
			;;

		-t|--temp)
			if [ "$2" ]
			then
				maxtemp=$2
				shift
			else
				die 'ERROR: Temperature requires an integer value. Eg, "70".
Use -h/--help for usage.'
			fi
			;;
		--temp=?*)
			maxtemp=${1#*=}
			;;
		--temp=)
			die 'ERROR: Temperature requires an integer value. Eg, "70".
Use -h/--help for usage.'
			;;

		-p|--process)
			if [ "$2" ]
			then
				process=$2
				shift
			else
				die 'ERROR: Process name required.
Use -h/--help for usage.'
			fi
			;;
		--process=?*)
			process=${1#*=}
			;;
		--process=)
			die 'ERROR: Process name required.
Use -h/--help for usage.'
			;;

		--)
			shift
			break
			;;
		-?*)
			printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
			;;
		*)
			break
	esac
	shift
done

# Validate temp
expr $maxtemp + 1 2> /dev/null > /dev/null
if [ $? != 0 ]
then
	die 'ERROR: Temperature requires an integer value. Eg, "70".
Use -h/--help for usage.'
fi

# Validate process
if [ -z "$process" ]; then
	die 'No process name provided.
Use -h/--help for usage.'
fi

while true
do
	val=$(sensors | awk '/Package id 0/ {print $4}' | cut -c 2- | rev | cut -c 6- | rev)	# This is probably a silly way of doing this.

	if [ "$maxtemp" -gt "$val" ]
	then
		killall cpulimit
		sleep 0.1
	else
		cpulimit -e $process -l 99 &
		sleep 1
	fi

	clear
	echo "Temperature Throttle — v"$version
	echo $banner
	echo "Process: "$process
	echo "Max Temp: +"$maxtemp".0\n"
	sensors
done
