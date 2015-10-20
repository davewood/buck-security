#!/usr/bin/perl

use strict;
use warnings;

package checksum;

# just forwarding to the "real" CheckPerl Sub with variables
# title, filename of this file, exception file and error level
sub check {
    use lib::check;

    # the title of the check for the output
    my $title           = "Checksums of system programs";                      
    # the filename of this file
    my $package_name        = "checksum";
    # the exception file
    my $exception_file  = "conf/whitelists/checksum-whitelist.conf";

    my $outcome_type = "other";

    # help - information about the check
    my $help = <<HELP;
The checksums for the following files have changed
since you created them.
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
my $checksums_file = $Config::checksum_file;
my $checksums_prog = $Config::checksum_program;
# only if checksum file exists
if ( -f $checksums_file ) {
    print "\n------------------\nSTARTING CHECKSUM CHECK\nDecrypting checksum-file $checksums_file ...\n";
    my @outcomes = `gpg -d $checksums_file 2> /dev/null | $checksums_prog -cw | grep -v ": OK";`;
    return ( 0, @outcomes );
}
else {
    return ( 1, @ { ["Couldn't read $checksums_file: $!\n"] } );
}

}

1;
