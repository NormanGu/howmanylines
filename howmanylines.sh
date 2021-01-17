#! /bin/bash


ftype=
spath=
show_summary="n"
num=0
sum=0
usage()
{
	echo "howmanylines.sh [option] <type> <path>"
	echo "                -s:  show summary"
}

##################################################
echo "arg0: $0"
echo "$(dirname "$0")"


while getopts 'hs' c; do
	case $c in
		s) show_summary=y ;;
		h) usage
		   exit 0
		   ;;
	esac
done

shift $((OPTIND-1))

ftype=$1
spath=$2

echo "type: $ftype"
echo "path: $spath"

pwd

echo "show summary= $show_summary"
echo "****************************"
if [ "$show_summary" == "y" ] ; then
	find $2 -name "$ftype" | xargs awk 'BEGIN{x=0} $0 !~ /^$/{x=x+1} END{print "sum:" " " x " " "lines"}'
else
	f=$(find $2 -name "$ftype")
		for i in $f ; do
		numlines=$(awk 'BEGIN{x=0} $0 !~ /^$/{x=x+1} END{print x}' $i)
		echo "File: $i [$numlines]"
		sum=$(expr $numlines + $sum)
		#sum=$(awk -v x=$sum 'BEGIN{} $0 !~ /^$/{x=x+1} END{print x}' $i)
	done
	echo $sum
fi



