use strict;  use warnings;

use Test::More;

use BRIANG::Utils qw'uniq_keep_first';

is_deeply [ uniq_keep_first(qw(     ))   ], [ qw(     ) ], 'empty list';
is_deeply [ uniq_keep_first(qw(1 2 3))   ], [ qw(1 2 3) ], '(1 2 3)';
is_deeply [ uniq_keep_first(qw(1 1 2 3)) ], [ qw(1 2 3) ], '(1 1 2 3)';
is_deeply [ uniq_keep_first(qw(1 2 1 3)) ], [ qw(1 2 3) ], '(1 2 1 3)';
is_deeply [ uniq_keep_first(qw(1 2 3 1)) ], [ qw(1 2 3) ], '(1 2 3 1)';

done_testing;
