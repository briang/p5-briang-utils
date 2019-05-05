#!/usr/bin/env perl

use 5.10.1;
use strict;  use warnings FATAL => 'all';

BEGIN {
    if ($ENV{EMACS}) {
	chdir '..' until -d 't';
	use lib 'lib';
    }
}

use Data::Dump;
################################################################################
use BRIANG::Utils qw'normal_cdf';

use Test::More;
use Test::Exception;

sub round {
    my ($f, $dp) = @_;
    return 1 * sprintf "%.${dp}f", $f;
}

if ( $POSIX::VERSION < 1.5301 ) {
    plan skip_all => "POSIX 1.5301 required for erf(), $POSIX::VERSION installed";
}

throws_ok { normal_cdf()            } qr'invalid number of arguments';
throws_ok { normal_cdf(1,2)         } qr'invalid number of arguments';
throws_ok { normal_cdf(1,2,3,4)     } qr'invalid number of arguments';
throws_ok { normal_cdf(1,2,3,4,5,6) } qr'invalid number of arguments';
throws_ok { normal_cdf(1,foo=>2)    } qr'invalid option';

{
    my @tests = (
        [ -1  , 4, 0.6827 ],
        [  0.1, 4, 0.0797 ],
        [  1  , 4, 0.6827 ],
        [  2  , 4, 0.9545 ],
        [  3  , 4, 0.9973 ],
        [  4  , 4, 0.9999 ],
        [  5  , 5, 1 ],
    );

    for my $test ( @tests ) {
        my ($x, $dp, $pr) = @$test;
        my $cdf = normal_cdf($x);
        is round($cdf, $dp), $pr, "normal_cdf($x)";
    }
}

{
    my @tests = (
        [ -2  , 4, 0.0228  ],
        [ -1  , 4, 0.1587  ],
        [  0.1, 4, 0.5398  ],
        [  1  , 4, 0.8413  ],
        [  2  , 4, 0.9772  ],
        [  3  , 4, 0.9987  ],
        [  4  , 5, 0.99997 ],
        [  5  , 5, 1       ],
    );

    for my $test ( @tests ) {
        my ($x, $dp, $pr) = @$test;
        my $cdf = normal_cdf($x, from_neginf=>1);
        is round($cdf, $dp), $pr, "normal_cdf($x, neginf)";
    }
}

done_testing;

__END__
            self.assertAlmostEqual(0.0228, cdf(-2, from_neginf=True), places=4)
            self.assertAlmostEqual(0.1587, cdf(-1, from_neginf=True), places=4)
            self.assertAlmostEqual(0.9772, cdf( 2, from_neginf=True), places=4)
            self.assertAlmostEqual(0.9987, cdf( 3, from_neginf=True), places=4)
            self.assertAlmostEqual(1.0000, cdf( 4, from_neginf=True), places=4)
            self.assertAlmostEqual(1.0000, cdf( 7, from_neginf=True), places=7)
