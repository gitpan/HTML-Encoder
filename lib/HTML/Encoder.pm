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
                            Extended_A    => 1,
                            Extended_B    => 1,
                            Latin_1       => 1,
                           );

 $HE->encode($ref);

=head1 DESCRIPTION

This module implement algorithm for encoding special caracters content
in data structure to HTML code.

=head1 METHODS

=over 4

=cut

use vars qw($VERSION %Entities);

use strict;
use warnings;

BEGIN
{
   our $VERSION   = '0.00_04';
   our %Entities = (
                    Latin_1       => {
                                      chr(0x00a0) => 'nbsp',     # NO-BREAK SPACE
                                      chr(0x00a1) => 'iexcl',    # INVERTED EXCLAMATION MARK
                                      chr(0x00a2) => 'cent',     # CENT SIGN
                                      chr(0x00a3) => 'pound',    # POUND SIGN
                                      chr(0x00a4) => 'curren',   # CURRENCY SIGN
                                      chr(0x00a5) => 'yen',      # YEN SIGN
                                      chr(0x00a6) => 'brvbar',   # BROKEN BAR
                                      chr(0x00a7) => 'sect',     # SECTION SIGN
                                      chr(0x00a8) => 'uml',      # DIAERESIS
                                      chr(0x00a9) => 'copy',     # COPYRIGHT SIGN
                                      chr(0x00aa) => 'ordf',     # FEMININE ORDINAL INDICATOR
                                      chr(0x00ab) => 'laquo',    # LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
                                      chr(0x00ac) => 'not',      # NOT SIGN
                                      chr(0x00ad) => 'shy',      # SOFT HYPHEN
                                      chr(0x00ae) => 'reg',      # REGISTERED SIGN
                                      chr(0x00af) => 'macr',     # MACRON
                                      chr(0x00b0) => 'deg',      # DEGREE SIGN
                                      chr(0x00b1) => 'plusmn',   # PLUS-MINUS SIGN
                                      chr(0x00b2) => 'sup2',     # SUPERSCRIPT TWO
                                      chr(0x00b3) => 'sup3',     # SUPERSCRIPT THREE
                                      chr(0x00b4) => 'acute',    # ACUTE ACCENT
                                      chr(0x00b5) => 'micro',    # MICRO SIGN
                                      chr(0x00b6) => 'para',     # PILCROW SIGN
                                      chr(0x00b7) => 'middot',   # MIDDLE DOT
                                      chr(0x00b8) => 'cedil',    # CEDILLA
                                      chr(0x00b9) => 'sup1',     # SUPERSCRIPT ONE
                                      chr(0x00ba) => 'ordm',     # MASCULINE ORDINAL INDICATOR
                                      chr(0x00bb) => 'raquo',    # RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
                                      chr(0x00bc) => 'frac14',   # VULGAR FRACTION ONE QUARTER
                                      chr(0x00bd) => 'frac12',   # VULGAR FRACTION ONE HALF
                                      chr(0x00be) => 'frac34',   # VULGAR FRACTION THREE QUARTERS
                                      chr(0x00bf) => 'iquest',   # INVERTED QUESTION MARK
                                      chr(0x00c0) => 'Agrave',   # LATIN CAPITAL LETTER A WITH GRAVE
                                      chr(0x00c1) => 'Aacute',   # LATIN CAPITAL LETTER A WITH ACUTE
                                      chr(0x00c2) => 'Acirc',    # LATIN CAPITAL LETTER A WITH CIRCUMFLEX
                                      chr(0x00c3) => 'Atilde',   # LATIN CAPITAL LETTER A WITH TILDE
                                      chr(0x00c4) => 'Auml',     # LATIN CAPITAL LETTER A WITH DIAERESIS
                                      chr(0x00c5) => 'Aring',    # LATIN CAPITAL LETTER A WITH RING ABOVE
                                      chr(0x00c6) => 'AElig',    # LATIN CAPITAL LETTER AE
                                      chr(0x00c7) => 'Ccedil',   # LATIN CAPITAL LETTER C WITH CEDILLA
                                      chr(0x00c8) => 'Egrave',   # LATIN CAPITAL LETTER E WITH GRAVE
                                      chr(0x00c9) => 'Eacute',   # LATIN CAPITAL LETTER E WITH ACUTE
                                      chr(0x00ca) => 'Ecirc',    # LATIN CAPITAL LETTER E WITH CIRCUMFLEX
                                      chr(0x00cb) => 'Euml',     # LATIN CAPITAL LETTER E WITH DIAERESIS
                                      chr(0x00cc) => 'Igrave',   # LATIN CAPITAL LETTER I WITH GRAVE
                                      chr(0x00cd) => 'Iacute',   # LATIN CAPITAL LETTER I WITH ACUTE
                                      chr(0x00ce) => 'Icirc',    # LATIN CAPITAL LETTER I WITH CIRCUMFLEX
                                      chr(0x00cf) => 'Iuml',     # LATIN CAPITAL LETTER I WITH DIAERESIS
                                      chr(0x00d0) => 'ETH',      # LATIN CAPITAL LETTER ETH (Icelandic)
                                      chr(0x00d1) => 'Ntilde',   # LATIN CAPITAL LETTER N WITH TILDE
                                      chr(0x00d2) => 'Ograve',   # LATIN CAPITAL LETTER O WITH GRAVE
                                      chr(0x00d3) => 'Oacute',   # LATIN CAPITAL LETTER O WITH ACUTE
                                      chr(0x00d4) => 'Ocirc',    # LATIN CAPITAL LETTER O WITH CIRCUMFLEX
                                      chr(0x00d5) => 'Otilde',   # LATIN CAPITAL LETTER O WITH TILDE
                                      chr(0x00d6) => 'Ouml',     # LATIN CAPITAL LETTER O WITH DIAERESIS
                                      chr(0x00d7) => 'times',    # MULTIPLICATION SIGN
                                      chr(0x00d8) => 'Oslash',   # LATIN CAPITAL LETTER O WITH STROKE
                                      chr(0x00d9) => 'Ugrave',   # LATIN CAPITAL LETTER U WITH GRAVE
                                      chr(0x00da) => 'Uacute',   # LATIN CAPITAL LETTER U WITH ACUTE
                                      chr(0x00db) => 'Ucirc',    # LATIN CAPITAL LETTER U WITH CIRCUMFLEX
                                      chr(0x00dc) => 'Uuml',     # LATIN CAPITAL LETTER U WITH DIAERESIS
                                      chr(0x00dd) => 'Yacute',   # LATIN CAPITAL LETTER Y WITH ACUTE
                                      chr(0x00de) => 'THORN',    # LATIN CAPITAL LETTER THORN (Icelandic)
                                      chr(0x00df) => 'szlig',    # LATIN SMALL LETTER SHARP S (German)
                                      chr(0x00e0) => 'agrave',   # LATIN SMALL LETTER A WITH GRAVE
                                      chr(0x00e1) => 'aacute',   # LATIN SMALL LETTER A WITH ACUTE
                                      chr(0x00e2) => 'acirc',    # LATIN SMALL LETTER A WITH CIRCUMFLEX
                                      chr(0x00e3) => 'atilde',   # LATIN SMALL LETTER A WITH TILDE
                                      chr(0x00e4) => 'auml',     # LATIN SMALL LETTER A WITH DIAERESIS
                                      chr(0x00e5) => 'aring',    # LATIN SMALL LETTER A WITH RING ABOVE
                                      chr(0x00e6) => 'aelig',    # LATIN SMALL LETTER AE
                                      chr(0x00e7) => 'ccedil',   # LATIN SMALL LETTER C WITH CEDILLE
                                      chr(0x00e8) => 'egrave',   # LATIN SMALL LETTER E WITH GRAVE
                                      chr(0x00e9) => 'eacute',   # LATIN SMALL LETTER E WITH ACUTE
                                      chr(0x00ea) => 'ecirc',    # LATIN SMALL LETTER E WITH CIRCUMFLEX
                                      chr(0x00eb) => 'euml',     # LATIN SMALL LETTER E WITH DIAERESIS
                                      chr(0x00ec) => 'igrave',   # LATIN SMALL LETTER I WITH GRAVE
                                      chr(0x00ed) => 'iacute',   # LATIN SMALL LETTER I WITH ACUTE
                                      chr(0x00ee) => 'icirc',    # LATIN SMALL LETTER I WITH CIRCUMFLEX
                                      chr(0x00ef) => 'iuml',     # LATIN SMALL LETTER I WITH DIAERESIS
                                      chr(0x00f0) => 'eth',      # LATIN SMALL LETTER ETH (Icelandic)
                                      chr(0x00f1) => 'ntilde',   # LATIN SMALL LETTER N WITH TILDE
                                      chr(0x00f2) => 'ograve',   # LATIN SMALL LETTER O WITH GRAVE
                                      chr(0x00f3) => 'oacute',   # LATIN SMALL LETTER O WITH ACUTE
                                      chr(0x00f4) => 'ocirc',    # LATIN SMALL LETTER O WITH CIRCUMFLEX
                                      chr(0x00f5) => 'otilde',   # LATIN SMALL LETTER O WITH TILDE
                                      chr(0x00f6) => 'ouml',     # LATIN SMALL LETTER O WITH DIAERESIS
                                      chr(0x00f7) => 'divide',   # DIVISION SIGN
                                      chr(0x00f8) => 'oslash',   # LATIN SMALL LETTER O WITH STROKE
                                      chr(0x00f9) => 'ugrave',   # LATIN SMALL LETTER U WITH GRAVE
                                      chr(0x00fa) => 'uacute',   # LATIN SMALL LETTER U WITH ACUTE
                                      chr(0x00fb) => 'ucirc',    # LATIN SMALL LETTER U WITH CIRCUMFLEX
                                      chr(0x00fc) => 'uuml',     # LATIN SMALL LETTER U WITH DIAERESIS
                                      chr(0x00fd) => 'yacute',   # LATIN SMALL LETTER Y WITH ACUTE
                                      chr(0x00fe) => 'thorn',    # LATIN SMALL LETTER THORN (Icelandic)
                                      chr(0x00ff) => 'yuml',     # LATIN SMALL LETTER Y WITH DIAERESIS
                                     },
  
                    Extended_B    => {
                                      chr(0x0391) => 'Alpha',    # GREEK CAPITAL LETTER ALPHA
                                      chr(0x0392) => 'Beta',     # GREEK CAPITAL LETTER BETA
                                      chr(0x0393) => 'Gamma',    # GREEK CAPITAL LETTER GAMMA
                                      chr(0x0394) => 'Delta',    # GREEK CAPITAL LETTER DELTA
                                      chr(0x0395) => 'Epsilon',  # GREEK CAPITAL LETTER EPSILON
                                      chr(0x0396) => 'Zeta',     # GREEK CAPITAL LETTER ZETA
                                      chr(0x0397) => 'Eta',      # GREEK CAPITAL LETTER ETA
                                      chr(0x0398) => 'Theta',    # GREEK CAPITAL LETTER THETA
                                      chr(0x0399) => 'Iota',     # GREEK CAPITAL LETTER IOTA
                                      chr(0x039a) => 'Kappa',    # GREEK CAPITAL LETTER KAPPA
                                      chr(0x039b) => 'Lambda',   # GREEK CAPITAL LETTER LAMBDA
                                      chr(0x039c) => 'Mu',       # GREEK CAPITAL LETTER MU
                                      chr(0x039d) => 'Nu',       # GREEK CAPITAL LETTER NU
                                      chr(0x039e) => 'Xi',       # GREEK CAPITAL LETTER XI
                                      chr(0x039f) => 'Omicron',  # GREEK CAPITAL LETTER OMICRON
                                      chr(0x03a0) => 'Pi',       # GREEK CAPITAL LETTER PI
                                      chr(0x03a1) => 'Rho',      # GREEK CAPITAL LETTER RHO
                                      chr(0x03a3) => 'Sigma',    # GREEK CAPITAL LETTER SIGMA
                                      chr(0x03a4) => 'Tau',      # GREEK CAPITAL LETTER TAU
                                      chr(0x03a5) => 'Upsilon',  # GREEK CAPITAL LETTER UPSILON
                                      chr(0x03a6) => 'Phi',      # GREEK CAPITAL LETTER PHI
                                      chr(0x03a7) => 'Chi',      # GREEK CAPITAL LETTER CHI
                                      chr(0x03a8) => 'Psi',      # GREEK CAPITAL LETTER PSI
                                      chr(0x03a9) => 'Omega',    # GREEK CAPITAL LETTER OMEGA
                                      chr(0x03b1) => 'alpha',    # GREEK SMALL LETTER ALPHA
                                      chr(0x03b2) => 'beta',     # GREEK SMALL LETTER BETA
                                      chr(0x03b3) => 'gamma',    # GREEK SMALL LETTER GAMMA
                                      chr(0x03b4) => 'delta',    # GREEK SMALL LETTER DELTA
                                      chr(0x03b5) => 'epsilon',  # GREEK SMALL LETTER EPSILON
                                      chr(0x03b6) => 'zeta',     # GREEK SMALL LETTER ZETA
                                      chr(0x03b7) => 'eta',      # GREEK SMALL LETTER ETA
                                      chr(0x03b8) => 'theta',    # GREEK SMALL LETTER THETA
                                      chr(0x03b9) => 'iota',     # GREEK SMALL LETTER IOTA
                                      chr(0x03ba) => 'kappa',    # GREEK SMALL LETTER KAPPA
                                      chr(0x03bb) => 'lambda',   # GREEK SMALL LETTER LAMBDA
                                      chr(0x03bc) => 'mu',       # GREEK SMALL LETTER MU
                                      chr(0x03bd) => 'nu',       # GREEK SMALL LETTER NU
                                      chr(0x03be) => 'xi',       # GREEK SMALL LETTER XI
                                      chr(0x03bf) => 'omicron',  # GREEK SMALL LETTER OMICRON
                                      chr(0x03c0) => 'pi',       # GREEK SMALL LETTER PI
                                      chr(0x03c1) => 'rho',      # GREEK SMALL LETTER RHO
                                      chr(0x03c2) => 'sigmaf',   # GREEK SMALL LETTER FINAL SIGMA
                                      chr(0x03c3) => 'sigma',    # GREEK SMALL LETTER SIGMA
                                      chr(0x03c4) => 'tau',      # GREEK SMALL LETTER TAU
                                      chr(0x03c5) => 'upsilon',  # GREEK SMALL LETTER UPSILON
                                      chr(0x03c6) => 'phi',      # GREEK SMALL LETTER PHI
                                      chr(0x03c7) => 'chi',      # GREEK SMALL LETTER CHI
                                      chr(0x03c8) => 'psi',      # GREEK SMALL LETTER PSI
                                      chr(0x03c9) => 'omega',    # GREEK SMALL LETTER OMEGA
                                      chr(0x03d1) => 'thetasym', # GREEK SMALL LETTER THETA SYMBOL
                                      chr(0x03d2) => 'upsih',    # GREEK UPSILON WITH HOOK SYMBOL
                                      chr(0x03d6) => 'piv',      # GREEK PI SYMBOL
                                     },
                    Punctuation   => {
                                      chr(0x2022) => 'bull',     # BULLET = BLACK SMALL CIRCLE
                                      chr(0x2026) => 'hellip',   # HORIZONTAL ELLIPSIS = THREE DOT LEADER
                                      chr(0x2032) => 'prime',    # PRIME = MINUTES = FEET
                                      chr(0x2033) => 'Prime',    # DOUBLE PRIME = SECONDS = INCHES
                                      chr(0x203e) => 'oline',    # OVERLINE = SPACING OVERSCORE
                                      chr(0x2044) => 'frasl',    # FRACTION SLASH
                                     },
                    Letterlike    => {
                                      chr(0x2111) => 'image',    # BLACKLETTER CAPITAL I = IMAGINARY PART
                                      chr(0x211c) => 'real',     # BLACKLETTER CAPITAL R = REAL PART SYMBOL
                                      chr(0x2122) => 'trade',    # TRADE MARK SIGN
                                      chr(0x2135) => 'alefsym',  # ALEF SYMBOL = FIRST TRANSFINITE CARDINAL
                                     },
                    Arrows        => {
                                      chr(0x2190) => 'larr',     # LEFTWARDS ARROW
                                      chr(0x2191) => 'uarr',     # UPWARDS ARROW
                                      chr(0x2192) => 'rarr',     # RIGHTWARDS ARROW
                                      chr(0x2193) => 'darr',     # DOWNWARDS ARROW
                                      chr(0x2194) => 'harr',     # LEFT RIGHT ARROW
                                      chr(0x21d0) => 'lArr',     # LEFTWARDS DOUBLE ARROW
                                      chr(0x21d1) => 'uArr',     # UPWARDS DOUBLE ARROW
                                      chr(0x21d2) => 'rArr',     # RIGHTWARDS DOUBLE ARROW
                                      chr(0x21d3) => 'dArr',     # DOWNWARDS DOUBLE ARROW
                                      chr(0x21d4) => 'hArr',     # LEFT RIGHT DOUBLE ARROW
                                     },
                    Mathematical  => {
                                      chr(0x2200) => 'forall',  # FOR ALL
                                      chr(0x2202) => 'part',    # PARTIAL DIFFERENTIAL
                                      chr(0x2203) => 'exist',   # THERE EXISTS
                                      chr(0x2205) => 'empty',   # EMPTY SET = NULL SET = DIAMETER
                                      chr(0x2207) => 'nabla',   # NABLA = BACKWARD DIFFERENCE
                                      chr(0x2208) => 'isin',    # ELEMENT OF
                                      chr(0x2209) => 'notin',   # NOT AN ELEMENT OF
                                      chr(0x220b) => 'ni',      # CONTAINS AS MEMBER
                                      chr(0x220f) => 'prod',    # N-ARY PRODUCT = PRODUCT SIGN
                                      chr(0x2211) => 'sum',     # N-ARY SUMATION
                                      chr(0x2212) => 'minus',   # MINUS SIGN
                                      chr(0x2217) => 'lowast',  # ASTERISK OPERATOR
                                      chr(0x221a) => 'radic',   # SQUARE ROOT = RADICAL SIGN
                                      chr(0x221d) => 'prop',    # PROPORTIONAL TO
                                      chr(0x221e) => 'infin',   # INFINITY
                                      chr(0x2220) => 'ang',     # ANGLE
                                      chr(0x2227) => 'and',     # LOGICAL AND = WEDGE
                                      chr(0x2228) => 'or',      # LOGICAL OR = VEE
                                      chr(0x2229) => 'cap',     # INTERSECTION = CAP
                                      chr(0x222a) => 'cup',     # UNION = CUP
                                      chr(0x222b) => 'int',     # INTEGRAL
                                      chr(0x2234) => 'there4',  # THEREFORE
                                      chr(0x223c) => 'sim',     # TILDE OPERATOR = VARIES WITH = SIMILAR TO
                                      chr(0x2245) => 'cong',    # APPROXIMATELY EQUAL TO
                                      chr(0x2248) => 'asymp',   # ALMOST EQUAL TO = ASYMPTOTIC TO
                                      chr(0x2260) => 'ne',      # NOT EQUAL TO
                                      chr(0x2261) => 'equiv',   # IDENTICAL TO
                                      chr(0x2264) => 'le',      # LESS-THAN OR EQUAL TO
                                      chr(0x2265) => 'ge',      # GREATER-THAN OR EQUAL TO
                                      chr(0x2282) => 'sub',     # SUBSET OF
                                      chr(0x2283) => 'sup',     # SUPERSET OF
                                      chr(0x2284) => 'nsub',    # NOT A SUBSET OF
                                      chr(0x2286) => 'sube',    # SUBSET OF OR EQUAL TO
                                      chr(0x2287) => 'supe',    # SUPERSET OF OR EQUAL TO
                                      chr(0x2295) => 'oplus',   # CIRCLED PLUS = DIRECT SUM
                                      chr(0x2297) => 'otimes',  # CIRCLED TIMES = VECTOR PRODUCT
                                      chr(0x22a5) => 'perp',    # UP TACK = ORTHOGONAL TO = PERPENDICULAR
                                      chr(0x22c5) => 'sdot',    # DOT OPERATOR
                                     },
                    Technical     => {
                                      chr(0x2308) => 'lceil',   # LEFT CEILING = APL UPSTILE
                                      chr(0x2309) => 'rceil',   # RIGHT CEILING
                                      chr(0x230a) => 'lfloor',  # LEFT FLOOR = APL DOWNSTILE
                                      chr(0x230b) => 'rfloor',  # RIGHT FLOOR
                                      chr(0x2329) => 'lang',    # LEFT-POINTING ANGLE BRACKET = BRA
                                      chr(0x232a) => 'rang',    # RIGHT-POINTING ANGLE BRACKET = KET
                                     },
                    Geometric     => {
                                      chr(0x25ca) => 'loz',     # LOZENGE
                                     },
                    Miscellaneous => {
                                      chr(0x2660) => 'spades',  # BLACK SPADE SUIT
                                      chr(0x2663) => 'clubs',   # BLACK CLUB SUIT = SHAMROCK
                                      chr(0x2665) => 'hearts',  # BLACK HEART SUIT = VALENTINE
                                      chr(0x2666) => 'diams',   # BLACK DIAMOND SUIT
                                     },
                    Controls      => {
                                      chr(0x0022) => 'quot',    # QUOTATION MARK = APL QUOTE
                                      chr(0x0026) => 'amp',     # AMPERSAND
                                      chr(0x003c) => 'lt',      # LESS-THAN SIGN
                                      chr(0x003e) => 'gt',      # GREATER-THAN SIGN
                                     },
                    Extended_A    => {
                                      chr(0x0152) => 'OElig',   # LATIN CAPITAL LIGATURE OE
                                      chr(0x0153) => 'oelig',   # LATIN SMALL LIGATURE OE
                                      chr(0x0160) => 'Scaron',  # LATIN CAPITAL LETTER S WITH CARON
                                      chr(0x0161) => 'scaron',  # LATIN SMALL LETTER S WITH CARON
                                      chr(0x0178) => 'Yuml',    # LATIN CAPITAL LETTER Y WITH DIAERESIS
                                     },
                    Modifier      => {
                                      chr(0x02c6) => 'circ',    # MODIFIER LETTER CIRCUMFLEX ACCENT
                                      chr(0x02dc) => 'tilde',   # SMALL TILDE
                                     },
                    Punctuation   => {
                                      chr(0x2002) => 'ensp',    # EN SPACE
                                      chr(0x2003) => 'emsp',    # EM SPACE
                                      chr(0x2009) => 'thinsp',  # THIN SPACE
                                      chr(0x200c) => 'zwnj',    # ZERO WIDTH NON-JOINER
                                      chr(0x200d) => 'zwj',     # ZERO WIDTH JOINER
                                      chr(0x200e) => 'lrm',     # LEFT-TO-RIGHT MARK
                                      chr(0x200f) => 'rlm',     # RIGHT-TO-LEFT MARK
                                      chr(0x2013) => 'ndash',   # EN DASH
                                      chr(0x2014) => 'mdash',   # EM DASH
                                      chr(0x2018) => 'lsquo',   # LEFT SINGLE QUOTATION MARK
                                      chr(0x2019) => 'rsquo',   # RIGHT SINGLE QUOTATION MARK
                                      chr(0x201a) => 'sbquo',   # SINGLE LOW-9 QUOTATION MARK
                                      chr(0x201c) => 'ldquo',   # LEFT DOUBLE QUOTATION MARK
                                      chr(0x201d) => 'rdquo',   # RIGHT DOUBLE QUOTATION MARK
                                      chr(0x201e) => 'bdquo',   # DOUBLE LOW-9 QUOTATION MARK
                                      chr(0x2020) => 'dagger',  # DAGGER
                                      chr(0x2021) => 'Dagger',  # DOUBLE DAGGER
                                      chr(0x2030) => 'permil',  # PER MILLE SIGN
                                      chr(0x2039) => 'lsaquo',  # SINGLE LEFT-POINTING ANGLE QUOTATION MARK
                                      chr(0x203a) => 'rsaquo',  # SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
                                      chr(0x20ac) => 'euro',    # EURO SIGN
                                     },
                   );
}

=item B<new>

The constructor method.

 my $HE = new HTML::Encoder(
                            Arrows        => 0,
                            Controls      => 0,
                            Extended_A    => 1,
                            Extended_B    => 1,
                            Geometric     => 0,
                            Latin_1       => 1,
                            Letterlike    => 0,
                            Mathematical  => 0,
                            Miscellaneous => 0,
                            Modifier      => 0,
                            Punctuation   => 0,
                            Technical     => 0,
                           );

  or

  my $HE = new HTML::Encode(); # Default Latin_1 entities encode true.

=cut

sub new
{
   my $type  = shift;
   my $class = ref $type || $type;
                                                                                                                             
   my $self = {
               Arrows        => 0,
               Controls      => 0,
               Extended_A    => 0,
               Extended_B    => 0,
               Geometric     => 0,
               Latin_1       => 0,
               Letterlike    => 0,
               Mathematical  => 0,
               Miscellaneous => 0,
               Modifier      => 0,
               Punctuation   => 0,
               Technical     => 0,
               @_,
              };

   my $ok = 0;
   for my $i (keys %Entities) {
      if ($self->{$i}) {
         $ok = 1;
         $self->{'Heads_'.$i} = join '|', keys %{$Entities{$i}};
      }
   }

   # Set default HTML codes.
   if (!$ok) {
      $self->{Latin_1} = 1;
      $self->{Heads_Latin_1} = join '|', keys %{$Entities{Latin_1}};
   }

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
      for my $i (keys %Entities) {
         if ($self->{$i}) {
             ${$ref} =~ s/($self->{'Heads_'.$i})/&$Entities{$i}{$1};/g;
         }
      }
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
