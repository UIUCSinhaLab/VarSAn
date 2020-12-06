# VarSAn - Variant Set Annotator

Xiaoman Xie [xiaoman2@illinois.edu] and Saurabh Sinha

University of Illinois Urbana-Champaign

## Table of Contents
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Tutorial](#tutorial)


## Introduction
Genotype-to-phenotype studies continue to identify sets of genomic variants associated with diseases, e.g., through GWAS, cataloging of somatic mutations in cancer, or identification of de novo mutations from family-based studies. There is a pressing need to interpret these variants mechanistically, e.g., through characterization of molecular pathways impacted by them. Such insights are especially useful in studies of complex diseases where no single variant explains etiology. Here we present a computational tool called ‘VarSAn’ (Variant Set Analysis) that uses a powerful graph mining algorithm to identify pathways relevant to a given set of variants. VarSAn aggregates diverse information about the user-provided collection of variants, along with prior knowledge about genes and pathways, to provide systems-level insights into those variants. 

VarSAn uses a pre-built and configurable heterogeneous network whose nodes represent SNPs,  genes and pathways, and edges represent relationships among these entities. The network includes: (1) SNP-gene relationships based on expression quantitative trait loci (eQTL) studies, protein activity impact prediction and genomic proximity, (2) gene-gene relationships based on known interactions among encoded proteins, and (3) gene-pathway membership. VarSAn then takes a “query set” of variants and uses the Random Walk with Restarts algorithm on the network to rank pathway nodes for relevance to the query set, reporting p-values for pathway relevance. 

![Method Overview](images/VarSAn_method.png)

 
[Return to TOC](#table-of-contents)

## Installation
Please first clone this repository from Github: 
```
git clone https://github.com/UIUCSinhaLab/VarSAn.git
```
Please also download the edges in the network from: http://veda.cs.uiuc.edu/VarSAn/VarSAn_Data.zip The data directory should be unzipped and placed in the downloaded repository. More information about files in the data folder can be found here: http://veda.cs.uiuc.edu/VarSAn/

## Tutorial
This section of the README is meant to walk a user through a process of using VarSAn to find related pathways that relate to a SNP set of interest. In these examples, we will examine a query set of XXX SNPs.

###  Creating SNP Query Set
The first step is to create a file that includes the SNPs in the query set. This query set file format should list one SNP on each row with SNPs formatted as 'chromosome_location'. For example, the [sample query set file](gene_sets/dmel/5268_brain_primordium.names.txt) contains:


