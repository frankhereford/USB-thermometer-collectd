#!/usr/bin/perl

use strict;
no strict "subs";
use Redis;

my $redis = Redis->new;

while (sleep 10)
  {
  my $cmd = '/usr/local/bin/temper-poll';
  open(my $temp, "-|", $cmd);
  <$temp>;
  my $information = <$temp>;
  close $temp;
  $information =~ /Device #\d: ([\d\.]+)°C ([\d\.]+)°F/i;
  my $room_temp = $2;
  print $room_temp;
  $redis->setex('usb-roomtemp', 20, $room_temp);
  sleep 10;
  }
