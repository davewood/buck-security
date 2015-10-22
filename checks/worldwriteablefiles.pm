package worldwriteablefiles;

use strict;
use warnings;

use File::Spec;

use lib::check;    # for the "real" check Sub


sub check {
    use lib::check;

    my $title = "World Writeable Files";
    my $package_name = "worldwriteablefiles";
    my $exception_file = "conf/whitelists/worldwriteablefiles-whitelist.conf";
    my $outcome_type = "abspath";
    my $help = <<HELP;
The following files are writeable for all users.
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

    my $command = "find " . join( " ", @directories ) . " -perm -2 -type f";

    @directories = `$command`;
    chomp( @directories );

    return ( 0, @directories );
}

1;
