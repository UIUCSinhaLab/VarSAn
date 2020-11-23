open(INP,"<$ARGV[0]"); #SNP Set
my @edge=<INP>;
close INP;
my %gene;
my %snp;
foreach (@edge){
 if ($_=~/(.*?)\t(.*?)\t(.*?)\t.*/){
  if ($3 > 0.01){
   if(exists $gene{$1}){
    $gene{$1}++;
   }else{
    $gene{$1}=1;
   }
   $snp{$2}=0;
  }
 }
}

foreach (@edge){
 if ($_=~/(.*?)\t(.*?)\t(.*?)\t.*/){
  if ($3 > 0.01){
   $snp{$2}=$snp{$2}+(1/$gene{$1});
  }
 }
}


foreach my $key (keys %snp){
 print $key."\t".$snp{$key}."\n";
} 

