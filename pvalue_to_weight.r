args <- commandArgs(trailingOnly = TRUE)

data <- read.table(args[1],header=FALSE)
data[,2] <- -log(data[,2])
write.table(data,paste0(args[1],".weight"),quote=FALSE,col.names = FALSE, row.names = FALSE,sep="\t")
