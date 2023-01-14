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
use Test::Exception;

use BRIANG::Utils qw'last_n';

throws_ok { last_n()      } qr"not enough arguments";
throws_ok { last_n(undef) } qr"undefined argument";

is_deeply [ last_n(5) ],    [],  "empty list => empty list";
is_deeply [ last_n(5, 1) ], [1], "short list => short list";
is_deeply [ last_n(0, 1) ], [],  "last_n(0, ...) => empty list";
is_deeply [ last_n(-99, 1) ], [],  "last_n(-99, ...) => empty list";
is_deeply [ last_n( 2 => (1, 2, 3) ) ], [2, 3],  "last_n(2, ...) => last two";
is_deeply [ last_n( 5 => (1, 2, 3) ) ], [1, 2, 3], "large \$n => \@list";
is_deeply [ last_n( 3 => (1, 2, 3) ) ], [1, 2, 3], "exact \$n => \@list";

done_testing;
