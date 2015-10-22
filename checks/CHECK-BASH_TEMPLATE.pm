package !PACKAGENAME;

use strict;
use warnings;
use lib::check;    # for the "real" check Sub

my $title         = "TODO_TITLE";      # title of the test
my $security_test = "TODO_COMMAND";    # the security test
my $exception_file =
  "conf/whitelists/TODO_FILE-whitelist.conf";    # the file with exceptions
my $outcome_type = "abspath or other"; # the type of the expected outcome

# help - information about the check
my $help = <<'HELP';
TODO_INFORMATION
HELP



# just forwarding to the "real" check Sub with variables
sub check {
    check::CheckBash( $title,
                      $security_test,
                      $outcome_type,
                      $exception_file,
                      $help );
}

1;
