#!/bin/sh
snplist=${1}
sg=${2:-all}
pw=${3:-Reactome} # User selected pathway
gg=${4:-yes}
weight=${5:-1}
is_random=${6:-0} # Is the query set a random query set?
en=${7} # What enrichment file to use

mkdir -p ./scratch/

case $sg in

	all)
		echo "SNP to gene connections: all tissue eQTLs"
		if [ "${is_random}" = "0" ]; then
			echo "Calculating tissue enrichment..."
			./TissueEnrichment.sh ${snplist}
			mv ${snplist}.enrich* ./scratch/
		fi
		sleep 3
		for s in $(cat ./data/GTEx_eQTL/TissueList.txt ); do w=$(awk -v var=$s '($1==var){print $2}' ./scratch/${en}.enrich.pvalue.weight); perl snp_to_edge.pl ./gene_sets/${snplist}.txt ./data/GTEx_eQTL/$s.GTEx_eQTL.txt|awk -v var=$w '{print $1":"$2"\t"var}'; done >./scratch/${1}.edge.tmp
		perl format_edge.pl ./scratch/${1}.edge.tmp sum|tr ":" "\t"|awk '{print $2"\t"$1"\t"$3"\tSNP-Gene\n"$1"\t"$2"\t0.000000000000001\tSNP-Gene"}' >./scratch/${1}.edge
		if [ "${weight}" = "1" ]; then
			echo "w eq 1"
                	perl SignWeight.pl ./scratch/${1}.edge >./scratch/${1}.query.tmp
        	else
			echo "w not eq 1"
                	awk '($3 > 0.1){print $2"\t1"}' ./scratch/${1}.edge|sort -u >./scratch/${1}.query.tmp
        	fi
		perl snp_to_edge.pl ./gene_sets/${1}.txt ./data/Polyphen/Polyphen_pair.txt >./scratch/${1}-coding.tmp
		awk '{print $2"\t"$1"\t1\tSNP-Gene\n"$1"\t"$2"\t0.000000000000001\tSNP-Gene"}' ./scratch/${1}-coding.tmp >>./scratch/${1}.edge
		cut -f 1 ./scratch/${1}-coding.tmp|sort -u|awk '{print $1"\t1"}' >>./scratch/${1}.query.tmp
        	perl format_query.pl ./scratch/${1}.query.tmp >./scratch/${1}.query.txt
        	awk '($3 > 0.1){print $1}' ./scratch/${1}.edge >./scratch/${1}-tmp1.txt
		if [ "${gg}" = 'yes' ]; then
			echo "PPI yes"
			awk '{print $1"\t"$2"\t1\t"$4"\n"$2"\t"$1"\t1\t"$4}' ./data/PPI/hn_IntNet.edge |sort -u >>./scratch/${1}.edge
		fi
		if [ "${pw}" = 'Reactome' ]; then
			echo "pw yes"
			awk '{print $1"\t"$2"\t1\t"$4"\n"$2"\t"$1"\t0.000000000000001\t"$4}' ./data/Pathway/ReactomeMoreThan30Slim-1.edge >>./scratch/${1}.edge
			if [ "${gg}" = 'yes' ]; then
                                cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/PPI/hn_IntNet.gene ./data/Pathway/ReactomeMoreThan30Slim-1.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
                        else
                                cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/Pathway/ReactomeMoreThan30Slim-1.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
                        fi
		else
			echo "pw KEGG"
			awk '{print $1"\t"$2"\t1\t"$4"\n"$2"\t"$1"\t0.000000000000001\t"$4}' ./data/Pathway/KEGG.edge >>./scratch/${1}.edge
			if [ "${gg}" = 'yes' ]; then
                                cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/PPI/hn_IntNet.gene ./data/Pathway/KEGG.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
                        else
                                cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/Pathway/KEGG.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
                        fi
		fi
        	echo ${1}.query.txt >./scratch/${1}.list
		#cd ./scratch/
		Rscript run_DRaWR_query_specific_network.r ${1} ./results/
		sleep 1
		rm ./results/*.stats
		;;

	Proximity)
		echo "SNP to gene connections: Proximity, 10kb"
		echo "Currently not available!"
	
		perl snp_to_edge.pl ./gene_sets/${1}.txt ../gene_sets/GWAS_29059683.proximity.edge|awk '{print $2"\t"$1"\t1\tSNP-Gene\n"$1"\t"$2"\t0.000000000000001\tSNP-Gene"}' >./scratch/${1}.edge

		if [ "${weight}" = "1" ]; then
                        echo "w eq 1"
                        perl SignWeight.pl ./scratch/${1}.edge >./scratch/${1}.query.tmp
                else
                        echo "w not eq 1"
                        awk '($3 > 0.1){print $2"\t1"}' ./scratch/${1}.edge|sort -u >./scratch/${1}.query.tmp
                fi
                perl snp_to_edge.pl ./gene_sets/${1}.txt ./data/Polyphen/Polyphen_pair.txt >./scratch/${1}-coding.tmp
                awk '{print $2"\t"$1"\t1\tSNP-Gene\n"$1"\t"$2"\t0.000000000000001\tSNP-Gene"}' ./scratch/${1}-coding.tmp >>./scratch/${1}.edge
                cut -f 1 ./scratch/${1}-coding.tmp|sort -u|awk '{print $1"\t1"}' >>./scratch/${1}.query.tmp
                perl format_query.pl ./scratch/${1}.query.tmp >./scratch/${1}.query.txt
                awk '($3 > 0.1){print $1}' ./scratch/${1}.edge >./scratch/${1}-tmp1.txt
                if [ "${gg}" = 'yes' ]; then
                        echo "PPI yes"
                        awk '{print $1"\t"$2"\t1\t"$4"\n"$2"\t"$1"\t1\t"$4}' ./data/PPI/hn_IntNet.edge |sort -u >>./scratch/${1}.edge
                fi
                if [ "${pw}" = 'Reactome' ]; then
                        echo "pw yes"
                        awk '{print $1"\t"$2"\t1\t"$4"\n"$2"\t"$1"\t0.000000000000001\t"$4}' ./data/Pathway/ReactomeMoreThan30Slim-1.edge >>./scratch/${1}.edge
                        if [ "${gg}" = 'yes' ]; then
                                cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/PPI/hn_IntNet.gene ./data/Pathway/ReactomeMoreThan30Slim-1.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
                        else
                                cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/Pathway/ReactomeMoreThan30Slim-1.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
                        fi
                else
                        echo "pw KEGG"
                        awk '{print $1"\t"$2"\t1\t"$4"\n"$2"\t"$1"\t0.000000000000001\t"$4}' ./data/Pathway/KEGG.edge >>./scratch/${1}.edge
                        if [ "${gg}" = 'yes' ]; then
                                cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/PPI/hn_IntNet.gene ./data/Pathway/KEGG.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
                        else
                                cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/Pathway/KEGG.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
                        fi
                fi
                echo ${1}.query.txt >./scratch/${1}.list
                #cd ./scratch/
                Rscript run_DRaWR_query_specific_network.r ${1} ./results/
                sleep 1
                rm ./results/*.stats	
		;;
	*)
		echo "SNP to gene connections: ${sg} tissue eQTLs"
		perl snp_to_edge.pl ./gene_sets/${1}.txt ./data/GTEx_eQTL/${sg}.GTEx_eQTL.txt|awk '{print $2"\t"$1"\t1\tSNP-Gene\n"$1"\t"$2"\t0.000000000000001\tSNP-Gene"}' >./scratch/${1}.edge
		if [ "${weight}" = "1" ]; then
                        echo "w eq 1"
                        perl SignWeight.pl ./scratch/${1}.edge >./scratch/${1}.query.tmp
                else
                        echo "w not eq 1"
                        awk '($3 > 0.1){print $2"\t1"}' ./scratch/${1}.edge|sort -u >./scratch/${1}.query.tmp
                fi
                perl snp_to_edge.pl ./gene_sets/${1}.txt ./data/Polyphen/Polyphen_pair.txt >./scratch/${1}-coding.tmp
                awk '{print $2"\t"$1"\t1\tSNP-Gene\n"$1"\t"$2"\t0.000000000000001\tSNP-Gene"}' ./scratch/${1}-coding.tmp >>./scratch/${1}.edge
                cut -f 1 ./scratch/${1}-coding.tmp|sort -u|awk '{print $1"\t1"}' >>./scratch/${1}.query.tmp
                perl format_query.pl ./scratch/${1}.query.tmp >./scratch/${1}.query.txt
                awk '($3 > 0.1){print $1}' ./scratch/${1}.edge >./scratch/${1}-tmp1.txt
                if [ "${gg}" = 'yes' ]; then
                        echo "PPI yes"
                        awk '{print $1"\t"$2"\t1\t"$4"\n"$2"\t"$1"\t1\t"$4}' ./data/PPI/hn_IntNet.edge |sort -u >>./scratch/${1}.edge
                fi
                if [ "${pw}" = 'Reactome' ]; then
                        echo "pw yes"
                        awk '{print $1"\t"$2"\t1\t"$4"\n"$2"\t"$1"\t0.000000000000001\t"$4}' ./data/Pathway/ReactomeMoreThan30Slim-1.edge >>./scratch/${1}.edge
			if [ "${gg}" = 'yes' ]; then
                        	cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/PPI/hn_IntNet.gene ./data/Pathway/ReactomeMoreThan30Slim-1.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
			else
				cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/Pathway/ReactomeMoreThan30Slim-1.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
			fi
                else
                        echo "pw KEGG"
                        awk '{print $1"\t"$2"\t1\t"$4"\n"$2"\t"$1"\t0.000000000000001\t"$4}' ./data/Pathway/KEGG.edge >>./scratch/${1}.edge
			if [ "${gg}" = 'yes' ]; then
                        	cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/PPI/hn_IntNet.gene ./data/Pathway/KEGG.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
			else
				cat ./scratch/${1}.query.txt ./scratch/${1}-tmp1.txt ./data/Pathway/KEGG.gene | awk '{print $1"\t1"}'|sort -u >./scratch/${1}.node
			fi
                fi
                echo ${1}.query.txt >./scratch/${1}.list
                #cd ./scratch/
                Rscript run_DRaWR_query_specific_network.r ${1} ./results/
                sleep 1
                rm ./results/*.stats
	
		;;
esac



