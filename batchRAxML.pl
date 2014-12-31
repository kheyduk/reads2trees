#!/usr/bin/perl 
#Karolina Heyduk - heyduk@uga.edu - 2014

use strict;
use Cwd;
use Bio::SeqIO;
use Array::Utils qw(:all);

#Assumes you have one most distant outgroup, as opposed to a number of outgroups that are sister to each other. This script does allow for the most furthest outgroup to be missing - it will use the next distant outgroup. If none of your outgroups exist in the alignment, RAxML will not run.

my $outfile = $ARGV[0]; #file of outgroup IDs
my $boots = $ARGV[1];
my $ending = $ARGV[2];
my @files = glob("*$ending");
my @outgroups;
my $wd = getcwd;

open IN, "<$outfile"; #put all outgroups into an array
while (<IN>) {
	chomp;
	my $line = $_;
	push(@outgroups, $line);
	}
close IN;

#remove totally blank/missing data sequences from fasta files (cause RAxML to error)
for my $file (@files) {
	open OUT, ">>$file.mod";
	my $geneID;
	my @headers;
	my $stop = 0;
    my $infile = Bio::SeqIO -> new(-file => "$file", -format => "fasta", -alphabet => "DNA"); #this line calls bioperl and defines the infile as a bioperl variable
    while (my $io_obj = $infile -> next_seq() ) {
		my $header = $io_obj->id();
		my $seq = $io_obj->seq();
		push(@headers, $header);
		if ($seq ~~ /[ACTG]/) {
			print OUT ">$header\n$seq\n"; #makes a modified file that removes blank sequences
			}
		else {
			next;
			}
		}
	close OUT;

	my $out;	
	my $count = 0;
	foreach my $outgroup (@outgroups) {	
		if($outgroup ~~ @headers) {
			if ($count < 1) {
				$out.="$outgroup" . "_";
				$count = 1;
			}
			else {
				next;
			}
		}
		else {
			next;
			}
		}
		
	my @int = intersect(@outgroups, @headers);
	if (@int == 0) {
		print "$file has no outgroup!\n";
		$stop = 1;
		}

	if ($stop == 0) {	
	my $divider = ".";
    my $position = index($file, $divider, 0);
    my $ID = substr($file, 0, $position);
	print "$ID\n";
	system "perl /usr/local/raxml/7.3.0-mpi-1.4.1p1-gcc/fasta2relaxedPhylip.pl $file.mod";
    open OUT2, ">>run.$ID\_raxml.sh";
    print OUT2 "#!/bin/bash\n/usr/local/mpich2/1.4.1p1/gcc_4.5.3/bin/mpirun -np \$NSLOTS /usr/local/raxml/latest/raxmlHPC-MPI-SSE3 -f a -x 1237 -p 12345 -# $boots -m GTRGAMMA -s $file.mod.phylip -n $ID.raxml.out -o $out -w $wd";
    close OUT2;
    system "qsub -q rcc-30d -cwd -pe mpi 2 ./run.$ID\_raxml.sh";
	}
	
	else {
		next;
		}
}

	