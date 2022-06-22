#!/usr/bin/perl -w
use strict;
use Data::Dumper;

# original name: linker_info3.pl
# This program reads bw_reads file from ctg_links.pl to get link information from between reads of two contigs.
# Usage: perl linker_info3.pl minimap2.paf.bw_reads > minimap2.paf.bw_reads.l
# Date: 20210906

my $inf = shift;

if (! $inf) {
	print("perl linker_info3.pl minimap2.paf.bw_reads > minimap2.paf.bw_reads.l\n");
	exit(1);
}

my %Reads;
open IN, $inf || die "fial open $inf\n";
while(<IN>) {
	chomp;
	my @t = split /\t/,$_;

	my ($read, $read_len) = split /,/,$t[0];

	print "$read\t$read_len\t";
	for(my $i=1; $i<@t; $i++) {
		my ($ctg, $ctg_len, $r_start, $r_end, $ctg_start, $ctg_end, $idn) = split /,/,$t[$i];

		# allow 1% contig length error
		my $err = $ctg_len * 0.01;
		next if(($ctg_start > $err) && ($ctg_end < $ctg_len - $err));

		# mark head and tail
		my $head = $ctg_start;
		my $tail = $ctg_len - $ctg_end;
		if($head < $tail) {
			$t[$i] = $t[$i] . ",head";
		} else {
			$t[$i] = $t[$i] . ",tail";
		}

		print "$t[$i]\t";
	}
	print "\n";
}
close(IN);