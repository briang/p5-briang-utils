#!/usr/bin/env perl

use 5.10.1;
use strict;  use warnings;

BEGIN {
    if ($ENV{INSIDE_EMACS}) {
        chdir '..' until -d 't';
        use lib 'lib';
    }
}
################################################################################
use Test::More;

use BRIANG::Utils qw'gcd';

# mostly taken from gcd pages of wikipedia

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

done_testing;
