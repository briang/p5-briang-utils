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

is timestamp(0    ), '19700101-000000', 'Start of the epoch';
is timestamp(1.5e9), '20170714-024000', 'UTC returned during BST';
is timestamp(1.2e9), '20080110-212000', 'UTC returned during GMT';

done_testing;
