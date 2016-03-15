#!/usr/bin/perl
use strict;
use Cwd;
use Data::Dumper;
#Karolina Heyduk - heyduk@uga.edu - 2014

my $dir = $ARGV[0]; #FULL PATH to trinity folder, include final "/"
my $reads = $ARGV[1]; #FULL PATH to clean reads directory, include final "/"
my $CPU = $ARGV[2];
my $list = $ARGV[3]; #list of libIDs, should be the prefix of trimmomatic outputs
my @files = glob("*fastq"); #push files with correct ending into an array
my %control;
my $wd = getcwd;

#read library index file, store in hash
my %paired1;
my %paired2;
my %unpaired1;
my %unpaired2;
my @libIDs;
open IN, "<$list";
while (<IN>) {
	chomp;
	push (@libIDs, $_);
#	my ($libID, $readID) = split /\t/;
#	if ($readID =~ 'R1') { 
#		if ($readID =~ 'paired') {
#			$paired1{$libID} = $readID;
#			}
#		else {
#			$unpaired1{$libID} = $readID;
#			}
#		if ($libID ~~ @libIDs) {
#			next;
#			}
#		else {
#			push(@libIDs, $libID);
#			}
#		}
#	elsif ($readID =~ 'R2') {
#		if ($readID =~ 'paired') {
#			$paired2{$libID} = $readID;
#			}
#		else {
#			$unpaired2{$libID} = $readID;
#		}
#	}
	}
close IN;
print "@libIDs\n";

#make trinity folders and submission scripts
for my $libID (@libIDs) {       
        system "mkdir $dir$libID"; 
		chdir("$dir/$libID");
		open OUT, ">$libID.trinity.sh"; #make a shell file for trinity submission
        print OUT "#!/bin/bash\ncd $dir$libID\nexport LD\_LIBRARY\_PATH=/usr/local/gcc/4.7.1/lib:/usr/local/gcc/4.7.1/lib64:\${LD\_LIBRARY\_PATH}\nperl /usr/local/trinity/latest/Trinity --seqType fq --left $reads/$libID\_paired\_R1.fastq,$reads/$libID\_unpaired\_R1.fastq --right $reads/$libID\_paired\_R2.fastq,$reads/$libID\_unpaired\_R2.fastq --min_contig_length 100 --CPU $CPU --JM 10G";
        system "qsub -q rcc-30d -pe thread $CPU -l mem_total=10G ./$libID.trinity.sh";
		chdir("$wd");
		close OUT;
        }
		
