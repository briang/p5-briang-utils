use strict; use warnings;

use Test::Strict;

require Devel::Cover; # needs to be found as a prereq for REQUIREMENTS

$Test::Strict::TEST_SYNTAX   = 1;
$Test::Strict::TEST_STRICT   = 1;
$Test::Strict::TEST_WARNINGS = 1; # default = 0

all_perl_files_ok();
all_cover_ok(80, 't');
