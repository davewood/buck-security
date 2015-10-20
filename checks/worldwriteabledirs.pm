#!/usr/bin/perl

use strict;
use warnings;

use File::Spec;

use lib::check;    # for the "real" check Sub

package worldwriteabledirs;

sub check {

    my $title = "World Writeable Directories";
    my $package_name = "worldwriteabledirs";
    my $exception_file = "conf/whitelists/worldwriteabledirs-whitelist.conf";
    my $outcome_type = "abspath";
    my $help = <<HELP;
The following directories are writeable for all users.
HELP
    check::CheckPerl( $title,
                      $package_name,
                      $outcome_type,
                      $exception_file,
                      $help );
}


sub perl {

    my @directories = grep { ! ( $_ =~ m/\/proc$/ ) } glob( File::Spec->catfile( $Config::sysroot, "*" ) );
    if ( ! @directories ) {
        return ( 0, @directories );
    }

    my $command = "find " . join( " ", @directories ) . " -perm -o+w -type d";

    @directories = `$command`;
    chomp( @directories );

    return ( 0, @directories );
}

1;
