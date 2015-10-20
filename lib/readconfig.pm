#!/usr/bin/perl

use strict;
use warnings;

package readconfig;

# readconfig.pm


# ReadConfig
sub ReadConfig {
    my $config_file = shift;
    my $separator = shift;
    my %Config;
    open(CONFIG, "<", $config_file)
         or die "Couldn' read file $config_file: $!\n";
    
    while (<CONFIG>) {
    #    chomp;                  # no newline
        s/#.*//;                # no comments
        s/^\s+//;               # no leading white
        s/\s+$//;               # no trailing white
        next unless length;     # anything left?
        my ($var, $value) = split(/\s*$separator\s*/, $_, 2);
        $Config{$var} = $value;
    } 
    
    close(CONFIG);
    return %Config;
}

1;
