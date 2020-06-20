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
use BRIANG::Utils qw'timestamp';

use Test::More;
use Test::Exception;

timestamp(
    epoch  => 1000000000,
    format => ' ... ',
    local  => 0,
    time   => [  ],
);

# formats:
#
# G or U GMT aka UTC (default)
# L      local time
# D      YYYYMMDD only
# T      HHMMSS only

say scalar gmtime    1_500_000_000; # Fri Jul 14 02:40:00 2017
say scalar localtime 1_500_000_000; # Fri Jul 14 03:40:00 2017

pass; # XXX

done_testing;
