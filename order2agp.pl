#!/usr/bin/perl -w
use strict;
use Data::Dumper;

# This takes len file and order file as input, and output a AGP file.

my $len_f = shift;
my $ord_f = shift;

my %Len;
open IN1, $len_f || die "fail open $len_f\n";
while(<IN1>) {
	chomp;
	my ($id, $len) = split /\t/,$_;
	$Len{$id} = $len;
}
close IN1;

my %Super;
open IN, $ord_f || die "fail open $ord_f\n";
while(<IN>) {
	chomp;
	next if($_ =~ /^#/);

	my ($cls, $ctg_num, $ctg_len, $rob, $ctgs) = split /\t/,$_;
	#$cls =~ s/Cluster_/sCtg_/g;
	$cls =~ s/Cluster_//g;
	my @t = split /;/,$ctgs;
	@{$Super{$cls}} = @t;
	#print "$cls\t$ctgs\n";
}
close IN;
#print Dumper \%Super;

my $cnt = 0;
print "SuperContig\tStart\tEnd\tOrder\tTag\tContig/Scaffold_ID\tContig/Caffold_start\tContig/Scaffold_end\tOrientation\n";
foreach my $sctg (sort {$a<=>$b} keys %Super) {
	
	# first ctg
	my $first = shift @{$Super{$sctg}};
	my $end1 = 0;
	my $end2 = 0;
	if($first =~ /(^ptg\w{6}l)([+-])/) {
		my ($ctg, $dire) = ($1, $2);
		$cnt++;
		print "sctg$sctg\t1\t$Len{$ctg}\t$cnt\tW\t$ctg\t1\t$Len{$ctg}\t$dire\n";
		$end1 = $Len{$ctg};
	}

	# other ctgs
	my $count = 1;
	foreach my $c (@{$Super{$sctg}}) {
		if($count == 1) {
			$end2 = $end1 + 100;
			$end1++;
			$cnt++;
			print "sctg$sctg\t$end1\t$end2\t$cnt\tU\tNA\t1\t100\tNA\n";
		} else {
			$end1 = $end2 + 1;
			$end2 = $end1 + 99;
			$cnt++;
			print "sctg$sctg\t$end1\t$end2\t$cnt\tU\tNA\t1\t100\tNA\n";
		}
		$count++;

		if($c =~ /(^ptg\w{6}l)([+-])/) {
			my ($ctg, $dire) = ($1, $2);
			$end1 = $end2 + 1;
			$end2 = $end2 + $Len{$ctg};
			$cnt++;
			print "sctg$sctg\t$end1\t$end2\t$cnt\tW\t$ctg\t1\t$Len{$ctg}\t$dire\n";
		}
	}
}
