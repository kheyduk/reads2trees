#!/usr/bin/perl
use strict;
use warnings;

my @infiles = glob("*.norep");

foreach my $infile (@infiles) {
	my $divider = ".";
	my $position = index($infile, $divider);
	my $libid = substr($infile, 0, $position);
	open OUT, ">>$libid.genes";
	open IN, "<$infile";

	my ($contig, $ID, $exon);
	my %seqs;

	while(<IN>){
		chomp;
		if(/>/){
			($contig, $ID, $exon) = split /\_/;
		}
		else{
			$seqs{$contig}{$ID}{$exon}.=$_;
		}
	}
foreach my $contig (sort keys %seqs) {
	for my $ID (sort keys %{$seqs{$contig}}){
			my $seq;
			for my $exon (sort {$a<=>$b} keys %{$seqs{$contig}{$ID}}){
				$seq.=$seqs{$contig}{$ID}{$exon};
			}
			print OUT "$contig\_$ID\_$libid\n$seq\n";
	}
}
close OUT;
close IN;
}
