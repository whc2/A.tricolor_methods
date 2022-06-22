#!/usr/bin/perl -w
use strict;
use Data::Dumper;

# original name: ctg_links2.pl
# This program reads paf file from minimap2 alignment and output reads mapped to two different ctgs. The idea is that the part between two contigs can be used to bridge these two contigs.
# Usage: ctg_link.pl mimimap2.paf > mimimap2.paf.bw_reads
# Date:	20210906

my $paf_f = shift;

if (! $paf_f) {
	print("Usage: ctg_link.pl mimimap2.paf > mimimap2.paf.bw_reads\n");
	exit(1);
}

my %Ctgs;
my %Reads;
my %Aln;

open IN, $paf_f || die "fail open $paf_f\n";
while(<IN>) {
	chomp;
	my ($read_id, $read_len, $r_start, $r_end, $strand, $ctg_id, $ctg_len, $c_start, $c_end, $match, $block, $qual) = split /\t/,$_;

	$Ctgs{$ctg_id} = $ctg_len if(! exists $Ctgs{$ctg_id});
	$Reads{$read_id} = $read_len if(! exists $Reads{$read_id});

	my $idn = sprintf("%.2f", $match / $block);

	# there are some alignments that same read mapped to same ctg with same start position.
	push @{$Aln{$ctg_id}{$read_id}{$r_start}}, "$r_end,$c_start,$c_end,$idn";
}
close(IN);


# Debug: alignment number should be equal to paf file.
=head
my $cnt = 0;
foreach my $ctg (keys %Aln) {
	my $tp = $Aln{$ctg};
	foreach my $r (keys %$tp) {
		my $tpp = $Aln{$ctg}{$r};
		foreach my $s (keys %$tpp) {
			my $tppp = $Aln{$ctg}{$r}{$s};
			foreach my $start (@$tppp) {
				$cnt++;
			}
		}
	}
}
print "$cnt\n";
=cut

my %Printed;
foreach my $ctg1 (sort keys %Ctgs) {
	my $tp1 = $Aln{$ctg1};
	foreach my $ctg2 (sort keys %Ctgs) {
		next if($ctg1 eq $ctg2);

		my $max = 0;
		foreach my $read1 (sort keys %$tp1) {
			my $tpp1 = $Aln{$ctg1}{$read1};
			if(exists $Aln{$ctg2}{$read1}) {
				my $tpp2 = $Aln{$ctg2}{$read1};

				print "$read1,$Reads{$read1}\t" if(! exists $Printed{$read1}{$ctg1}{$ctg2});
				foreach my $start1 (sort {$a<=>$b} keys %$tpp1) {
					my $tppp1 = $Aln{$ctg1}{$read1}{$start1};
					foreach my $aln1 (@$tppp1) {
						if(! exists $Printed{$read1}{$ctg1}{$ctg2}) {
							print "$ctg1,$Ctgs{$ctg1},$start1,$aln1\t";
						}
					}
				}

				foreach my $start2 (sort {$a<=>$b} keys %$tpp2) {
					my $tppp2 = $Aln{$ctg2}{$read1}{$start2};
					foreach my $aln2 (@$tppp2) {
						if(! exists $Printed{$read1}{$ctg1}{$ctg2}) {
							print "$ctg2,$Ctgs{$ctg2},$start2,$aln2\t";
						}
					}
				}
				if(! exists $Printed{$read1}{$ctg1}{$ctg2}) {
					print "\n";
					$Printed{$read1}{$ctg1}{$ctg2} = 1;
					$Printed{$read1}{$ctg2}{$ctg1} = 1;
				}

			} else {
				next;
			}
		}
	}
}