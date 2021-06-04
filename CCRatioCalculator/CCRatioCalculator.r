list <- read.table("FileList.txt",header=F)

diseases <- unique(list[,1])
for (d1 in diseases){
	cons <- 0
	conf <- 0
	#row <- as.character(d1)
	for (d2 in diseases){
		pairs1 <- list[list[,1]==d1,c(2,3)]
		pairs2 <- list[list[,1]==d2,c(2,3)]
		n <- 0
		for ( i in 1:dim(pairs1)[[1]]){
			data1 <- read.table(as.character(pairs1[i,1]),header=FALSE)
			data1 <- data1[1:20,1]
			data2 <- read.table(as.character(pairs2[i,2]),header=FALSE)
			data2 <- data2[1:20,1]
			n <- n + length(intersect(data1,data2))
		}
		if (d1 == d2 ){
			cons <- n/dim(pairs1)[[1]]
		}else{
			conf <- conf + n/dim(pairs1)[[1]]
		}
	}
	conf <- conf/(dim(pairs1)[[1]]-1)
	row <- cbind(as.character(d1),cons/conf)
	write.table(rbind(row),"CCRatio.txt",quote=FALSE,row.names=FALSE,col.names=FALSE,sep="\t",append=T)
			
}
