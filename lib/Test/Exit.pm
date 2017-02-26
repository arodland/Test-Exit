package Test::Exit;

# ABSTRACT: Test that some code calls exit() without terminating testing
# VERSION
# AUTHORITY

use strict;
use warnings;

use Return::MultiLevel qw(with_return);
use base 'Test::Builder::Module';

our @EXPORT = qw(exit_code exits_ok exits_zero exits_nonzero never_exits_ok);

# We have to install this at compile-time and globally.
# We provide one that does effectively nothing, and then override it locally.
# Of course, if anyone else overrides CORE::GLOBAL::exit as well, bad stuff happens.
our $exit_handler = sub {
  CORE::exit $_[0];
};
BEGIN {
  *CORE::GLOBAL::exit = sub (;$) { $exit_handler->(@_ ? 0 + $_[0] : 0) };
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

=head1 FUNCTIONS

=head2 exit_code

Runs the given code. If the code calls C<exit()>, then C<exit_code> will
return a number, which is the status that C<exit()> would have exited with.
If the code never calls C<exit()>, returns C<undef>. This is the
L<Test::Fatal>-like interface. All of the other functions are wrappers for
this one, retained for legacy purposes.

=cut

sub exit_code(&) {
  my ($code) = @_;

  return with_return {
    local $exit_handler = $_[0];
    $code->();
    undef
  };
}

=head2 exits_ok

Tests that the supplied code calls C<exit()> at some point.

=cut

sub exits_ok (&;$) {
  my ($code, $description) = @_;

  __PACKAGE__->builder->ok(defined &exit_code($code), $description);
}

=head2 exits_nonzero

Tests that the supplied code calls C<exit()> with a nonzero value.

=cut

sub exits_nonzero (&;$) {
  my ($code, $description) = @_;

  __PACKAGE__->builder->ok(&exit_code($code), $description);
}

=head2 exits_zero

Tests that the supplied code calls C<exit()> with a zero (successful) value.

=cut

sub exits_zero (&;$) {
  my ($code, $description) = @_;
  
  my $exit = &exit_code($code);
  __PACKAGE__->builder->ok(defined $exit && $exit == 0, $description);
}

=head2 never_exits_ok

Tests that the supplied code completes without calling C<exit()>.

=cut

sub never_exits_ok (&;$) {
  my ($code, $description) = @_;

  __PACKAGE__->builder->ok(!defined &exit_code($code), $description);
}

1;
