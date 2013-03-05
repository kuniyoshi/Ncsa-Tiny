use strict;
use warnings;
use Ncsa::Tiny;
use Test::More tests => 12;

my $log = q{192.0.43.10 - - [06/Mar/2013:01:04:05 +0900] "GET http://example.com/ HTTP/1.1" 200 3774 "-" "Ncsa::Tiny/1.0"};

my $ref = Ncsa::Tiny::parse_line( $log );

is( $ref->ip, "192.0.43.10" );
is( $ref->id, q{-} );
is( $ref->name, q{-} );
is( $ref->date, "[06/Mar/2013:01:04:05 +0900]" );
is( $ref->method, "GET" );
is( $ref->url, "http://example.com/" );
is( $ref->version, "HTTP/1.1" );
is( $ref->query, "GET http://example.com/ HTTP/1.1" );
is( $ref->status, "200" );
is( $ref->size, "3774" );
is( $ref->referer, q{-} );
is( $ref->ua, "Ncsa::Tiny/1.0" );
