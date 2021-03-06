use strict;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Plack::Builder;

use Gazosure::Web;
use Gazosure;

my $gazosure_dir = File::Spec->catdir(dirname(__FILE__), 'static', 'img', 'gazosure');
if (-e $gazosure_dir || readlink $gazosure_dir) {
  unlink($gazosure_dir) or die $!;
}
symlink(Gazosure->config->{'BASE_DIRECTORY'}, $gazosure_dir) or die $!;

builder {
  enable 'Plack::Middleware::Static',
    path => qr{^(?:/static/)},
    root => File::Spec->catdir(dirname(__FILE__));
  enable 'Plack::Middleware::Static',
    path => qr{^(?:/robots\.txt|/favicon\.ico)$},
    root => File::Spec->catdir(dirname(__FILE__), 'static');
  enable 'Plack::Middleware::ReverseProxy';
  Gazosure::Web->to_app();
};
