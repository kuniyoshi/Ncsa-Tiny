package Ncsa::Tiny;
use strict;
use warnings;
use Exporter "import";
use Data::Dumper;
use List::MoreUtils qw( first_index );

use overload q{""} => \&stringify;

our @EXPORT_OK = qw( parse );
our $AUTOLOAD;

my @HEADERS = qw( ip id name d1 d2 query status size referer ua );
my %INDEX   = map { my $name = $_; $name => first_index { $_ eq $name } @HEADERS }
              qw( query referer ua );

sub parse { $_ = parse_line( $_ ) }

sub parse_line {
    my $line = shift;
    my %log;

    my @quoted_parts = $line =~ m{ ( [ ] ["] .*? ["] ) (?= [ ] | \z)}gmsx;

    for my $part ( @quoted_parts ) {
        substr $line, index( $line, $part ), length( $part ), q{};
        $part =~ s{\A [ ] ["] }{}msx;
        $part =~ s{ ["] \z}{}msx;
    }

    my @parts = split m{ }, $line, @HEADERS - @quoted_parts;

    splice @parts, $INDEX{query}, 0, shift @quoted_parts;
    push @parts, @quoted_parts; # referer, and ua is at bottom of the list.

    @log{ @HEADERS }                 = @parts;
    $log{date}                       = join q{ }, delete @log{ qw( d1 d2 ) };
    @log{ qw( method url version ) } = split m{ }, $log{query}, 3;

    return bless \%log, __PACKAGE__;
}

sub stringify {
    my $self = shift;
    return Data::Dumper->new( [ { %{ $self } } ] )->Terse( 1 )->Sortkeys( 1 )->Indent( 0 )->Dump;
}

sub AUTOLOAD {
    my $self = shift;
    ( my $property = $AUTOLOAD ) =~ s{.*::}{};
    return $self->{ $property };
}

1;
__END__
=head1 NAME

Ncsa::Tiny - Parses NCSA log

=head1 SYNOPSIS

  $ perl -MNcsa::Tiny=parse -lpe parse <ncsa.log>

=head1 DESCRIPTION

There are many module exist which parses log file.
But i want use it via perl one line command.

=head1 EXPORT

None by default.

=head1 SEE ALSO

=head1 AUTHOR

Kuniyoshi Kouji, E<lt>kouji@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Kuniyoshi Kouji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
