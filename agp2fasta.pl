#!/usr/bin/perl -w
use strict;
use Data::Dumper;

# parse input options
if (not $ARGV[0] or $ARGV[0] eq "-h") {
	die "
	Description: read AGP produced by cluster2agp.pl and output the scaffold sequences in multi-line FASTA format.
	
	Author: Sen Wang, wangsen1993\@163.com, 2021/7/26.
	Modifier: whc, 20210909

	Usage: perl agp2fasta.pl gfa.cluster.agp contigs.fasta > gfa.cluster.agp.fasta
	\n";
}

# read contigs.fasta
my %Seqs;
my $header;
open IN, "<$ARGV[1]" or die "Cannot open $ARGV[1]!\n";
while (<IN>) {
	chomp;
	if (/^>(\w+)/) {
		$header = $1;
	} else {
		$Seqs{$header} .= $_;
	}
}
close IN;
#print Dumper \%Seqs;

# read cluster.agp
my $last = "not";
open IN, "<$ARGV[0]" or die "Cannot open $ARGV[0]!\n";
while (<IN>) {
	chomp;
	next if($_ =~ /^SuperContig/);

	my @f = split(/\t/, $_);
	my $cur = $f[0];

	if($cur eq $last) {
		my ($ctg, $dire) = ($f[5], $f[8]);
		if($dire eq '+') {
			print "$Seqs{$ctg}";
			delete $Seqs{$ctg};
		} elsif ($dire eq '-') {
			my $tem = $Seqs{$ctg};
			delete $Seqs{$ctg};
			$tem = reverse($tem);
			$tem =~ tr/ATCG/TAGC/;
			print "$tem";
		} else {
			my $tmp = "N" x $f[7];
			print "$tmp";
		}
	} elsif ($last eq "not") {
		print ">$cur\n";
		my ($ctg, $dire) = ($f[5], $f[8]);
		if($dire eq '+') {
			print "$Seqs{$ctg}";
			delete $Seqs{$ctg};
		} elsif ($dire eq '-') {
			my $tem = $Seqs{$ctg};
			delete $Seqs{$ctg};
			$tem = reverse($tem);
			$tem =~ tr/ATCG/TAGC/;
			print "$tem";
		}
	} else {
		print "\n>$cur\n";
		my ($ctg, $dire) = ($f[5], $f[8]);
		if($dire eq '+') {
			print "$Seqs{$ctg}";
			delete $Seqs{$ctg};
		} elsif ($dire eq '-') {
			my $tem = $Seqs{$ctg};
			delete $Seqs{$ctg};
			$tem = reverse($tem);
			$tem =~ tr/ATCG/TAGC/;
			print "$tem";
		}
	}
	$last = $cur;
}
close IN;

print "\n";

# output left contig sequences
foreach my $c (sort keys %Seqs) {
	print ">$c\n";
	print "$Seqs{$c}\n";
}
