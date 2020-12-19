#!/usr/bin/perl
# SPDX-License-Identifier: GPL-2.0-or-later

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

__END__

=head1 NAME

dpkg-version-sort.pl - Sort Debian package versions

=head1 USAGE

  <whatever> | dpkg-version-sort.pl

That's it!

=head1 AUTHORS

=over

=item *

Peter van Dijk C<< <peter@7bits.nl> >>

=item *

Christopher White C<< <cxwembedded@gmail.com> >>

=back

=head1 COPYRIGHT

Copyright (c) 2015 Peter van Dijk.

Copyright (c) 2020 Christopher White.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

=cut
