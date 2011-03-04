use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WebService::GT5',
    AUTHOR              => q{Justin Hawkins <justin@cpan.org>},
    VERSION_FROM        => 'lib/WebService/GT5.pm',
    ABSTRACT_FROM       => 'lib/WebService/GT5.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'JSON' => 0,
        'WWW::Mechanize' => 0,
        'URI::Escape' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WebService-GT5-*' },
);
