use strict;  use warnings;

use Test::More;
use Test::Exception;

use BRIANG::Utils qw'fopen';

throws_ok { fopen()      } qr/^Can't open/, "fopen() throws an exception";
throws_ok { fopen(undef) } qr/^Can't open/, "fopen(undef) throws an exception";
throws_ok { fopen('X')   } qr/^Can't open/, "fopen('X') throws an exception";
throws_ok { fopen('>x') } qr/^filename \(.*?\)/, "fopen('>X') throws an exception";

{ my $f = fopen($0);
  ok <$f> =~ m{^use strict;}, 'can read from an implicit read fopen()ed file' }

{ my $f = fopen($0, '<');
  ok <$f> =~ m{^use strict;}, 'can read from an explicit read fopen()ed file';
}

lives_ok { my $f = fopen('/tmp/foo', '>') } 'can fopen() a file for writing';

done_testing;
