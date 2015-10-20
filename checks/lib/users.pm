#!/usr/bin/perl

use strict;
use warnings;

use File::Spec;

package users;

# users.pm
# includes subs for checking user specific stuff

sub GetPasswdFile {
    my $filename = $_[0];
    return File::Spec->catfile( $Config::sysroot, "etc/$filename" );
}


# get password items from /etc/passwd
sub PasswordsNormal {
    my %UserPasswordNormal; 
    my @passwd_file = $_[0];
    foreach my $line (@passwd_file) {
       $line =~
       /(.*):(.*):(.*):(.*):(.*):(.*):(.*)/;
       $UserPasswordNormal{$1} =
         {'password' => $2,
          'userid'   => $3,
          'groupid'  => $4,
          'info'     => $5,
          'home'     => $6,
          'shell'    => $7};
    }

    return %UserPasswordNormal;
}

# get password items from /etc/shadow
sub PasswordsShadow {
    my %UserPasswordShadow;
    my @passwd_file = $_[0];
    foreach my $line (@passwd_file) {
       $line =~
       /(.*):(.*):(.*):(.*):(.*):(.*):(.*):(.*):(.*)/;
       $UserPasswordShadow{$1} =
         {'password'      => $2,
          'days-passed'   => $3,
          'days-may'      => $4,
          'days-must'     => $5,
          'days-warn'     => $6,
          'days-forgive'  => $7,
          'days-disabled' => $8,
          'reserved'      => $9};
    }

    return %UserPasswordShadow;

}


sub Test {


my @test = UsersWithValidShell();
my %normal = PasswordsNormal();
my %shadow = PasswordsShadow();

while ( my ($k,$v) = each %normal ) {
    print "$k => $v\n";
}

while ( my ($k,$v) = each %shadow ) {
    print "$k => $v\n";
}


}




1;
