package Collectd::Plugins::RoomTemp;

use strict;
no strict "subs";
use Collectd qw (:all);
use Redis;

my $redis = Redis->new;

my $host = `hostname -f`;
chomp $host;

sub read
  {
  my $room_temp = $redis->get('usb-roomtemp'); # reading the device directly causes an underlying problem with the perl bindings in collectd or something deeper; a problem for another day. "Illegal seek."
  my $data = 
    {
    plugin => 'RoomTemp',
    type => 'roomtemp',
    time => time,
    interval => plugin_get_interval(),
    host => $host,
    values => [ $room_temp],
    };
  plugin_dispatch_values ($data);
  return 1;
  }

Collectd::plugin_register(Collectd::TYPE_READ, "RoomTemp", "read");

1;
