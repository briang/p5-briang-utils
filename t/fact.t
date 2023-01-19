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
use Test::Exception;

use BRIANG::Utils qw'fact';

throws_ok { fact(-3) } qr/^Can't take fact of -3/, "fact(-3) throws an exception";

for ( [0, 1],  [1, 1],  [2, 2],  [6, 720], [3.01, 6], [3.99, 6]) {
    my ($arg, $exp) = @$_;
    is fact($arg), $exp, "factorial($arg) is $exp";
}

done_testing;
