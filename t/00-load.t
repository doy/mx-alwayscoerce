#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'MooseX::AlwaysCoerce' );
}

diag( "Testing MooseX::AlwaysCoerce $MooseX::AlwaysCoerce::VERSION, Perl $], $^X" );
