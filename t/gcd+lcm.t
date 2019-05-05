#!/usr/bin/env perl

use 5.10.1;

use strict;  use warnings;  use autodie qw/:all/;

BEGIN {
    if ($ENV{EMACS}) {
        chdir '..' until -d 't';
        use lib 'lib';
    }
}

use Data::Dump;

if (0) {
    no strict 'refs';
    diag($_), $_->() for grep { /^test_/ } keys %::
}
################################################################################
use lib 'lib';
use Test::More;

use BRIANG::Utils qw'gcd lcm';

# mostly taken from gcd & lcm pages of wikipedia

note "gcd()";

is gcd(18,  84),  6, "gcd(18, 84) = 6";
is gcd(42,  56), 14, "gcd(42, 56) = 14";
is gcd(48, 180), 12, "gcd(48, 180) = 12";

# negative args
is gcd(-48,  180), 12, "gcd(-48,  180) = 12";
is gcd( 48, -180), 12, "gcd( 48, -180) = 12";
is gcd(-48, -180), 12, "gcd(-48, -180) = 12";

# varadic args
is gcd(),                       undef, "gcd() = undef";
is gcd(18),                     18,    "gcd(18) = 18";
is gcd(24*2, 24*5, 24*3),       24,    "gcd(24*2, 24*5, 24*3) = 24";
is gcd(24*2, 24*5, 24*3, 12*3), 12,    "gcd(24*2, 24*5, 24*3, 12*3) = 12";

note "lcm()";

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
