## no critic (RequireUseStrict)
package Net::Proxy::Connector::tcp_balance;
{
  $Net::Proxy::Connector::tcp_balance::VERSION = '0.002';
}

## use critic (RequireUseStrict)
use strict;
use warnings;

require Net::Proxy::Connector::tcp;
use base "Net::Proxy::Connector::tcp";

sub connect {
    my @params = @_;
    my ($self) = shift @params;
    for ( sort {int(rand(3))-1} @{$self->{hosts}} ) {
        $self->{host} = $_;
        my $sock = eval { $self->SUPER::connect(@params); };
        return $sock if $sock;
    }

}

1;



=pod

=head1 NAME

Net::Proxy::Connector::tcp_balance

=head1 VERSION

version 0.002

=head1 SYNOPSIS

    # sample proxy using Net::Proxy::Connector::tcp_balance
    use Net::Proxy;
    use Net::Proxy::Connector::tcp_balance; # optional

    # proxy connections from localhost:6789 to remotehost:9876
    # using standard TCP connections
    my $proxy = Net::Proxy->new(
        {   in  => { type => 'tcp', port => '6789' },
            out => { type => 'tcp_balance', hosts => [ 'remotehost1', 'remotehost2' ], port => '9876' },
        }
    );
    $proxy->register();

    Net::Proxy->mainloop();

=head1 NAME

Net::Proxy::Connector::tcp_balance - connector for outbound tcp balancing and failover

=head1 DESCRIPTION 

C<Net::Proxy::Connector::tcp_balance> is an outbound tcp connector for C<Net::Proxy> that provides randomized load balancing and also provides failover when outbound tcp hosts are unavailable.

It will randomly connect to one of the specified hosts. If that host is unavailable, it will continue to try the other hosts until it makes a connection.

The capabilities of the C<Net::Proxy::Connector::tcp_balance> are otherwise identical to those C<Net::Proxy::Connector::tcp>

=head1 CONNECTOR OPTIONS

The connector accept the following options:

=head2 C<in>

=over 4

=item * host

The listening address. If not given, the default is C<localhost>.

=item * port

The listening port.

=back

=head2 C<out>

=over 4

=item * hosts

The remote hosts.  An array ref. 

=item * port

The remote port.

=item * timeout

The socket timeout for connection (C<out> only).

=back

=head1 AUTHOR

Jesse Thompson <zjt@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jesse Thompson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

# ABSTRACT: A Net::Proxy connector for outbound tcp balancing and failover

