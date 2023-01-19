use strict;  use warnings;

use Test::More;

use BRIANG::Utils qw'npr';

for ( [16, 3, 3_360], [10, 3, 720],  [26, 4, 358_800] ) {
    my ($from, $choose, $exp) = @$_;
    is npr($from, $choose), $exp, "npr($from, $choose) is $exp";
}

done_testing;
