#!/usr/bin/perl

use strict;
use warnings;
use lib::exceptions;    # include exceptions sub to filter exceptions

package check;

# check.pm
# executes Bash-Oneliners
# Gets Title and command, returns Title, Result (0 or 1 where 0 is good) , the test that was run, the help text, the outcomes, and the errors

sub CheckBash {
    my $title          = shift;
    my $security_test_ref  = shift;
    my $outcome_type = shift;
    my $exception_file = shift;
    my $help = shift;
    my @outcomes;
    my $security_test = $security_test_ref->();

    my @errors = `$security_test 3>&1 1>/dev/null 2>&3`;

    if ( @errors ) {
        return ( $title, 2, $help, \@errors );
    }

    @outcomes = `$security_test 2> /dev/null`;    # execute test and save outcome WITHOUT errors
    chomp(@outcomes);

    # Now check outcome against exceptions
    @outcomes = exceptions::CheckAgainstExceptions(\@outcomes,
                                                   $exception_file,
                                                   $outcome_type);

    if ( ! @outcomes ) {
        return ( $title, 0 );
    }

    # found something which wasn't in the exceptions from config, return it
    else {
        return ( $title, 1, $help, \@outcomes, $outcome_type );
    }
}

sub CheckPerl {
    my $title = shift;
    my $package_name = shift;
    my $outcome_type = shift;
    my $exception_file = shift;
    my $help = shift;
    my @outcomes;
    my $mod = $package_name . '.pm';

    # excute the check in file at /checks, @outcomes is defined there    
    require $mod;
    
    my ( $result, @details ) = $package_name->perl();

    if ( $result == 1 ) {
        return ( $title, 2, $help, \@details );
    }
    if ( ! @details ) {
        return ( $title, 0 );
    }

    # Now check outcome against exceptions
    @outcomes = exceptions::CheckAgainstExceptions(\@details,
                                                   $exception_file,
                                                   $outcome_type);
    
    # if nothing left, return 0 and exit
    if ( ! @outcomes ) {
        return ( $title, 0 );
    }

    # found something which wasn't in the exceptions from config, return it
    else {
        return ( $title, 1, $help, \@outcomes, $outcome_type );
    }

}


1;
