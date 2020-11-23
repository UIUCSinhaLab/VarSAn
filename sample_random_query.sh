#!/bin/sh
snplist=${1}
sg=${2:-all}
output=${3}
case $sg in

        all)
		perl snp_to_edge.pl ./gene_sets/${snplist}.txt ./data/Polyphen/Polyphen_pair.txt|cut -f 1|sort -u >${snplist}.tmp1
		perl snp_to_edge.pl ./gene_sets/${snplist}.txt ./data/GTEx_eQTL/AllTissue.GTEx_eQTL.txt|cut -f 1|sort -u >${snplist}.tmp2
		all=$(cat ${snplist}.tmp1 ${snplist}.tmp2|sort -u|wc -l|awk '{print $1}')
		c=$(wc -l ${snplist}.tmp1|awk '{print $1}')
		nc=$( expr $all - $c )
		shuf ./data/GTEx_eQTL/AllTissue.snp|head -n $nc >${output}
		shuf ./data/Polyphen/Polyphen.nsSNP|head -n $c >>${output}
		sleep 2
		rm ${snplist}.tmp*
		;;
	Proximity)
		
		;;
	*)
		perl snp_to_edge.pl ./gene_sets/${snplist}.txt ./data/Polyphen/Polyphen_pair.txt|cut -f 1|sort -u >${snplist}.tmp1
                perl snp_to_edge.pl ./gene_sets/${snplist}.txt ./data/GTEx_eQTL/${sg}.GTEx_eQTL.txt|cut -f 1|sort -u >${snplist}.tmp2
                all=$(cat ${snplist}.tmp1 ${snplist}.tmp2|sort -u|wc -l|awk '{print $1}')
                c=$(wc -l ${snplist}.tmp1|awk '{print $1}')
                nc=$( expr $all - $c )
                shuf ./data/GTEx_eQTL/${sg}.snp|head -n $nc >${output}
		shuf ./data/Polyphen/Polyphen.nsSNP|head -n $c >>${output}
                sleep 2
                rm ${snplist}.tmp*
		;;
esac
