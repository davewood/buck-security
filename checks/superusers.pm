#!/usr/bin/perl

use strict;
use warnings;

use File::Spec;

use lib::check;    # for the "real" check Sub

package superusers;

sub check {

    my $title         = "Find superusers";
    my $package_name = "superusers";
    my $exception_file = "conf/whitelists/superusers-whitelist.conf";

    my $outcome_type = "other";
    my $help = <<HELP;
The following users have administrator rights.
HELP

    check::CheckPerl( $title,
                      $package_name,
                      $outcome_type,
                      $exception_file,
                      $help );
}


sub perl {
    use users;
    my @outcomes;

    my $PasswdFile = users::GetPasswdFile('passwd');

    if (! -f $PasswdFile ) {
        return ( 1, @ { ["Password file $PasswdFile does not exist."] } );
    }

    my $PASSWD;
    if (! open( $PASSWD, '<', $PasswdFile ) ) {
        return ( 1, @ { ["Error opening password file $PasswdFile."] } );
    }

    my @PasswdFile = <$PASSWD>;

    my %UsersPasswdNormal = users::PasswordsNormal(@PasswdFile);

    while ( my ($k,$v) = each %UsersPasswdNormal ) {
        if ( $v->{'userid'} =~ '00*' || $v->{'groupid'} =~ '00*' ) {
            push(@outcomes, $k);
        }
    }
    return ( 0, @outcomes );
}

1;
