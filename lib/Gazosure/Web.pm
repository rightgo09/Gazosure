package Gazosure::Web;
use strict;
use warnings;
use utf8;
use parent qw/Gazosure Amon2::Web/;
use File::Spec;

# dispatcher
use Gazosure::Web::Dispatcher;
sub dispatch {
  return (Gazosure::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

# setup view class
use Text::Xslate;
use URI::Escape qw/ uri_escape_utf8 /;
{
  my $view_conf = __PACKAGE__->config->{'Text::Xslate'} || +{};
  unless (exists $view_conf->{path}) {
    $view_conf->{path} = [ File::Spec->catdir(__PACKAGE__->base_dir(), 'tmpl') ];
  }
  my $view = Text::Xslate->new(+{
    'syntax'   => 'TTerse',
    'module'   => [ 'Text::Xslate::Bridge::Star' ],
    'function' => {
      c => sub { Amon2->context() },
      uri_with => sub { Amon2->context()->req->uri_with(@_) },
      uri_for  => sub { Amon2->context()->uri_for(@_) },
      static_file => do {
        my %static_file_cache;
        sub {
          my $fname = shift;
          my $c = Amon2->context;
          if (not exists $static_file_cache{$fname}) {
            my $fullpath = File::Spec->catfile($c->base_dir(), $fname);
            $static_file_cache{$fname} = (stat $fullpath)[9];
          }
          return $c->uri_for($fname, { 't' => $static_file_cache{$fname} || 0 });
        }
      },
      uri_escape_from_path => sub {
        my $path = shift;
        return join('/', map uri_escape_utf8($_), split(m|/|, $path));
      },
    },
    %$view_conf
  });
  sub create_view { $view }
}

## load plugins
#__PACKAGE__->load_plugins(
#  'Web::CSRFDefender',
#);

# for your security
__PACKAGE__->add_trigger(
  AFTER_DISPATCH => sub {
    my ( $c, $res ) = @_;
    # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
    $res->header( 'X-Content-Type-Options' => 'nosniff' );
    # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
    $res->header( 'X-Frame-Options' => 'DENY' );
    # Cache control.
    $res->header( 'Cache-Control' => 'private' );
  },
);

#__PACKAGE__->add_trigger(
#  BEFORE_DISPATCH => sub {
#    my ( $c ) = @_;
#    # ...
#    return;
#  },
#);

1;
