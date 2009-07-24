package Test::Exit::Exception;
our $VERSION = '0.01';


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

__END__

=pod

=head1 NAME

Test::Exit::Exception - Exception class for Test::Exit

=head1 VERSION

version 0.01

=head1 AUTHOR

  Andrew Rodland <andrew@hbslabs.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by HBS Labs, LLC..

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut 


