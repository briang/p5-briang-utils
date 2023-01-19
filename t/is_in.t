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

use BRIANG::Utils qw'is_in';

is is_in(), 'XXX', qq[is_in() is not implemented];

done_testing;
