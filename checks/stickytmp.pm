package stickytmp;

use strict;
use warnings;
use File::Spec;
use lib::check;    # for the "real" check Sub


sub check {
    use lib::check;

    my $title = "Mode, user, and group acceptable for tmp directory.";
    my $exception_file = "conf/whitelists/stickytmp-whitelist.conf";
    my $package_name = 'stickytmp';
    my $outcome_type = "other";
    my $help = <<HELP;
The tmp directory has a mode, user, group combination which has
not been explicitly included in the whitelist.
HELP

    check::CheckPerl( $title,
                      $package_name,
                      $outcome_type,
                      $exception_file,
                      $help );
}


sub perl {
    use users;

    my $tmpdir = File::Spec->catdir($Config::sysroot, 'tmp');

    if ( ! -d $tmpdir ) {
        return ( 1,  @ { ["Specified tmpdir $tmpdir does not exist."] } );
    }

    my $command = 'ls -ld ' . $tmpdir;
    my $ls_pattern = '^([^\s]+) ([^\s]+) ([^\s]+) ([^\s]+)';
    my @outcomes = `$command`;
    chomp( @outcomes );
    if ( @outcomes != 1) {
        return ( 1, @ { ["ls -ld result has multiple lines."] } );
    }
    else {
        my $info = $outcomes[0];
        if ( $info =~ m/$ls_pattern/ ) {
            return ( 0, @ { ["$1:$3:$4"] } );
        }
        else {
            return ( 1,  @ { ["Format of ls -ld result $info is unexpected."] } );
        }
    }
}

1;
