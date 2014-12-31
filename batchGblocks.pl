#!/usr/bin/perl -w
use strict;
#Karolina Heyduk - heyduk@uga.edu - 2014

my @files = glob("*.2.fas"); #assumes you ran prank as described in batchAlign.pl - if not, make sure to change this so it matches the end of your filenames
foreach my $file (@files) {
	my $count = 0;
	open IN, "<$file";
	while (<IN>) {
		chomp;
		my $line = $_;
		if ($line =~ ">") {
			$count++;
		#	print "$count";
		}
		else {
			next;
		}
		}
	my $half = int(($count/2)+1); #calculating half of the alignment columns for filtering - modify as you'd like here or below by replacing $half with an actual numerical value.
	open OUT, ">$file.gb.sh";
	print OUT "#!/bin/bash\n/usr/local/Gblocks/latest/Gblocks $file -t=d -b1=$half -b2=$half -b3=25 -b4=10 -b5=a -e gb";
	close OUT;
	system "qsub -q ltest-std
	-cwd $file.gb.sh";
}


