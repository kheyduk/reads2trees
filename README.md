reads2trees
===========

Pipeline for analysis of sequence capture
Please see the manual (as of 12/31/14, in a somewhat beta phase) for detailed how-to. 
Individuals scripts may need to be modified to work on your computing cluster. These were designed for a linux cluster using SGE commands (qsub, qdel, etc). Furthermore, computing queue names are hard wired and YOU WILL NEED TO MODIFY THEM. For example, a script might say "qsub -q rcc-30d...", which is a queue on the UGA cluster. You will need to change this to reflect a queue on your own cluster.

Paths to programs are also hard coded. Where submission scripts are printed (toward the bottom of each perl script) you'll see the path to a program, typically starting with /usr/local.... Modify so it fits where your programs are. See below for list of required programs. 

As mentioned, these scripts are designed to process a large set of data relatively quickly (from reads to tree for ~70 taxa can take as little as a week and a half). This is accomplished by using parallel job submission on a multi-core computing cluster. If you do not have access to this, all scripts will need to be modified to remove "qsub" portions and reworked so they run serially. This will take a lot, lot longer. 

Required programs:
Perl, with BioPerl
Trimmomatic
Trinity
CAP3
BLAST
PRANK (or alternative aligner, but I highly recommend PRANK for this data)
GBlocks (optional)
RAxML
MP-EST (optional)

