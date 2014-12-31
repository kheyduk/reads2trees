#!/usr/bin/perl
use strict;
use Cwd;
#Karolina Heyduk - heyduk@uga.edu - 2014

#This script assumes you have run CAP3 on the Trinity.fasta file for each library, 
#so thus the section commented "combine contigs and singlets" 
#applies in this case. If you DID NOT run CAP3, comment out that section, 
#and make sure you alter the -i flag in the shell print out
#so that it correctly reads the right input file (Trinity.fasta if you did not use CAP#)

my $dir = $ARGV[0]; #path to Trinity directory
my $reference = $ARGV[1];
my $list = $ARGV[2]; #text file of the list of all your library IDs
my $wd = getcwd;
my @ids;


#read the list of library IDs, store them
open IN, "<$list";
while (<IN>) {
	chomp;
	my $line = $_;
	push (@ids, $line);
	}

#combine output from CAP3 - COMMENT OUT if you did not use CAP3
foreach my $id (@ids) {
		chdir("$dir/$id/trinity_out_dir");
		system "cat *.contigs *.singlets >> Trinity.fasta.$id.cap3";
		chdir("$wd");
		}

#now BLAST! Edit -i if you commented the above section out
foreach my $id (@ids) {
open OUT, ">$id.blast.sh";
        print OUT "#!/bin/bash\n/usr/local/ncbiblast/latest/bin/blastall -p blastn -d $reference -i $dir/$id/trinity_out_dir/Trinity.fasta.$id.cap3 -o $id\_target.out -e 1E-20 -m 8";
       system "qsub -q rcc-30d -cwd ./$id.blast.sh";
        close OUT;
}
