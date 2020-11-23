open(INP,"<$ARGV[0]");
my %query;
foreach(<INP>){
 chomp($_);
 if($_=~/(.*?)\t(.*)/){
  if (exists $query{$1}){
   $query{$1} = $query{$1} + $2;
  }else{
   $query{$1} = $2;
  }
 }
}

for (keys %query){
 print $_."\t".$query{$_}."\n";
}
