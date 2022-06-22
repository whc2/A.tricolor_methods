#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $red_f = shift;
my $grn_f = shift;

my %Count;
my @Samples;

open IN, $red_f || die "fail open $red_f\n";
while(<IN>) {
	chomp;
	my @t = split /\t/,$_;
	if($_ =~ /^gene_id/) {
		shift @t;
		@Samples = @t;
	} else {
		my $g = shift @t;
		for(my $i=0; $i<@t; $i++) {
			$Count{$g}{$Samples[$i]} = $t[$i];
		}
	}
}
close IN;
#print Dumper \@Samples;
#print Dumper \%Count;

my @Green;
open IN1, $grn_f || die "fail open $grn_f\n";
while(<IN1>) {
	chomp;
	my @t = split /\t/,$_;
	if($_ =~ /^gene_id/) {
		shift @t;
		foreach my $tp (@t) {
			$tp =~ s/g//g;
			push @Green, $tp;
		}
	} else {
		my $g = shift @t;
		for(my $i=0; $i<@t; $i++) {
			$Count{$g}{$Green[$i]} = $t[$i];
		}
	}
}
close IN1;
#print Dumper \@Green;
#print Dumper \%Count;

print "gene_id";
foreach my $sap (@Samples) {
	print "\t$sap";
}
print "\n";
foreach my $g (sort keys %Count) {
	my $tp = $Count{$g};
	print "$g";
	foreach my $sample (sort keys %$tp) {
		my $read = $Count{$g}{$sample};
		print "\t$read";
	}
	print "\n";
}
