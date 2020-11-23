#!/bin/sh
snplist=${1}
sg=${2:-all}
pw=${3:-Reactome} # User selected pathway
gg=${4:-yes}
w=${5:-1}
nq=${6:-1} # Number of random query sets

mkdir -p ./scratch/

if [ -d "./results/" ]; then
        rm -rf ./results/
fi

mkdir ./results/

sleep 1
echo ${w}
./run_VarSAn.sh ${snplist} ${sg} ${pw} ${gg} ${w} 0 ${snplist}
for i in $(seq 1 ${nq}); do ./sample_random_query.sh ${snplist} ${sg} ./gene_sets/${snplist}.RandomQuery-$i.txt ;./run_VarSAn.sh ${snplist}.RandomQuery-$i ${sg} ${pw} ${gg} ${w} 1 ${snplist}; done
sleep 1
paste ./results/${snplist}.node.*.1.rwr ./results/${snplist}.RandomQuery-*.1.rwr |awk '(NR>1){sum=0; for (i=2; i<=101; i++) {m=i+5; if($m >= $6) {sum++}} print $2"\t"$6"\t"sum/100}'|grep -v "^ENSG"|sort -g -k 3 -k 2rg >./results/${snplist}.query.empirical

rm -rf ./scratch/

