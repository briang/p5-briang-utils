use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'BRIANG::Utils',
    AUTHOR           => q{Brian Greenfield <briang@cpan.org>},
    VERSION_FROM     => 'lib/BRIANG/Utils.pm',
    ABSTRACT_FROM    => 'lib/BRIANG/Utils.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.12.5,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Config'              => 0,
        'File::Temp'          => 0,
        'lib'                 => 0,
        'strict'              => 0,
        'Test::Exception'     => 0,
        'Test::More'          => 0,
        'warnings'            => 0,
    },
    PREREQ_PM => {
        'Carp'     => 0,
        'Exporter' => 0,
        'parent'   => 0,
        'POSIX'    => 0, # but 1.43 needed for erf()
        'strict'   => 0,
        'warnings' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'BRIANG-Utils-*' },
);

sub MY::postamble {
    my $postamble = <<'MAKE_FRAG';
.PHONY: authortests cover trial

trial: dist
  mv $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME)-TRIAL.tar$(SUFFIX)

cover:
  PERL5OPT=-MDevel::Cover make test

authortests:
  prove -l xt
MAKE_FRAG

    $postamble =~ s/^[ ]+/\t/gm;

    return $postamble;
}
