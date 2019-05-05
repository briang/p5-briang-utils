use 5.10.1;
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
    MIN_PERL_VERSION => 5.10.1,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'BRIANG-Utils-*' },
);

sub MY::postamble {
    return <<'MAKE_FRAG';

.PHONY: trial

trial: dist
	mv $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME)-TRIAL.tar$(SUFFIX)

MAKE_FRAG
}
