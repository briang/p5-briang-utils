#!/usr/bin/env perl

use strict;  use warnings;

BEGIN {
    if ($ENV{INSIDE_EMACS}) {
        chdir '..' until -d 't';
        use lib 'lib';
    }
}
################################################################################
use Test::More;

use BRIANG::Utils qw'lcm';

# mostly taken from lcm pages of wikipedia

is lcm( 2,   5),  10, "lcm( 2, 5) = 10";
is lcm( 4,   6),  12, "lcm( 4, 6) = 12";
is lcm(21,   6),  42, "lcm(21, 6) = 42";
is lcm(48, 180), 720, "lcm(48, 180) = 720";

# negative args
is lcm(-4,  6), 12, "lcm(-4,  6), 12";
is lcm( 4, -6), 12, "lcm( 4, -6), 12";
is lcm(-4, -6), 12, "lcm(-4, -6), 12";

# varadic
is lcm(), undef, "lcm() = undef";
is lcm(23), 23,  "lcm(23) = 23";
is lcm(lcm(8, 9), 21), 504, "lcm(lcm(8, 9), 21) = 504";
is lcm(8, 9, 21), 504, "lcm(8, 9, 21) = 504";
is lcm(lcm(8, 9), lcm(21, 22)), 5544, "lcm(lcm(8, 9), lcm(21, 22)) = 5544";
is lcm(8, 9, 21, 22), 5544, "lcm(8, 9, 21, 22) = 5544";

done_testing;
