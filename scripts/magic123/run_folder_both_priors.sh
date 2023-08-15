script_name=$1
device=$2
runid=$3 # jobname for the first stage
runid2=$4 # jobname for the second stage
topdir=$5   # path to the directory containing the images, e.g. data/nerf4
step1=$6
step2=$7

for i in $topdir/*; do
    echo "$i"
    [ -d "$i" ] && echo "$i exists."
    bash ${script_name} $device $runid $runid2 "$i" $step1 $step2 ${@:8}
done
