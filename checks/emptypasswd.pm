#!/usr/bin/perl

use strict;
use warnings;

package emptypasswd;

# just forwarding to the "real" CheckPerl Sub with variables
# title, filename of this file, exception file and error level
sub check {
    use lib::check;

    # the title of the check for the output
    my $title           = "Users with empty password";                      
    # the filename of this file
    my $package_name        = "emptypasswd";
    # the exception file
    my $exception_file  = "conf/whitelists/emptypasswd-whitelist.conf";

    my $outcome_type = "other";

    # help - information about the check
    my $help = <<HELP;
The following users have empty passwords.
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

use users;

# that will be th list of the users with empty pw
my @UsersEmptyPasswd;

# users which are shadowed (x in /etc/passwd)
my @ShadowUsers;

my $PasswdFile = users::GetPasswdFile('passwd');

if (! -f $PasswdFile ) {
    return ( 1, @ { ["Password file $PasswdFile does not exist."] } );
}

my $PASSWD;
if ( ! open ( $PASSWD, '<', $PasswdFile) ) {
  return ( 1, @ { ["Password file $PasswdFile can not be opened."] } );
}
my @PasswdFile = <$PASSWD>;

my %UsersPasswdNormal = users::PasswordsNormal(@PasswdFile);

$PasswdFile = users::GetPasswdFile('shadow');

if (! -f $PasswdFile ) {
    return ( 1, @ { ["Shadow password file $PasswdFile does not exist."] } );
}

if ( ! open (my $PASSWD, '<', $PasswdFile) ) {
  return ( 1, @ { ["Shadow password file $PasswdFile can not be opened."] } );
}

@PasswdFile = <$PASSWD>;

# user and password items from /etc/shadow
my %UsersPasswdShadow = users::PasswordsShadow(@PasswdFile);

# check /etc/passwd first

while ( my ($k,$v) = each %UsersPasswdNormal ) {
    my $password = $v->{'password'};
    if ($password eq '') {
        push(@UsersEmptyPasswd, $k);
    }
    elsif ($password eq 'x') {
        push (@ShadowUsers, $k);
    }
} 

# now check shadowed users and their pw item in /etc/shadow

foreach (@ShadowUsers) {
    while (my ($k, $v) = each %UsersPasswdShadow) {
    
         # only check users that were shadowed in /etc/passwd
        if ($k eq $_) {
            push(@UsersEmptyPasswd, $k) if $v->{'password'} eq '';
        }
    }
}   

#
# CHECK END
######################################
return ( 0, @UsersEmptyPasswd );
}

1;
