#!/usr/bin/perl
use strict;
#Karolina Heyduk - heyduk@uga.edu - 2014
#modified from script by Michael McKain

my @infiles = glob("*.targets.fasta.norep"); #keep this the same if you previously ran batchRemovedups.pl

foreach my $infile (@infiles) {
	my $divider = ".";
	my $position = index($infile, $divider);
	my $libid = substr($infile, 0, $position);
	open OUT, ">>$libid.genes";
	open IN, "<$infile";

	my ($contig, $ID, $ID2, $exon);
	my %seqs;

	while(<IN>){
		chomp;
		if(/>/){
			($ID, $exon) = split /\_/;
			if ($exon =~ "null") {
			$exon = 0;
			}
			else {
			next;
			}
		}
		else{
			$seqs{$ID}{$exon}.=$_;
		}
	}
foreach my $ID (sort keys %seqs){
	my $seq;
	for my $exon (sort {$a<=>$b} keys %{$seqs{$ID}}){
			$seq.=$seqs{$ID}{$exon};
		}
		print OUT ">$ID\_$libid\n$seq\n";
	}
close OUT;
close IN;
}
