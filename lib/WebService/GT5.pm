package WebService::GT5;

use warnings;
use strict;

use WWW::Mechanize;
use URI::Escape;
use JSON qw/decode_json/;
use Carp qw/croak/;

=head2 new

Create a new WebService::GT5 object.

=cut

sub new {
  my ($class, $args) = @_;

  my $self = {};

  $self->{server} = $args->{server_url} || 'https://www.gran-turismo.com/hk';
  $self->{login}  = $args->{login_url}  || 'https://store.playstation.com/external/login.action';

  $self->{loginName} = $args->{loginName} || croak "must supply a loginName";
  $self->{password}  = $args->{password}  || croak "must supply a password";

  $self->{returnURL} = "$self->{server}/signin/index.do";

  $self->{mech}      = WWW::Mechanize->new();

  bless $self, __PACKAGE__;
  return $self;
}

=head2 login

Login to the web API.

=cut

sub login {
  my $self = shift;
  my $mech = $self->{mech};

  $mech->get($self->{login}) || croak "cannot get login page";
  $mech->submit_form(fields => {
    loginName => $self->{loginName},
    password  => $self->{password},
    returnURL => $self->{returnURL},
  }) || croak "cannot login";

  my $output = $mech->content;
  my ($href) = $output =~ /^parent.location.href=\"(.*?)\"/m;
  $href .= uri_escape($mech->uri);
  $mech->get($href);

  # now we can do JSON!
}

=head2 profile

Returns a users profile

=cut

sub profile {
  my $self = shift;
  my $psn  = shift;
  my $mech = $self->{mech};

  $mech->post($self->{server}."/api/gt5/profile/", [online_id => $psn]);

  if ($mech->success()) {
    my $json_str = $mech->content;
    return decode_json($json_str);
  }
  else {
    warn $mech->response->status_line();
    croak "something went wrong with profile call";
  }

}

=head2 get_driver_list

Returns the list of drivers.

=cut

sub get_driver_list {
  my $self = shift;
  my $psn  = shift;

  my $mech = $self->{mech};

  $mech->post($self->{server}."/api/gt5/remoterace/", [job => "2", online_id => $psn, '_' => ""]);

  if ($mech->success()) {
    my $json_str = $mech->content;
    return decode_json($json_str);
  }
  else {
    warn $mech->response->status_line();
    croak "something went wrong with remoterace call";
  }
}

=head2 reserve_driver

Reserve a driver for an upcoming race.

=cut

sub reserve_driver {
  my $self = shift;
  my $psn  = shift;
  my $driver_id = shift;

  my $mech = $self->{mech};

  $mech->post($self->{server}."/api/gt5/remoterace/", [job => "3", driver_id => $driver_id, online_id => $psn, '_' => ""]);

  if ($mech->success()) {
    my $json_str = $mech->content;
    return decode_json($json_str);
  }
  else {
    warn $mech->response->status_line();
    croak "something went wrong with remoterace call";
  }
}




=head1 NAME

WebService::GT5 - Interface with the Gran Turismo 5 Web API

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use WebService::GT5;

    my $api = WebService::GT5->new();
    $api->login() || die "could not login";
    my $profile = $api->profile();

    ...

=head1 AUTHOR

Justin Hawkins, C<< <justin at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-gt5 at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-GT5>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::GT5


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-GT5>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-GT5>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-GT5>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-GT5/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Justin Hawkins.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of WebService::GT5
