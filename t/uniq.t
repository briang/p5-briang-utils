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
use BRIANG::Utils qw'uniq_keep_first uniq_keep_last';

use Test::More;

note 'uniq_keep_first';

is_deeply [ uniq_keep_first(qw(     ))   ], [ qw(     ) ], 'empty list';
is_deeply [ uniq_keep_first(qw(1 2 3))   ], [ qw(1 2 3) ], '(1 2 3)';
is_deeply [ uniq_keep_first(qw(1 1 2 3)) ], [ qw(1 2 3) ], '(1 1 2 3)';
is_deeply [ uniq_keep_first(qw(1 2 1 3)) ], [ qw(1 2 3) ], '(1 2 1 3)';
is_deeply [ uniq_keep_first(qw(1 2 3 1)) ], [ qw(1 2 3) ], '(1 2 3 1)';

note 'uniq_keep_last';

is_deeply [ uniq_keep_last(qw(     ))   ], [ qw(     ) ], 'empty list';
is_deeply [ uniq_keep_last(qw(1 2 3))   ], [ qw(1 2 3) ], '(1 2 3)';
is_deeply [ uniq_keep_last(qw(3 2 1))   ], [ qw(3 2 1) ], '(3 2 1)';
is_deeply [ uniq_keep_last(qw(1 1 2 3)) ], [ qw(1 2 3) ], '(1 1 2 3)';
is_deeply [ uniq_keep_last(qw(1 2 1 3)) ], [ qw(2 1 3) ], '(1 2 1 3)';
is_deeply [ uniq_keep_last(qw(1 2 3 1)) ], [ qw(2 3 1) ], '(1 2 3 1)';

done_testing;
