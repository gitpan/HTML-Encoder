use ExtUtils::MakeMaker;

WriteMakefile(
   DISTNAME      => 'HTML-Encoder',
   NAME          => 'HTML::Encoder',
   VERSION_FROM  => 'lib/HTML/Encoder.pm',
   AUTHOR        => 'Fabiano Reese Righetti <frighetti@cpan.org>',
   ABSTRACT_FROM => 'lib/HTML/Encoder.pm',
   PL_FILES      => {},
   PREREQ_PM     => {},
);
