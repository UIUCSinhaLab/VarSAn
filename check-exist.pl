my $largecol='$'.$ARGV[1]; #large column
my @large=`awk '{print $largecol}' $ARGV[0]`; #large file
my $smallcol='$'.$ARGV[3]; #small column
my @small=`awk '{print $smallcol}' $ARGV[2]`; #small file
my %hash;
foreach (@large){
 chomp ($_);
 $hash{$_}=1;
}

foreach (@small){
 chomp ($_);
 if ($hash{$_}){
  print $_."\t1\n";
 }else{
  print $_."\t0\n";
 }
}
