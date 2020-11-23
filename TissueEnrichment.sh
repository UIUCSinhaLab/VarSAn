N=4631659
echo ${N}
m=$(perl check-exist.pl ./data/GTEx_eQTL/AllTissue.snp 1 ./gene_sets/${1}.txt 1|awk '($2==1){print $1}'|sort -u|wc -l)
echo ${m}
for s in $(cat ./data/GTEx_eQTL/TissueList.txt); do  n=$(cut -f 1 ./data/GTEx_eQTL/$s.GTEx_eQTL.txt|sort -u|wc -l); k=$(perl check-exist.pl ./data/GTEx_eQTL/$s.GTEx_eQTL.txt 1 ./gene_sets/${1}.txt 1|awk '($2==1){print $1}'|sort -u|wc -l); echo $s" "$N" "$n" "$m" "$k; done |tr " " "\t"|sed 's/ //g' >${1}.enrich
Rscript hypergeometric-test.r ${1}.enrich
Rscript pvalue_to_weight.r ${1}.enrich.pvalue
