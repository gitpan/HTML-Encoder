# HTML Encoder
#
#    Encode special caracters content in data structure to HTML code.
#
# Copyright 2003 Fabiano Reese Righetti <frighetti@cpan.org>
# All rights reserved.
#
#    This  program  is  free  software; you can redistribute it and/or
# modify  it  under  the  terms  of  the GNU General Public License as
# published  by  the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#    This  program  is distributed in the hope that it will be useful,
# but  WITHOUT  ANY  WARRANTY;  without  even  the implied warranty of
# MERCHANTABILITY  or  FITNESS  FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

package HTML::Encoder;
require 5.005;

=head1 NAME

HTML::Encoder - Encode special caracters to HTML code.

=head1 SYNOPSIS

 use HTML::Encoder;

 HTML::Encoder->encode($ref);

=head1 DESCRIPTION

This module implement algorithm for encoding special caracters content
in data structure to HTML code.

=head1 METHODS

=over 4

=cut

use vars qw($VERSION %table $heads);
use strict;
use warnings;

BEGIN
{
   our $VERSION = '0.00_01';
   our %table = (
                 chr(0xC3).chr(0xA1) => '&aacute;',
                 chr(0xC3).chr(0xA2) => '&acirc;',
                 chr(0xC3).chr(0xA3) => '&atilde;',
                 chr(0xC3).chr(0xA0) => '&agrave;',
                 chr(0xC3).chr(0xA4) => '&auml;',
                 chr(0xC3).chr(0x81) => '&Aacute;',
                 chr(0xC3).chr(0x82) => '&Acirc;',
                 chr(0xC3).chr(0x83) => '&Atilde;',
                 chr(0xC3).chr(0x80) => '&Agrave;',
                 chr(0xC3).chr(0x84) => '&Auml;',
                 chr(0xC3).chr(0xA9) => '&eacute;',
                 chr(0xC3).chr(0xAA) => '&ecirc;',
                 chr(0xC3).chr(0xA8) => '&egrave;',
                 chr(0xC3).chr(0xAB) => '&euml;',
                 chr(0xC3).chr(0x89) => '&Eacute;',
                 chr(0xC3).chr(0x8A) => '&Ecirc;',
                 chr(0xC3).chr(0x88) => '&Egrave;',
                 chr(0xC3).chr(0x8B) => '&Euml;',
                 chr(0xC3).chr(0xAD) => '&iacute;',
                 chr(0xC3).chr(0xAE) => '&icirc;',
                 chr(0xC3).chr(0xAC) => '&igrave;',
                 chr(0xC3).chr(0xAF) => '&iuml;',
                 chr(0xC3).chr(0x8D) => '&Iacute;',
                 chr(0xC3).chr(0x8E) => '&Icirc;',
                 chr(0xC3).chr(0x8C) => '&Igrave;',
                 chr(0xC3).chr(0x8F) => '&iuml;',
                 chr(0xC3).chr(0xB3) => '&oacute;',
                 chr(0xC3).chr(0xB4) => '&ocirc;',
                 chr(0xC3).chr(0xB5) => '&otilde;',
                 chr(0xC3).chr(0xB2) => '&ograve;',
                 chr(0xC3).chr(0xB6) => '&ouml;',
                 chr(0xC3).chr(0x93) => '&Oacute;',
                 chr(0xC3).chr(0x94) => '&ocirc;',
                 chr(0xC3).chr(0x95) => '&Otilde;',
                 chr(0xC3).chr(0x92) => '&Ograve;',
                 chr(0xC3).chr(0x96) => '&Ouml;',
                 chr(0xC3).chr(0xBA) => '&uacute;',
                 chr(0xC3).chr(0xBB) => '&ucirc;',
                 chr(0xC3).chr(0xB9) => '&ugrave;',
                 chr(0xC3).chr(0xBC) => '&uuml;',
                 chr(0xC3).chr(0x9A) => '&Uacute;',
                 chr(0xC3).chr(0x9B) => '&Ucirc;',
                 chr(0xC3).chr(0x99) => '&Ugrave;',
                 chr(0xC3).chr(0x9C) => '&Uuml;',
                 chr(0xC3).chr(0xA7) => '&ccedil;',
                 chr(0xC3).chr(0x87) => '&Ccedil;',
                           chr(0x3C) => '&lt;',
                           chr(0x3E) => '&gt;',
                           chr(0x26) => '&amp;',
                );

   our $heads = join '|',keys %table;
}

=item B<new>

The constructor method.

 NOT IMPLEMENTED!

=cut

sub new
{
   my $type  = shift;
   my $class = ref $type || $type;
                                                                                                                             
   my $self = {};

   bless  $self, $class;
   return $self;
}

=item B<encode>

Parsing data structure to searching special caracters for
convert in HTML code.

 HTML::Encoder->encode($ref);

=cut

sub encode
{
   my $self = shift;
   my $ref  = shift;

   if (ref $ref eq 'ARRAY')  {
      for my $i (0 .. $#{$ref}) {
         if ((ref $ref->[$i] ne 'ARRAY') and
             (ref $ref->[$i] ne 'HASH') and
             (ref $ref->[$i] ne 'SCALAR')) {
            &encode(undef, \$ref->[$i]);
         } else {
            &encode(undef, $ref->[$i]);
         }
      }
   } elsif (ref $ref eq 'HASH')   {
      for my $i (keys %{$ref}) {
         if ((ref $ref->{$i} ne 'ARRAY') and
             (ref $ref->{$i} ne 'HASH') and
             (ref $ref->{$i} ne 'SCALAR')) {
            &encode(undef, \$ref->{$i});
         } else {
            &encode(undef, $ref->{$i});
         }
      }
   } elsif (ref $ref eq 'SCALAR') {
      ${$ref} =~ s/($heads)/$table{$1}/g;
   }
}

1;

__END__

=back

=head1 SEE ALSO

W3C (http://www.w3c.org/).

=head1 AUTHOR

Fabiano Reese Righetti <frighetti@cpan.org>

=head1 COPYRIGHT

Copyright 2003 Fabiano Reese Righetti <frighetti@cpan.org>
All rights reserved.

This  code  is  free  software released under the GNU General Public
License,  the full terms of which can be found in the "COPYING" file
in this directory.

=cut
