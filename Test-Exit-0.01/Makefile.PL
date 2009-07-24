
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Test-Exit',
  NAME      => 'Test::Exit',
  AUTHOR    => 'Andrew\ Rodland\ \<andrew\@hbslabs\.com\>',
  ABSTRACT  => 'Test\ whether\ code\ exits\ without\ terminating\ testing\.',
  VERSION   => '0.01',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Test::Builder" => '0.86',
  },
);
