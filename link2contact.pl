#!/usr/bin/perl -w
use strict;
use Data::Dumper;

# link2contact.pl ont_to_hifiasm.bam.paf.bw_reads.l3.f2.f13 > ont_to_hifiasm.bam.paf.bw_reads.l3.f2.f13.contact

my $inf = shift;

my %Contact;
open IN, $inf || die "fail open $inf\n";
while (<IN>) {
	chomp;
	my ($read, $read_len, $aln1, $aln2) = split /\t/,$_;
	
	my ($ctg1, $tag1) = (split /,/,$aln1)[0, -1];
	my ($ctg2, $tag2) = (split /,/,$aln2)[0, -1];

	$Contact{$ctg1}{$tag1}{$ctg2}{$tag2} ++;
}
close(IN);

print "#CtgId1\tCtgId2\tEndContact\tCtg1Pos\tCtg2Pos\n";
foreach my $ctg1 (sort keys %Contact) {
	my $tp1 = $Contact{$ctg1};
	foreach my $tag1 (sort keys %$tp1) {
		my $tp2 = $Contact{$ctg1}{$tag1};
		foreach my $ctg2 (sort keys %$tp2) {
			my $tp3 = $Contact{$ctg1}{$tag1}{$ctg2};
			foreach my $tag2 (sort keys %$tp3) {
				my $con = $Contact{$ctg1}{$tag1}{$ctg2}{$tag2};
				print "$ctg1\t$ctg2\t$con\t$tag1\t$tag2\n";
			}
		}
	}
}
