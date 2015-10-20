#!/usr/bin/perl

use strict;
use warnings;

package packages;

# packages.pm
# includes subs for checking if packages are installed, etc.

sub InstalledPackages {    
    my @installed_packages = `dpkg-query -W | awk '{print \$1}'`;
    return @installed_packages;
}

# # Check if installed, returns Hash with: Name => 0 or 1 (1 if installed)
# my %Status = check::IsInstalled(@hacker_tools);


sub IsInstalled {
    my $array_ref = shift;  # get reference of array (arrays cant be passed to
                            # subs "normally"
    my @packages = @{$array_ref}; # load to array
    my @installed_packages = InstalledPackages();
    my %Status;  # Hash were name and status (0 or 1) is saved
    foreach my $package (@packages) {
        my $result = grep(/^$package$/, @installed_packages); 
        $Status{$package} = $result; 
    }
    return %Status;
}


1;
