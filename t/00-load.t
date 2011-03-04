#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WebService::GT5' ) || print "Bail out!
";
}

diag( "Testing WebService::GT5 $WebService::GT5::VERSION, Perl $], $^X" );
