#!/usr/bin/perl

use strict;
use warnings;
use lib::check;    # for the "real" check Sub

package usermask;

my $title =
  "Check umask";    # title of the test
sub security_test {
  return 'umask';
}
my $exception_file =
  "conf/whitelists/usermask-whitelist.conf";    # the file with exceptions

my $outcome_type = "other";

# help - information about the check
my $help = <<HELP;
Your default permissions for new files is one
which has not been explicitly included in the whitelist.
HELP


# just forwarding to the "real" check Sub with variables
sub check {
    check::CheckBash( $title,
                      \&security_test,
                      $outcome_type,
                      $exception_file,
                      $help );
}

1;
