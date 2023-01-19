use strict;  use warnings;

use Test::More;

my $MODULE = 'BRIANG::Utils';

eval qq(require $MODULE);

my %EXPORT_TAGS = do { no strict 'refs'; %{$MODULE."::EXPORT_TAGS"} };
my @EXPORT_OK   = do { no strict 'refs'; @{$MODULE."::EXPORT_OK"  } };

my %exports;
my @errors;

for my $exports ( values %EXPORT_TAGS ) {
    for my $export ( @$exports ) {
        if ( $export =~ /^[a-z_]/i ) { # exclude variables
            $exports{$export} = 1;
        }
    }
}
$exports{$_} = 1 for @EXPORT_OK;

for my $method (sort keys %exports) {
    can_ok $MODULE, $method;
}

done_testing;
