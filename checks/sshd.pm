#!/usr/bin/perl

use strict;
use warnings;

package sshd;

# just forwarding to the "real" CheckPerl Sub with variables
# title, filename of this file, exception file and error level
sub check {
    use lib::check;

    # the title of the check for the output
    my $title           = "Check if sshd is secured";                      
    # the filename of this file
    my $package_name        = "sshd";
    # the exception file
    my $exception_file  = "conf/whitelists/sshd-whitelist.conf";

    my $outcome_type = "other";

    # help - information about the check
    my $help = <<HELP;
The following sshd options aren't set to a secure value.
HELP


    check::CheckPerl( $title,
                      $package_name,
                      $outcome_type,
                      $exception_file,
                      $help );
}



sub perl {

######################################
# CHECK START
# HERE IS THE PERL CODE FOR THE CHECK
# returns results as list  in @outcomes
use readconfig;


my $config_file = $Config::ssh_config;
if ( ! -f $Config::ssh_config ) {
    return ( 1, @ { [ "sshd configuration file $Config::ssh_config not found." ] } );
}

my %SSHConfig = readconfig::ReadConfig($config_file, ' '); # separator is whitespace
my @outcomes;

# Data
# set value from config, default value and good value
# if default is not good then good is set to not_default
my %Data = (
    PermitEmptyPasswords => {
        set     => $SSHConfig{'PermitEmptyPasswords'},
        default => "no",
        good    => "no",
    },
    PermitRootLogin => {
        set     => $SSHConfig{'PermitRootLogin'},
        default => "no",
        good    => "no",
    },
    Port => {
        set     => $SSHConfig{'Port'},
        default => "22",
        good    => "not_default", # default Port 22 is not good
    },
    Protocol => {
        set     => $SSHConfig{'Protocol'},
        default => "2",
        good    => "2",
    },
    TCPKeepAlive => {
        set     => $SSHConfig{'TCPKeepAlive'},
        default => "yes",
        good    => "yes",
    },
    UsePrivilegeSeparation => {
        set     => $SSHConfig{'UsePrivilegeSeparation'},
        default => "yes",
        good    => "yes",
    },
);

# run through all options that shall be checked
while ( my ($k,$v) = each %Data ) {
    # get values
    my $set = $Data{$k}{'set'} ? $Data{$k}{'set'} : 0; # set is value or if its not set in config its set to 0
    my $default = $Data{$k}{'default'};
    my $good = $Data{$k}{'good'};
    
    # if default is bad, then check if set to a non-default value
    if ($good eq 'not_default') {
        unless (($set) && ($set ne $default)) {
            push(@outcomes, $k);
        }
    }
    # else check if they are set to a secure value OR if they are not set and the default is good
     else {
        unless (($set eq $good) || (!$set && $default eq $good)) {
            push(@outcomes, $k);
        }
    }
}


#
# CHECK END
######################################
return ( 0, @outcomes );
}

1;
