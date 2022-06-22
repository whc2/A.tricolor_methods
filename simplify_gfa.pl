#!/usr/bin/perl -w
use strict;
use Data::Dumper;

# This program is used to remove branch and circular edges in gfa.
#
my $gfa1 = shift;

my %Edges;	# edges number of each contig
my %Unstrand;
my %Num;

open IN1, $gfa1 || die "fail open $gfa1\n";
while(<IN1>) {
	chomp;

	if($_ =~ /^S/) {
		next;
	} else {
		my ($ctg_id1, $strand1, $ctg_id2, $strand2) = (split /\s+/,$_)[1, 2, 3, 4];

		my $pos1 = ($strand1 eq "+") ? "tail" : "head";
		my $pos2 = ($strand2 eq "+") ? "head" : "tail";
		if(! defined $Num{$ctg_id1 . "_" . $pos1}) {
			$Num{$ctg_id1 . "_" . $pos1} = 1;
		} else {
			$Num{$ctg_id1 . "_" . $pos1}++;
		}
		if(! defined $Num{$ctg_id2 . "_" . $pos2}) {
			$Num{$ctg_id2 . "_" . $pos2} = 1;
		} else {
			$Num{$ctg_id2 . "_" . $pos2}++;
		}

		if(! defined $Unstrand{$ctg_id1 . "_" . $ctg_id2}) {
			$Unstrand{$ctg_id1 . "_" . $ctg_id2} = 1;
		} else {
			$Unstrand{$ctg_id1 . "_" . $ctg_id2} ++;
		}
	}
}
close IN1;
#print Dumper \%Num;

my %Del;
foreach my $tmp (sort keys %Num) {
	#print "$tmp\t";
	my $cnt = $Num{$tmp};
	if($cnt > 1) {
		$Del{$tmp} = 1;
	}
	#print "$cnt\n";
}

my %Delete1;
foreach my $pair (sort keys %Unstrand) {
	my $num = $Unstrand{$pair};
	if($num > 1) {
		$Delete1{$pair} = 1;
	}
}

open IN1, $gfa1 || die "fail open $gfa1\n";
while(<IN1>) {
	chomp;

	if($_ =~ /^S/) {
		print "$_\n";
	} else {
		my ($ctg_id1, $strand1, $ctg_id2, $strand2) = (split /\s+/,$_)[1, 2, 3, 4];
		
		my $pos1 = ($strand1 eq "+") ? "tail" : "head";
		my $pos2 = ($strand2 eq "+") ? "head" : "tail";

		if((exists $Del{$ctg_id1 . "_" . $pos1}) || (exists $Del{$ctg_id2 . "_" . $pos2}) || ($Delete1{$ctg_id1 . "_" . $ctg_id2})) {
			next;
		} else {
			print "$_\n";
		}
	}
}
close IN1;
