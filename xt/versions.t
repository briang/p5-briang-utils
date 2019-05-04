#!/usr/bin/env perl

use 5.10.1;

use strict;  use warnings;  use autodie qw/:all/;

BEGIN {
    if ($ENV{EMACS}) {
	chdir '..' until -d 'lib';
	use lib 'lib';
    }
}

use Data::Dump;
################################################################################
use ExtUtils::MM;
use File::Find::Rule;

use Test::More;

my %versions;
my @pm_files = File::Find::Rule->file->name( '*.pm' )->in( 'lib' );
for my $pm_file (@pm_files) {
    my $our_version = MM->parse_version($pm_file);
    $versions{$pm_file}{OUR} = $our_version;

    my $pod_version = find_pod_version($pm_file);
    $versions{$pm_file}{POD} = $pod_version;
}

my %all_versions;
for my $file (sort keys %versions) {
    my $vo = $versions{$file}{OUR} // '';
    my $vp = $versions{$file}{POD} // '';
    $all_versions{$_} = 1 for $vo, $vp;

    ok $vo, "$file: \$VERSION declared ($vo)";
    ok $vp, "$file: VERSION in POD ($vp)";
    ok $vo eq $vp, "$file: versions consistent";
}

ok keys %all_versions == 1, "Versions consistent across distribution";

done_testing;



sub find_pod_version {
    open my $FH, "<", shift;

    my $inpod;
    while (<$FH>) { # ripped from ExtUtils::MM::parse_version()
        $inpod = /^=(?!cut)/ ? 1 : /^=cut/ ? 0 : $inpod;
        next unless $inpod;

        next unless /^version \s+ ([\w.]+)/ix;
        return $1 // undef;
    }

    return;
}
