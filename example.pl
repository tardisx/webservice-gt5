#!/usr/bin/perl 

use strict;
use warnings;

use lib 'lib';

use WebService::GT5;

die "setup env" unless ($ENV{PSN_LOGINNAME} && $ENV{PSN_PASSWORD} && $ENV{PSN_PROFILE});

my $gt5 = WebService::GT5->new({loginName => $ENV{PSN_LOGINNAME},
                                 password => $ENV{PSN_PASSWORD}});

my $profile = $ENV{PSN_PROFILE};

use Data::Dumper;
$gt5->login();
my $profile = $gt5->profile($profile);
my $drivers = $gt5->get_driver_list($profile);
my $other_drivers = $gt5->get_driver_list('someone');
my $events = $gt5->get_events($profile);
my $event_id = $events->[0]->{id};
