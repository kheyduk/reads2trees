#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;

my $species = $ARGV[0]; #file with list of all species included in your analysis
my @files = glob("*.mod");
my @taxas;
my %lengths;

open IN, "$species" or die $!;
while (<IN>) {
        chomp;
        my $taxa = $_;
        #print "$taxa\n";
        push (@taxas, $taxa);
        }
close IN;

my %seqs;
open OUT, ">>concat.fasta";
foreach my $taxa (@taxas) {
        print OUT ">$taxa\n";
        foreach my $file (@files) {
                my $len;
                my @headers;
                my $fasta = Bio::SeqIO->new(-format => 'fasta', -file => $file);
                while (my $io_obj = $fasta -> next_seq() ) {
                        my $header = $io_obj->id();
                        my $seq = $io_obj->seq();
                        $len = $io_obj->length();
                        #print "$header\t$line\n";
                        push (@headers, $header);
                        $seqs{$header} = $seq;
                        }
                        if ($taxa ~~ @headers) {
                        #       print "match\t";
                                print OUT "$seqs{$taxa}";
                                }
                        else {
                        #       print "$taxa has no match\n";
                                my $gaps = ("-" x $len);
                                print OUT "$gaps";
                                }
                        }
                
        print OUT "\n";
}
