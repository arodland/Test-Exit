#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

use Test::Exit;

our $tried_to_exit;
BEGIN {
	no warnings 'redefine';
	*CORE::GLOBAL::exit = sub { $tried_to_exit++ };
}

exits_ok { exit 1 } "our exit handler is still in place";
ok( ! $tried_to_exit, "preexisting exit handler not called (dang)" );
