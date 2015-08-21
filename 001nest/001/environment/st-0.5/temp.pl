#!/usr/bin/env perl                                                             
use DateTime;
$| = 1;
my $tmux_out = '';
my $sensors_bin = '/usr/bin/sensors';
if (-e -x $sensors_bin) {
    my $sensors_out = `$sensors_bin`;
    if ($sensors_out =~ /temp1\:\s+\+(\d+)/s) {
        $tmux_out .= '|' . $1 . 'C| ';
    }
}
my $dt = DateTime->now->set_time_zone('America/Los_Angeles');
my $date_out = $dt->hour . ':' . sprintf("%02d",$dt->minute) .
    ' ' . $dt->month . '/' . $dt->day;
print $tmux_out . $date_out . "\n";