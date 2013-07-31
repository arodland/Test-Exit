package Test::Exit;

# ABSTRACT: Test that some code calls exit() without terminating testing

use strict;
use warnings;

use Test::Exit::Exception;
use base 'Test::Builder::Module';

our @EXPORT = qw(exits_ok exits_zero exits_nonzero never_exits_ok);

# We have to install this at compile-time and globally.
# We provide one that does effectively nothing, and then override it locally.
# Of course, if anyone else overrides CORE::GLOBAL::exit as well, bad stuff happens.
our $exit_handler = sub { 
  CORE::exit $_[0];
};
BEGIN {
  *CORE::GLOBAL::exit = sub (;$) { $exit_handler->(@_ ? $_[0] : 0) };
}

=head1 SYNOPSIS

    use Test::More tests => 4;
    use Test::Exit;
    
    exits_ok { exit 1; } "exiting exits"
    never_exits_ok { print "Hi!"; } "not exiting doesn't exit"
    exits_zero { exit 0; } "exited with success"
    exits_nonzero { exit 42; } "exited with failure"

=head1 DESCRIPTION

Test::Exit provides some simple tools for testing that code does or does not 
call C<exit()>, while stopping code that does exit at the point of the C<exit()>.
Currently it does so by means of exceptions, so it B<will not function properly>
if the code under test calls C<exit()> inside of an C<eval> block or string.

The only criterion tested is that the supplied code does or does not call
C<exit()>. If the code throws an exception, the exception will be propagated
and you will have to call it yourself. C<die()>ing is not exiting for the
purpose of these tests.

=over 4

=cut

sub _try_run {
  my ($code) = @_;

  eval {
    local $exit_handler = sub { 
      die Test::Exit::Exception->new($_[0]);
    };
    $code->();
  };
  my $died = $@;

  if (!defined $died || $died eq "") {
    return undef;
  }

  unless (ref $died && $died->isa('Test::Exit::Exception')) {
    die $died;
  }

  return $died->exit_value;
}

=item B<exits_ok>

Tests that the supplied code calls C<exit()> at some point.

=cut

sub exits_ok (&;$) {
  my ($code, $description) = @_;

  __PACKAGE__->builder->ok(defined _try_run($code), $description);
}

=item B<exits_nonzero>

Tests that the supplied code calls C<exit()> with a nonzero value.

=cut

sub exits_nonzero (&;$) {
  my ($code, $description) = @_;

  __PACKAGE__->builder->ok(_try_run($code), $description);
}

=item B<exits_zero>

Tests that the supplied code calls C<exit()> with a zero (successful) value.

=cut

sub exits_zero (&;$) {
  my ($code, $description) = @_;
  
  my $exit = _try_run($code);
  __PACKAGE__->builder->ok(defined $exit && $exit == 0, $description);
}

=item B<never_exits_ok>

Tests that the supplied code completes without calling C<exit()>.

=cut

sub never_exits_ok (&;$) {
  my ($code, $description) = @_;

  __PACKAGE__->builder->ok(!defined _try_run($code), $description);
}

=back

=cut

1;
