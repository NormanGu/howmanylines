#! /bin/bash

scriptdir=$(dirname "$0")
currentdir=$(pwd)
show_summary="n"
show_detail="n"
ftype=
spath=
num=0
sum=0
total=0


##################################################
usage()
{
	echo "howmanylines.sh [option] <type> <path>"
	echo "                -s:  show summary"
	echo "                -d:  show detail "
}

print_info()
{
	echo "*************INFO***************"
	echo "File type:    $ftype"
	echo "Path:         $spath"
	echo "Show summary: $show_summary"
	echo "Show detail:  $show_detail"
	echo "********************************"
}
##################################################



while getopts 'hsd' c; do
	case $c in
		s) show_summary=y ;;
		d) show_detail=y;;
		h) usage
		   exit 0
		   ;;
	esac
done

shift $((OPTIND-1))

ftype=$1
spath=$2


cal()
{
sum=0

if [ "$show_summary" == "y" ] ; then
	find $2 -name "$ftype" | xargs awk 'BEGIN{x=0} $0 !~ /^$/{x=x+1} END{print "sum:" " " x " " "lines"}'
else
	f=$(find $2 -name "$ftype")
	for i in $f ; do
		numlines=$(awk 'BEGIN{x=0} $0 !~ /^$/{x=x+1} END{print x}' $i)
		#echo "File: $i [$numlines]"
		sum=$(expr $numlines + $sum)
		#sum=$(awk -v x=$sum 'BEGIN{} $0 !~ /^$/{x=x+1} END{print x}' $i)
	done
	#echo $sum
fi
}

all=$(ls $spath)
for each in $all ; do
	entry=$spath/$each
	cal $ftype $entry
	if [ -d "$entry" ]; then
		printf "Dir  %20s : %s\n" "[$each]" "$sum"
	else
		if [ "$sum" -gt "0" ]; then
			printf "File %20s : %s\n" "[$each]" "$sum"
		fi
	fi
	total=$(expr $total + $sum)
done

echo "Total: $total lines"

