#!/usr/bin/perl
use strict;
use warnings;
use sort 'stable';

# Fast sorter, if it is installed and not overridden by $DPKG_VERSION_SORT_FAST.
# This module is part of libdpkg-perl on Ubuntu.
my $have_fast = eval "use Dpkg::Version; 1";
my $fast = $have_fast;
if(exists $ENV{DPKG_VERSION_SORT_FAST}) {
  $fast = $have_fast && !!$ENV{DPKG_VERSION_SORT_FAST};
}

# Slow sorter
sub dpkgcomp($$)
{
  my ($a, $b) = @_;
  return 1 if(system("dpkg --compare-versions $a lt $b"));
  return -1 if(system("dpkg --compare-versions $a gt $b"));
  return 0;
}

my $sorter = $fast ? \&Dpkg::Version::version_compare : \&dpkgcomp;

my @l = <>;
chomp(@l);
my @s = sort $sorter @l;
print join("\n", @s), "\n";
