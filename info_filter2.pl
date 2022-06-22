#!/usr/bin/perl -w
use strict;
use Data::Dumper;
my $inf = shift;

# Original name: info_filter13.pl
#

open IN, $inf || die "fail oepn $inf\n";
while(<IN>) {
        chomp;
        my @t = split /\t/,$_;
        my $read = $t[0];
        my $read_len = $t[1];
        my $err = $read_len * 0.03;

        my ($ctg_l1, $s1, $e1) = (split /,/,$t[2])[1, 2, 3];
        my ($ctg_l2, $s2, $e2) = (split /,/,$t[3])[1, 2, 3];
        my $len1 = $e1 - $s1;
        my $len2 = $e2 - $s2;
        my $ctg_len = ($ctg_l1 + $ctg_l2) / 2;

        next if($len1 < 1000);
        next if($len2 < 1000);
        next if(($ctg_len > 1000000) && (($len1 < 10000) || ($len2 < 10000)));
	next if(($ctg_len < 1000000) && (($len1 < 4000) || ($len2 < 4000)));
	
        if($s1 < $s2) {
                print "$_\n" if(($e1 < $s2 + $err) && ($s2 - $e1 < $read_len * 0.34));
        }else {
                print "$_\n" if(($s1 > $e2 - $err) && ($s1 - $e2 < $read_len * 0.34));
        }
}
close(IN);
