package suids;

use strict;
use warnings;

use File::Spec;

use lib::check;    # for the "real" check Sub


sub check {
    use lib::check;

    my $title         = "Files where Setuid is used";
    my $package_name = "suids";
    my $exception_file = "conf/whitelists/suids-whitelist.conf";

    my $outcome_type = "abspath";

    my $help = <<HELP;
The following programs have the SUID set.
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

    my $command = "find " . join( " ", @directories ) . " -perm -4000 -type f";

    @directories = `$command`;
    chomp( @directories );

    return ( 0, @directories );
}

1;
