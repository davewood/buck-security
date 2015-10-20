#!/usr/bin/perl

use strict;
use warnings;

use File::Spec;

package exceptions;

# exceptions.pm


# GetExceptions
# Takes file with exceptions, reads it, get exceptions and return them as array
# See Perl Cookbook 8.16

sub GetExceptions {
    my $config_file = shift;
    my $outcome_type = shift;
    open( CONFIG, "<", $config_file )
      or die "Couldn't read $config_file: $!\n";

    my @exceptions = <CONFIG>;
    @exceptions = grep { $_ !~ /^#/ && $_ !~ /^\s+$/ }
      @exceptions;    # no comments (starting with #) or empty lines

# removing any comments at the end of lines (for example: alice  #admin rights for alice allowed)
    foreach (@exceptions) {
        chomp;
        s/#.*//;
    }

    if ( $outcome_type eq "abspath" && $Config::sysroot ne "/" ) {
        @exceptions = map { File::Spec->catfile( $Config::sysroot, substr ( $_, 1) ) } @exceptions;
    }

    return @exceptions;
}

# CheckAgainstExceptions
# Checks alarms against exceptions
# if outcome is left after checking against exceptions, returns outcome in @outcomes
# if nothing left returns @outcomes = 0
# needs $outcome as argument

sub CheckAgainstExceptions {
    my $alarms_ref = shift;
    my @alarms = @{$alarms_ref};
    my $exception_file = shift;
    my $outcome_type = shift;
    # EXCEPTION PROCESSING
    # get exceptions and alarms and compare: @outcomes = alarms which are no exceptions
    # Code found at http://www.perlmonks.org/?node_id=2461

    $exception_file  = File::Spec->catfile( $Config::buck_root, $exception_file );

    # only if exception file exists
    if (-e $exception_file) {
        my @exceptions = GetExceptions($exception_file, $outcome_type);

        if ( $outcome_type eq "abspath" ) {
            my @all_exceptions;
            foreach my $exception (@exceptions) {
                @all_exceptions = ( @all_exceptions, glob ( $exception ) );
            }
            @exceptions = @all_exceptions;
        }

        my %exceptions = map { $_ => 1 } @exceptions;
        @alarms = grep( !defined $exceptions{$_}, @alarms );
    }


    return @alarms;

}


1;
