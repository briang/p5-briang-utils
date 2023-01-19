#!/usr/bin/env perl

use strict;  use warnings;

use Test::More;

use File::Find::Rule;
use FindBin '$Bin';

my @modules = map { "Data::$_" } qw(Dump Dumper);
my $RE = '\b(' . (join '|', @modules) . ')\b';

my $root = "$Bin/..";

my @fails;
for my $file ( sort { lc $a cmp lc $b }
               grep { !m{/.git/} && m{\.(:?PL|t|pm|pl)$} }
               File::Find::Rule->file->in($root) ) {
    open my $fh, "<", $file
        or do {
            push @fails, qq(cannot open "$file");
            next;
        };

    while (<$fh>) {
        push @fails, qq("$1" found in "$file", line $.) and next
            if /$RE/;
    }
}

ok !@fails, "No debugging files found";

if (@fails) {
    note $_ for @fails;
}

done_testing;
