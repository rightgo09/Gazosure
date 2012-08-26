use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Gazosure',
    AUTHOR        => 'rightgo09 <skyarrow09@gmail.com>',
    VERSION_FROM  => 'lib/Gazosure.pm',
    PREREQ_PM     => {
        'Amon2'                           => '3.53',
        'Text::Xslate'                    => '1.5006',
        'Test::More'                      => '0.98',
        'Plack::Middleware::ReverseProxy' => '0.09',
        'Test::WWW::Mechanize::PSGI'      => '0',
        'Time::Piece'                     => '1.20',
    },
    MIN_PERL_VERSION => '5.008001',
    (-d 'xt' and $ENV{AUTOMATED_TESTING} || $ENV{RELEASE_TESTING}) ? (
        test => {
            TESTS => 't/*.t xt/*.t',
        },
    ) : (),
);
