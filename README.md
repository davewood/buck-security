# buck-security
## A collection of security checks for Linux 

*Author: Martin Bartenberger*

*Additional Author: Anne Mulhern (Yocto Projec, Linux Foundation)*


![Static Badge](https://img.shields.io/badge/Downloads-10%2C000%2B-blue)
![GitHub forks](https://img.shields.io/github/forks/davewood/buck-security?style=flat)

[![Perl](https://img.shields.io/badge/Perl-%2339457E.svg?logo=perl&logoColor=white)](#)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?logo=gnubash&logoColor=fff)](#)
[![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black)](#)
[![Debian](https://img.shields.io/badge/Debian-A81D33?logo=debian&logoColor=fff)](#)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&logoColor=white)](#)

## Table of Contents

  - [What is buck-security?](#what-is-buck-security)
  - [Installation](#installation)
  - [Configuration](#configuration)
    - [Configure which check to run](#configure-which-check-to-run)
    - [Configure exceptions for checks](#configure-exceptions-for-checks)
  - [Usage](#usage)
    - [Command line arguments](#command-line-arguments)
  - [Different checks](#different-checks)
    - [Find worldwriteable files](#find-worldwriteable-files)
    - [Find worldwriteable directories](#find-worldwriteable-directories)
    - [Find SETUIDS](#find-setuids)
    - [Find SETGIDS](#find-setgids)
    - [Check the default permission for new files/directories (umask)](#check-the-default-permission-for-new-filesdirectories-umask)
    - [Check if the sticky bit is set for /tmp](#check-if-the-sticky-bit-is-set-for-tmp)
    - [Check for superusers](#check-for-superusers)
    - [Check for installed attack tools packages](#check-for-installed-attack-tools-packages)
    - [Check firewall policies](#check-firewall-policies)
    - [Check if sshd is secured](#check-if-sshd-is-secured)
      - [PermitEmptyPasswords](#permitemptypasswords)
      - [PermitRootLogin](#permitrootlogin)
      - [Port](#port)
      - [Protocol](#protocol)
      - [TCPKeepAlive](#tcpkeepalive)
      - [UsePrivilegeSeparation](#useprivilegeseparation)
    - [Check for listening services](#check-for-listening-services)
    - [Checksums of system programs](#checksums-of-system-programs)
  - [DISCLAIMER OF WARRANTY](#disclaimer-of-warranty)



## What is buck-security?

buck-security is a security scanner for Debian and Ubuntu Linux. It runs a couple of important checks and helps you to harden your Linux system. 

buck-security enables you to quickly get an overview of the security status of your Linux system. As a system administrator you often get into situations where you have to take care of a server that has been maintained by other people before. In this situation it is useful to get an idea of the security status of the system immediately. 

buck-security was designed for such tasks but can also be used to continuously check the systems you manage. It runs a few important security checks and returns the results. It was desigend to be extremly easy to install, use and configure.

ATTENTION: buck-security should be just a small tool in your holistic security concept. Server security is a complex process which can't be guaranteed by a simple tool.
 

## Installation

buck-security comes as zip-file. Just [download the latest version here](https://github.com/davewood/buck-security/archive/refs/heads/master.zip) and unzip the the zip-file. 

To start the checks type `./buck-security` while in the buck-security directory). Or run `./buck-security --help` to get information about the options.

## Configuration

### Configure which check to run

You can configure buck-security by editing the file `conf/buck-security.conf`. Here you can enable and disable the different checks by deleting them from the list. By default all checks are enabled.

### Configure exceptions for checks

Some warnings that buck-security will give you at the first run will probably be false alarms. buck-security include whitelists for all checks that are suited for a newly installed Debian Linux. If you are sure that the warnings you get are harmless, you can add the items to the whitelist of the check which gave you the warning. 

For example if you are sure which files or directories should be allowed to be worldwriteable, or have the SETUID or SETGID set, than you can add these to the whitelist-files. Just copy and paste the list of files/directories that buck-security outputs to the proper exception file at conf/whitelists. 

For example copy a list of programs which are allowed to have the SETUID set to `conf/whitelists/suids_whitelist.conf`.

 ATTENTION: Please use the whitelists carefully. They may be a possible security risk.


## Usage

buck-security is started by typing `./buck-security` while in the buck-security directory.

By default all checks are enabled. For disabling checks see the section CONFIGURATION. 

The different checks may take a while. After they have been finished you will get informations about potentially security risks. You have to decide for yourself how to handle this information.

### Command line arguments

To control the output and enable logging of the results, the following command line arguments are available:

`./buck-security --help`
*show help*

`./buck-security --log`
*logs output in logs-directory*

`./buck-security --output=1`
*short output, show result only*

`./buck-security --output=2`
*(default) default output, show details (which files/dirs where found e.g.)*

`./buck-security --make-checksums`
*create checksums for the most important system programs to recheck them later (if the checksums check is enabled)*



## Different checks

 The different security-checks are the core of buck-security. In every security manual for linux you'll find a couple of small tricks to check the security status of your system (f.e. find worldwritable files/directories, find SUIDS, ...). buck-securityaims to unite all  these small but important and useful checks in one easy-to-use program.
 
 The following checks are implemented at the moment.


### Find worldwriteable files

As the name indicates the content of worldwriteable files can be changed by ANY user on your system. This is, of course, a major security risk. Worldwriteable files indicate a bad user management.

They can most of the time be avoided by creating a group which includes all users who need write access for the file, and change the group of the file to this group.

buck-security searches such worldwriteable files and gives you a warning if any are found. Normally none worldwriteable files should be found, so be very careful to add some to the whitelist.


### Find worldwriteable directories

Like worldwriteable files, worldwriteable DIRECTORIES are a major security risk too. For any user on the system can delete the files in this directory, even if he has no write permission to it! So worldwriteable directories should be avoided were possible. Were worldwide write access to a directory is necessary, for example for /tmp, the sticky bit should be set, so that users can not delete or alter files of other users in this directory.

buck-security checks for worldwriteable directories. Typically /tmp and its subdirectory are worldwriteable but have the sticky bit is set. So buck-security also checks if the sticky bit is set for /tmp. See "Check if the sticky bit is set for /tmp" for more information.


### Find SETUIDS

The potential problem about SETUID and SGID programs is explained very well in [Network Security Hacks by Andrew Lockart](https://www.oreilly.com/library/view/network-security-hacks/0596006438/): 
>"One potential way for a user to escalate her privileges on a system is to exploit a vulnerability in a SUID or SGID program. SUID and SGID are legitimately used when programs need special permissions above and beyond those that are available to the user who is running them. One such program is passwd. 
>
>Simultaneously allwoing a user to change her password while not allowing any user to modify the system password file means that the passwd program must run with root privileges. Thus, the program has its SUID set, which causes it to be executed with the privileges of the program files owner.
>
>Similarly, when the SGID bit is set, the program is executed with the >privileges of the files group owner.
>Running ls -l on a binary that has its SUID bit set should look like this:
>
> `-r-s--x--x 1 root root 16336 Feb 13 2003 /usr/bin/passwd`
>
>Notice that instead of an execute bit (x) for the owner bits, it has an s. This signifies an SUID file.
>Unfortunately, a poorly written SUID or SGID binary can be used to quickly and easily escalate a user's privileges. Also, an attacker who has already gained root access might hide SUID binaries throughout your system in order to leave a backdoor for future access. This leads us to the need for scanning systems for SUID and  SGID binaries."

buck-security therefor checks for SUID and SGID files and has a whitelist of common ones included. If you installed a lot of packages you'll probably get some warnings here. Check if this programs need the SUID or SGID bit and add them to the whitelist if so.

### Find SETGIDS

Please see the explanation on "Find SETUIDS" for further information.


### Check the default permission for new files/directories (umask)

The umask (User's file creation mask) determines the permissions for newly created files. The permissions which are set in the umask are NOT set for new files, which means they are substracted from 777. You can check your umask by running "umask". The default umask on Debian Linux "Lenny" is 0022. This means everyone can read your files, but no one can write to them.The most secure umask is 0077 which means, no one on the system can read or write your files.

buck-security uses this as default umask, it is included in the whitelist. If you want to use the more secure 0077 instead of 0022 please include it in the whitelist for the umask check and remove the 0022.

For more information please see [What is umask and how to setup default umask under Linux](https://www.cyberciti.biz/tips/understanding-linux-unix-umask-value-usage.html).


### Check if the sticky bit is set for /tmp

>"The most common use of the sticky bit today is on directories, where, when set, items inside the directory can be renamed or deleted only by the item's owner, the directory's owner, or the superuser; without the sticky bit set, any user with write and execute permissions for the directory can rename or delete contained files, regardless of owner. Typically this is set on the /tmp directory to prevent ordinary users from deleting or moving other users' files"

(from (http://en.wikipedia.org/wiki/Sticky_bit#Usage))

buck-security checks the permissions for /tmp and has the typical permission set included as whitelist. For more information about worldwriteable directories see the section "Find worldwriteable directories".


### Check for superusers

Superusers are the administrators of your linux system. They have full control over your machine, their user id is 0.

buck-security therefor searchs for users with this id in `/etc/passwd`. Normally only the user root has this id, be careful if you find other superuser accounts on your system.

### Check for installed attack tools packages

There are a lot of security tools which help administrators to keep their servers secure. These tools do the same as an attacker will do, they scan for open ports, checking for vulnerabilities or sniff the network traffic. If such tools are installed on your server they may become a potential security risk since attackers which have control over your server can use them to attack other servers.

buck-security therefor checks if the packages of such tools are installed on your machine.

More concretely we are looking for these packages:

`doscan,dsniff,ethereal,ettercap,harden-remoteaudit, inguma, nmap, nessusd, nessus, nikto, paketto, pnscan, hping2, hping3, john, scanssh, python-scapy, tshark`
 
You can find more informations about these packages at https://packages.debian.org
 
WARNING: Of course this isn't a check that looks for rootkits or tools that are installed without using the debian package manager (dpkg). It's just a check toto see if some dangerous packages are installed. To check for rootkits we recommend *rkhunter* or *chkrootkit*.


### Check firewall policies

If you build up a firewall you should follow a whitelist approach rather than blacklisting. This means by default you should deny any packages to bypass your firewall, except the ones you allow explicitly. With Linux iptables you can do this by setting the POLICIES to DROP all packages by default.

buck-security checks the default firewall policies of iptables and warns you if they are set to ACCEPT (which means all packages can bypass by default unless you reject them in a rule). So if buck-security gives you a warning about your firewall policies this probably means you don't have a firewall at all on your system or one which is using a (less secure) blacklisting approach. If your system is protected by another firewall you can ignore this warning.

### Check if sshd is secured

The SSH-Daemon is used for secure remote administration of your system and is running on nearly every Linux servers. Therefor buck-security takes a closer look at it's configuration file `/etc/ssh/sshd_config` an checks if sshd is configured in a secure way.

buck-security checks the following configuration options:

#### PermitEmptyPasswords

When password authentication is allowed, it specifies whether the server allows login to accounts with empty password strings. The default is *no*. This should be set to *no*.

#### PermitRootLogin

Specifies whether root can log in using ssh. If this option is set to no, root is not allowed to log in. This should be set to *no*.

#### Port

Specifies the port number that sshd listens on. The default is 22. To make brute force attacks to you sshd more difficult you should set this to anything but 22.

#### Protocol

Specifies the protocol versions sshd supports. The possible values are '1' and '2'. The default is '2'. Since the protocol version 1 is considered insecure this should be  set to *2*.

#### TCPKeepAlive

Specifies whether the system should send TCP keepalive messages to the other side. If TCP keepalives are not sent, sessions may hang indefinitely on the server, leaving 'ghost' users and consuming  server resources. The default is 'yes'. This should be set to *yes*.

#### UsePrivilegeSeparation

Specifies whether sshd separates privileges by creating an unprivileged child process to deal with incoming network traffic. After successful authentication, another process will be created that has the privilege of the authenticated user. The goal of privilege separation is to prevent privilege escalation by containing any corruption within the unprivileged processes. The default is 'yes'. This should be set to *yes*.

 If you want to learn more about the configuration of sshd you should check out the sshd_config manpage.

### Check for listening services

One of the first things you should do on a freshly installed system is to check what services are running and to remove any unneeded services from the system startup process. This is not only true for fresh installs but for all systems and is therefor one of the essential checks of buck-security.

What this check does is looking for listening services on your system, the output format is this:

`port:program:listen_mode`

*port* is the port of the service

*program* is the program name that is listening on this port if available. If we can't find out the name of the program you'll see UNKNOWN in this column.

*listen_mode* tells you how the service is listening, there are two possible states:
- *LISTEN_LOCAL* means that the service is only listening for connections from your system itself, not from the Internet or network.

- *LISTEN_ALL* means that the service is listening on all network interfaces, not only for local connections. Of course this means the service is available to others (for example a webserver, or ssh) if it's not blocked by a firewall.

As always you can use the whitelist to prevent false warnings. See the configuration section for more details.

If you want to find out more type `netstat -luntp` in your shell (in fact that's also the way buck-security checks for listening services, also check out the manpage of netstat). Also you can do a portscan of your system from the outside to see what ports are accessible (use `nmap` for example).


### Checksums of system programs

If you want to check the security status of your system, see which programs are running, which users are logged in or which ports are opened then you have to rely on system programs like ps, netstat or top. And buck-security uses these programs too. Therefor it's important to check the integrity of these programs by generating checksums of them and see if these checksums change.

When runned with the `--make-checksum` option buck-security by default creates checksums of the programs in /bin, /sbin, /usr/bin and /usr/sbin. To protect this checksum list it is encrypted with GPG, therefor you are asked for a password. You'll be asked for this password everytime when buck-security is executed and the checksum check is enabled.

If you control the integrity of your system already with other programs (like tripwire) you can disable the checksum check.




## DISCLAIMER OF WARRANTY
THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW . EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

For more information please read the LICENSE.
