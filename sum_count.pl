#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $files = shift;

my @Files;
open IN, $files || die "fail open $files\n";
while(<IN>) {
	chomp;
	push @Files, $_;
}
close IN;
#print Dumper \@Files;

my %Data;

foreach my $f (@Files) {
	my $base = $1 if($f =~ /^(\S+?)\./);
	open IN, $f || die "fail open $f\n";
	while(<IN>) {
		chomp;
		next if($_ =~ /^N_/);
		my ($gene, $read) = (split /\t/,$_)[0, 1];

		$Data{$gene}{$base} = $read;
	}
	close IN;
}

foreach my $gene (sort keys %Data) {
	my $tp = $Data{$gene};
	print "#gene_id";
	foreach my $sample (sort keys %$tp) {
		print "\t$sample";
	}
	print "\n";
	last;
}

foreach my $gene (sort keys %Data) {
	my $tp = $Data{$gene};
	print "$gene";
	foreach my $sample (sort keys %$tp) {
		my $read = $Data{$gene}{$sample};
		print "\t$read";
	}
	print "\n";
}
