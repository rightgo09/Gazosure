package Gazosure::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;
use Gazosure::Web::Util;

any '/' => sub {
  my ($c) = @_;
  my $base_directory = {
    path => "/",
    name => $c->config->{'BASE_DIRECTORY'},
  };
  my @dirs = (
    $base_directory,
    get_dirs($c->config->{'BASE_DIRECTORY'}),
  );
  $c->render('index.tt', { dirs => \@dirs });
};

get '/page' => sub {
  my ($c) = @_;
  my $rel_dir = $c->req->param('rel_dir');
  my $images = get_images($rel_dir);
  $c->render('page.tt', {
    rel_dir => $rel_dir,
    images  => $images,
  });
};

1;
