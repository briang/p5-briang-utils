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
use Test::Exception;

use BRIANG::Utils qw'fact ncr npr';

note "fact()";

throws_ok { fact(-3) } qr/^Can't take fact of -3/, "fact(-3) throws an exception";

for ( [0, 1],  [1, 1],  [2, 2],  [6, 720], [3.01, 6], [3.99, 6]) {
    my ($arg, $exp) = @$_;
    is fact($arg), $exp, "factorial($arg) is $exp";
}

note "ncr()";

for ( [52, 5, 2_598_960], [10, 5, 252]) {
    my ($from, $choose, $exp) = @$_;
    is ncr($from, $choose), $exp, "ncr($from, $choose) is $exp";
}

note "npr()";

for ( [16, 3, 3_360], [10, 3, 720],  [26, 4, 358_800] ) {
    my ($from, $choose, $exp) = @$_;
    is npr($from, $choose), $exp, "npr($from, $choose) is $exp";
}

done_testing;
