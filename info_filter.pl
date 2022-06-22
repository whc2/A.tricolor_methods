#!/usr/bin/perl -w
use strict;
use Data::Dumper;

# Original name: info_filter2.pl
# This program reads minimap2.paf.bw_reads.l file to filter alignment, keeping the best alignment of a read and contig.
# Usage: infor_filter2.pl minimap2.paf.bw_reads.l > minimap2.paf.bw_reads.l.f
# Date: 20210906

my $inf = shift;

if(! $inf) {
	print("Usage: infor_filter2.pl minimap2.paf.bw_reads.l > minimap2.paf.bw_reads.l.f\n");
	exit(1);
}

open IN, $inf || die "fial open $inf\n";
while(<IN>) {
	chomp;

	my @t = split /\t/,$_;
	next if(@t < 4);

	# use best alignment
	my %Max;
	my %max_len;
	for(my $i = 2; $i < @t; $i++) {
		my ($ctg, $start, $end) = (split /,/,$t[$i])[0, 2, 3];
		my $len = $end - $start;
		$max_len{$ctg} = 0 if(! exists $max_len{$ctg});
		if($len > $max_len{$ctg}) {
			$max_len{$ctg} = $len;
			$Max{$ctg} = $t[$i];
		}
	}
	my $ctg_num = keys %Max;

	next if($ctg_num == 1);

	print "$t[0]\t$t[1]\t";
	foreach my $ct (sort keys %Max) {
		print "$Max{$ct}\t";
	}
	print "\n";
}
close(IN);
