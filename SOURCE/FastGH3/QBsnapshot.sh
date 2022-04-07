snapid=$(date +%s%N)
folder='!QBsnapshots/'
cp qb.pak.xen "${folder}qb.${snapid}.pak.xen"
cp qb.pab.xen "${folder}qb.${snapid}.pab.xen"