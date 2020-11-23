#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
library(methods)
source("DRaWR-balanced-asdouble.r")

DRaWR(possetfile = paste0("./scratch/",args[1],".list"),
    unifile = paste0("./scratch/",args[1],".node"),
    networkfile = paste0("./scratch/",args[1],".edge"),
    property_types = c("Reactome","KEGG"),
    outdir = args[2],
    undirected = FALSE,
    st2keep = 0,
    restarts = c(0.5),
    nfolds = 1,
    writepreds = 1,
    thresh = 0.000001)
