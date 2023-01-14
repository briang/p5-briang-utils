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
use lib 'lib';
use Test::More;

use BRIANG::Utils qw'ncr';

for ( [52, 5, 2_598_960], [10, 5, 252]) {
    my ($from, $choose, $exp) = @$_;
    is ncr($from, $choose), $exp, "ncr($from, $choose) is $exp";
}

done_testing;
