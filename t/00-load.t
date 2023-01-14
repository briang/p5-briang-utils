#!perl

use 5.10.1;
use strict;  use warnings;

use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'BRIANG::Utils' ) || print "Bail out!\n";
}

diag( "Testing BRIANG::Utils $BRIANG::Utils::VERSION, Perl $], $^X" );
