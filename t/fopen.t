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
use Test::Exception;

use BRIANG::Utils qw'fopen';

throws_ok { fopen()      } qr/^Can't open/, "fopen() throws an exception";
throws_ok { fopen(undef) } qr/^Can't open/, "fopen(undef) throws an exception";
throws_ok { fopen('X')   } qr/^Can't open/, "fopen('X') throws an exception";
throws_ok { fopen('>x') } qr/^filename \(.*?\)/, "fopen('>X') throws an exception";

{ my $f = fopen($0);
  ok <$f> =~ m{^#!/}, 'can read from an implicit read fopen()ed file' }

{ my $f = fopen($0, '<');
  ok <$f> =~ m{^#!/}, 'can read from an explicit read fopen()ed file';
}

lives_ok { my $f = fopen('/tmp/foo', '>') } 'can fopen() a file for writing';

done_testing;
