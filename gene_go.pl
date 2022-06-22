#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $inf = shift;

my %Genes;

open IN, $inf || die "fail open $inf\n";
while(<IN>) {
	chomp;

	my @t = split /\t/,$_;
	my $gene = shift @t;
	my $g = (split /\./,$gene)[0];
	
	push @{$Genes{$g}}, @t if(!exists $Genes{$g});
	
	#print "$g\n";
	#print "@t\n";
}
close IN;
#print Dumper \%Genes;

foreach my $g (sort keys %Genes) {
#	print "$g\n";
	my $tmp = $Genes{$g};
	foreach my $go (@$tmp) {
		print "$g\t$go\n";
	}
}
