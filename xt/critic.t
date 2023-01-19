use strict; use warnings;

use English qw(-no_match_vars);
use File::Spec;
use Test::More;

eval { require Test::Perl::Critic; };

if ( $EVAL_ERROR ) {
   my $msg = 'Test::Perl::Critic required to criticise code';
   plan( skip_all => $msg );
}

my $rcfile = File::Spec->catfile( 'xt', 'release', 'perlcriticrc' );
my @imports = (
    -e $rcfile  ?  ( -profile => $rcfile )  :  (),
    -severity => 4,
);
Test::Perl::Critic->import( @imports );
all_critic_ok();
