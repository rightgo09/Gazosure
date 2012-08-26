package Gazosure::Web::Util;
use strict;
use warnings;
use utf8;
use File::Spec;

use base 'Exporter';
our @EXPORT = qw(get_dirs get_images);

use Gazosure;
my $BASE_DIRECTORY = Gazosure->config->{'BASE_DIRECTORY'};

sub get_dirs {
	my $dir = shift;
	my @dirs;
	opendir my $dh, $dir or die $!;
	for my $name (readdir($dh)) {
		next if $name =~ /^\./;
		my $path = File::Spec->catdir($dir, $name);
		if (-d $path) {
			(my $rel_path = $path) =~ s/$BASE_DIRECTORY//;
			push @dirs, { path => $rel_path, name => $name };
			my $inside_dirs = get_dirs($path);
			if (@$inside_dirs) {
				push @dirs, $inside_dirs;
			}
		}
	}
	return \@dirs;
}

sub get_images {
	my $rel_dir = shift;
	my $dir = File::Spec->catdir($BASE_DIRECTORY, $rel_dir);
	my @images;
	opendir my $dh, $dir or die $!;
	for my $name (readdir($dh)) {
		if ($name =~ /\.(gif|jpe?g|png|bmp)$/i) {
			my $path = File::Spec->catfile($dir, $name);
			my ($ino, $size, $ctime) = (stat($path))[1,7,10];
			push @images, {
				path  => $path,
				ino   => $ino,
				size  => size($size),
				ctime => ctime($ctime),
				src   => File::Spec->catfile($rel_dir, $name),
			};
		}
	}
	@images = sort { $a->{path} cmp $b->{path} } @images;
	return \@images;
}

my $MB = 1024 * 1024;
my $KB = 1024;
sub size {
	my $size = shift;
	return do {
		if (1024*$MB <= $size) { # GB?
			int($size/1024*$MB)."GB";
		}
		elsif ($MB <= $size) {
			int($size/$MB)."MB";
		}
		elsif ($KB <= $size) {
			int($size/$KB)."KB";
		}
		else {
			"${size}byte";
		}
	};
}

my @WDAY = qw/ 日 月 火 水 木 金 土 /;
sub ctime {
	my $ctime = shift;
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($ctime);
	$year += 1900;
	$mon += 1;
	($mon,$mday,$hour,$min,$sec) = sprintf02d($mon,$mday,$hour,$min,$sec);
	return "$year/$mon/$mday($WDAY[$wday]) $hour:$min:$sec.00";
}
sub sprintf02d { map sprintf('%02d', $_), @_ }

1;
__END__
