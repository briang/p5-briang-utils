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

use BRIANG::Utils qw'timestamp';

is timestamp(), 'XXX', qq[timestamp() is not implemented];

# timestamp(
#     epoch  => 1000000000,
#     format => ' ... ',
#     local  => 0,
#     time   => [  ],
# );

# formats:
#
# G or U GMT aka UTC (default)
# L      local time
# D      YYYYMMDD only
# T      HHMMSS only

# say scalar gmtime    1_500_000_000; # Fri Jul 14 02:40:00 2017
# say scalar localtime 1_500_000_000; # Fri Jul 14 03:40:00 2017

done_testing;
