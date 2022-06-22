#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $len_f = shift;
my $count_f = shift;

my %Len;
open IN, $len_f || die "fail open $len_f\n";
while(<IN>) {
	chomp;
	my ($id, $len) = split /\t/,$_;
	$Len{$id} = $len;
}
close IN;
#print Dumper \%Len;

my %Sum;
my @Samples;
my %TPK;
open IN1, $count_f || die "fail open $count_f\n";
while(<IN1>) {
	chomp;
	my @t = split /\t/,$_;

	if($t[0] eq "gene_id") {
		shift @t;
		@Samples = @t;
	} else {
		my $gene = shift @t;
		my $gene_scale = $Len{$gene} / 1000;	# tpk
		for(my $i=0; $i<@t; $i++) {
			my $r_count = $t[$i];
			my $tpk = $r_count / $gene_scale;
			$Sum{$Samples[$i]} += $tpk;
			$TPK{$Samples[$i]}{$gene} = $tpk;
		}
	}
}
close IN1;
#print Dumper \@Samples;
#print Dumper \%TPK;

foreach my $sap (sort keys %Sum) {
	my $per_m = $Sum{$sap} / 1000000;
	$Sum{$sap} = $per_m;
}
#print Dumper \%Sum;

print "gene_id";
foreach my $sap (sort keys %TPK) {
	print "\t$sap";
}
print "\n";
#print "gene_id";
#foreach my $sap (@Samples) {
#	print "\t$sap";
#}
#print "\n";

my $sap1 = $Samples[0];
my $tp = $TPK{$sap1};
foreach my $g (sort keys %$tp) {
	print "$g";
	foreach my $sap (@Samples) {
		my $tpm = $TPK{$sap}{$g} / $Sum{$sap};		#TPM
		print "\t$tpm";
	}
	print "\n";
}
