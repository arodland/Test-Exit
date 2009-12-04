#!/usr/bin/perl
#
use strict;
use warnings;

use Test::More tests => 1 + 5;

BEGIN {
  use_ok( 'Test::Exit' );
}

# Test passes
exits_ok { exit 1; } "exits_ok";
exits_nonzero { exit 42; } "exits_nonzero";
exits_zero { exit 0; } "exits_zero";
never_exits_ok { 1; } "never_exits_ok";

exits_zero { exit; } "exit with no argument exits zero";

