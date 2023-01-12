#!/usr/bin/env perl

use 5.10.1;
use strict;  use warnings FATAL => 'all';

BEGIN {
    if ($ENV{INSIDE_EMACS}) {
        chdir '..' until -d 't';
        use lib 'lib';
    }
}
################################################################################
use lib 'lib';
use Test::More;

use BRIANG::Utils qw'frac';

my @tests =
    map {
        my ($arg,   $exp  ) = @$_;
        my ($arg_e, $exp_e) = map { eval } @$_;
        [ $arg_e, $exp_e, "frac($arg) is $exp" ] }
    [ 0,            0     ],
    [ 0.5,          0.5   ],
    [-0.5,         -0.5   ],
    ['4/3',        '1/3'  ],
    ['-5/3',       '-2/3' ],
    ['1e15+1/8',   '1/8'  ],
    ['2**50+1/8',  '1/8'  ],
    ['-2**50-1/8', '-1/8' ],
    ;;

is frac($_->[0]), $_->[1], $_->[2] for @tests;

done_testing;
