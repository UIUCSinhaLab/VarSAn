open(LIST,"<$ARGV[0]"); #Query SNP
my %snp;
foreach (<LIST>){
 chomp($_);
 $snp{$_}=1;
}
close LIST;

open(EDGE,"<$ARGV[1]"); #Edge List
foreach(<EDGE>){
 chomp($_);
 if ($_=~/(.*?)\t.*/){
  if(exists $snp{$1}){
   print $_."\n";
  }
 }
}
