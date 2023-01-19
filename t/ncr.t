use strict;  use warnings;

use Test::More;

use BRIANG::Utils qw'ncr';

for ( [52, 5, 2_598_960], [10, 5, 252]) {
    my ($from, $choose, $exp) = @$_;
    is ncr($from, $choose), $exp, "ncr($from, $choose) is $exp";
}

done_testing;
