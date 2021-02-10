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


###############################################################################################################################
print_error()
{
	echo -e "\033[31m$1\033[0m"
	exit 1
}

print_info()
{
	echo -e "\033[32m$1\033[0m"
}

print_warn()
{
	echo -e "\033[33m$1\033[0m"
}

usage()
{
	echo "howmanylines.sh [option] <type> <path>"
	echo "                -s:  show summary"
	echo "                -d:  show detail "
	echo "example: "
	echo "howmanylines.sh \"*.c\" /home/workspace/ "
}

info()
{
	echo "*************INFO***************"
	echo "File type:    $ftype"
	echo "Path:         $spath"
	echo "Show summary: $show_summary"
	echo "Show detail:  $show_detail"
	echo "********************************"
}

delete_string()
{
	local len=$1
	echo -ne "\r"
	while ((len > 0))
	do
		echo -ne " "
		let len--
	done
	echo -ne "\r"
}

cal()
{
	sum=0
	local len=0
	if [ "$show_summary" == "y" ] ; then
		find $2 -name "$ftype" | xargs awk 'BEGIN{x=0} $0 !~ /^$/{x=x+1} END{print "sum:" " " x " " "lines"}'
	else
		f=$(find $2 -name "$ftype")
		for i in $f ; do
			len=${#i}
			echo -ne "$i"
			numlines=$(awk 'BEGIN{x=0} $0 !~ /^$/{x=x+1} END{print x}' $i)
			sum=$(expr $numlines + $sum)
			delete_string $len
			#sum=$(awk -v x=$sum 'BEGIN{} $0 !~ /^$/{x=x+1} END{print x}' $i)
		done
	fi
}

#############################################################################################################################


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


all=$(ls $spath)
for each in $all ; do
	itype="File"
	entry=$spath/$each
	if [ -d "$entry" ]; then
		print_info "reading $entry"
		itype="Dir"
	fi
	cal $ftype $entry

	if [ "$sum" -gt "0" -o -d "$entry" ]; then
		printf "$itype  %20s : %s\n" "[$each]" "$sum"
	fi

	total=$(expr $total + $sum)
done

echo "Total: $total lines"

