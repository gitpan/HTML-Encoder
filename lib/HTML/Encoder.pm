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

 my $HE = new HTML::Encoder(
                            alphabet => 1, # Alphabet caracters encode (not complet).
                            symbols  => 1, # Symbols caracters encode (not complet).
                           );

 $HE->encode($ref);

=head1 DESCRIPTION

This module implement algorithm for encoding special caracters content
in data structure to HTML code.

=head1 METHODS

=over 4

=cut

use vars qw($VERSION %alphabet %symbols);
use strict;
use warnings;

BEGIN
{
   our $VERSION = '0.00_03';
   our %alphabet = (
                    'á' => '&aacute;', 'â' => '&acirc;',  'ã' => '&atilde;', 'à' => '&agrave;', 'ä' => '&auml;',
                    'Á' => '&Aacute;', 'Â' => '&Acirc;',  'Ã' => '&Atilde;', 'À' => '&Agrave;', 'Ä' => '&Auml;',
                    'é' => '&eacute;', 'ê' => '&ecirc;',                     'è' => '&egrave;', 'ë' => '&euml;',
                    'É' => '&Eacute;', 'Ê' => '&Ecirc;',                     'È' => '&Egrave;', 'Ë' => '&Euml;',
                    'í' => '&iacute;', 'î' => '&icirc;',                     'ì' => '&igrave;', 'ï' => '&iuml;',
                    'Í' => '&Iacute;', 'Î' => '&Icirc;',                     'Ì' => '&Igrave;', 'Ï' => '&iuml;',
                    'ó' => '&oacute;', 'ô' => '&ocirc;',  'õ' => '&otilde;', 'ò' => '&ograve;', 'ö' => '&ouml;',
                    'Ó' => '&Oacute;', 'Ô' => '&Ocirc;',  'Ö' => '&Otilde;', 'Ò' => '&Ograve;', 'Ö' => '&Ouml;',
                    'ú' => '&uacute;', 'û' => '&ucirc;',                     'ù' => '&ugrave;', 'ü' => '&uuml;',
                    'Ú' => '&Uacute;', 'Û' => '&Ucirc;',                     'Ù' => '&Ugrave;', 'Ü' => '&Uuml;',
                    'ç' => '&ccedil;', 'Ç' => '&Ccedil;', 
                   );
   our %symbols =  (
                    '<' => '&lt;',     '>' => '&gt;',     '&' => '&amp;',
                   );
}

=item B<new>

The constructor method.

 my $HE = new HTML::Encoder(
                            alphabet => 1, # Alphabet caracters encode (not complet).
                            symbols  => 1, # Symbols caracters encode (not complet).
                           );

Default alphabet encode true.

=cut

sub new
{
   my $type  = shift;
   my $class = ref $type || $type;
                                                                                                                             
   my $self = {
               alphabet => 0,
               symbols  => 0,
               @_,
              };

   if (!$self->{alphabet} and !$self->{symbols}) {
      $self->{alphabet} = 1;
   }

   $self->{heads_alphabet} = join '|',($self->{alphabet} ? keys %alphabet : '');
   $self->{heads_symbols}  = join '|',($self->{symbols}  ? keys %symbols  : '');

   bless  $self, $class;
   return $self;
}

=item B<encode>

Parsing data structure to searching special caracters for
convert in HTML code.

 $HE->encode($ref);

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
            &encode($self, \$ref->[$i]);
         } else {
            &encode($self, $ref->[$i]);
         }
      }
   } elsif (ref $ref eq 'HASH')   {
      for my $i (keys %{$ref}) {
         if ((ref $ref->{$i} ne 'ARRAY') and
             (ref $ref->{$i} ne 'HASH') and
             (ref $ref->{$i} ne 'SCALAR')) {
            &encode($self, \$ref->{$i});
         } else {
            &encode($self, $ref->{$i});
         }
      }
   } elsif (ref $ref eq 'SCALAR') {
      ${$ref} =~ s/($self->{heads_alphabet})/$alphabet{$1}/g
         if ($self->{heads_alphabet} ne '');
      ${$ref} =~ s/($self->{heads_symbols})/$symbols{$1}/g
         if ($self->{heads_symbols} ne '');
   }
}

1;

__END__

=back

=head1 SEE ALSO

W3C - http://www.w3c.org/

=head1 AUTHOR

Fabiano Reese Righetti <frighetti@cpan.org>

=head1 COPYRIGHT

Copyright 2003 Fabiano Reese Righetti <frighetti@cpan.org>
All rights reserved.

This  code  is  free  software released under the GNU General Public
License,  the full terms of which can be found in the "COPYING" file
in this directory.

=cut
