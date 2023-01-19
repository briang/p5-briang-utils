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

use BRIANG::Utils qw'uniq_keep_last';

is_deeply [ uniq_keep_last(qw(     ))   ], [ qw(     ) ], 'empty list';
is_deeply [ uniq_keep_last(qw(1 2 3))   ], [ qw(1 2 3) ], '(1 2 3)';
is_deeply [ uniq_keep_last(qw(3 2 1))   ], [ qw(3 2 1) ], '(3 2 1)';
is_deeply [ uniq_keep_last(qw(1 1 2 3)) ], [ qw(1 2 3) ], '(1 1 2 3)';
is_deeply [ uniq_keep_last(qw(1 2 1 3)) ], [ qw(2 1 3) ], '(1 2 1 3)';
is_deeply [ uniq_keep_last(qw(1 2 3 1)) ], [ qw(2 3 1) ], '(1 2 3 1)';

done_testing;
