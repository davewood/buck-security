package !PACKAGENAME;

use strict;
use warnings;


# just forwarding to the "real" CheckPerl Sub with variables
# title, filename of this file, exception file and error level
sub check {
    use lib::check;

    # the title of the check for the output
    my $title           = "TODO_TITLE";
    # the filename of this file
    my $package_name        = "TODO_PACKAGENAME";
    # the exception file
    my $exception_file  = "conf/whitelists/TODO_FILE-whitelist.conf";

    # the type of the expected outcome
    my $outcome_type = "abspath or other";

    # help - information about the check
    my $help = <<'HELP';
TODO_INFORMATION
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

TODO_COMMAND

#
# CHECK END
######################################
if ( $success ) {
    return ( 0, @outcomes );
}
else {
    return ( 1, @errors );
}
}

1;
