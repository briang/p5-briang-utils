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
use BRIANG::Utils 'extrapolate';

use Test::More qw(no_plan);

my $EPSILON = 0.001;

{
    note 'extrapolate() / interpolate()';

    my @tests = (
        [ [0, (0, 2), (10, 20) ] => 10 ],
        [ [1, (0, 2), (10, 20) ] => 15 ],
        [ [2, (0, 2), (10, 20) ] => 20 ],

        [ [-1, (0, 2), (10, 20) ] =>  5 ],
        [ [ 3, (0, 2), (10, 20) ] => 25 ],

        # input reversed
        [ [0, (2, 0), (10, 20) ] => 20 ],
        [ [1, (2, 0), (10, 20) ] => 15 ],
        [ [2, (2, 0), (10, 20) ] => 10 ],

        [ [-1, (2, 0), (10, 20) ] => 25 ],
        [ [ 3, (2, 0), (10, 20) ] =>  5 ],

        # output reversed
        [ [0, (0, 2), (20, 10) ] => 20 ],
        [ [1, (0, 2), (20, 10) ] => 15 ],
        [ [2, (0, 2), (20, 10) ] => 10 ],

        [ [-1, (0, 2), (20, 10) ] => 25 ],
        [ [ 3, (0, 2), (20, 10) ] =>  5 ],

        # both reversed
        [ [0, (2, 0), (20, 10) ] => 10 ],
        [ [1, (2, 0), (20, 10) ] => 15 ],
        [ [2, (2, 0), (20, 10) ] => 20 ],

        [ [-1, (2, 0), (20, 10) ] =>  5 ],
        [ [ 3, (2, 0), (20, 10) ] => 25 ],

        # reals
        [ [0.1, (0.2, 0.4), (1.2, 1.4) ] => 1.1 ],
        [ [0.2, (0.2, 0.4), (1.2, 1.4) ] => 1.2 ],
        [ [0.3, (0.2, 0.4), (1.2, 1.4) ] => 1.3 ],
        [ [0.4, (0.2, 0.4), (1.2, 1.4) ] => 1.4 ],
        [ [0.5, (0.2, 0.4), (1.2, 1.4) ] => 1.5 ],
    );

    ok \&BRIANG::Utils::extrapolate eq \&BRIANG::Utils::interpolate,
      "extrapolate() and interpolate() are the same thing";

    for my $test ( @tests ) {
        my ($args, $expected) = @$test;
        my $message =
          sprintf q'V=%.2f, IR=(%.2f - %.2f), OR=(%.2f - %.2f)', @$args;

        ok abs(extrapolate( @$args ) - $expected) < $EPSILON,
          defined $message ? $message : ();
    }
}

done_testing;
