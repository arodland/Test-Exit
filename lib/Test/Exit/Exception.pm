package Test::Exit::Exception;

# ABSTRACT: Exception class for Test::Exit

use strict;
use warnings;

sub new {
  my ($class, $exitval) = @_;
  return bless { exit_value => $exitval }, $class;
}

sub exit_value {
  return shift->{exit_value};
}

1;
