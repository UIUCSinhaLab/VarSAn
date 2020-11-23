args <- commandArgs(trailingOnly = TRUE)

PValue=c()
NUM=read.table(args[1],header=FALSE,sep="\t",check.names=FALSE)
for (j in 1:length(NUM[,1])){
 a=phyper(NUM[j,5]-1,NUM[j,3],(NUM[j,2]-NUM[j,3]),NUM[j,4],lower.tail=FALSE)
 PValue=rbind(PValue,a)
}
row.names(PValue) = NUM[,1]
#NUM=cbind(NUM,PValue)


write.table(PValue,paste0(args[1],".pvalue"),quote=F,col.names=FALSE,row.names=TRUE,sep="\t")


