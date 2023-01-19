use strict;  use warnings;

use Test::More;

use BRIANG::Utils qw'is_in';

is is_in(), 'XXX', qq[is_in() is not implemented];

done_testing;
