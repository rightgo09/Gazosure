use strict;
use warnings;
use utf8;
use t::Util;
use Test::More;
use File::Spec;

use Gazosure::Web::Util;
sub temp_dir { Gazosure->config->{'BASE_DIRECTORY'} }
note(temp_dir);

# create test directory and file
#  tmp/
#   img.jpg
#   tmp1/
#    img1.jpg
#   tmp2/
#    img2.jpg
#    tmp22/
#     img22.jpg
#   tmp3/
#    img3.jpg
#    tmp33/
#     img33.jpg
#     tmp333/
#      img333.jpg
my $DIR_TREE = [
	{ path => '/tmp', name => 'tmp' },
	[
		{ path => File::Spec->catdir('/tmp', 'tmp1'), name => 'tmp1' },
		{ path => File::Spec->catdir('/tmp', 'tmp2'), name => 'tmp2' },
		[
			{ path => File::Spec->catdir('/tmp', 'tmp2', 'tmp22'), name => 'tmp22' },
		],
		{ path => File::Spec->catdir('/tmp', 'tmp3'), name => 'tmp3' },
		[
			{ path => File::Spec->catdir('/tmp', 'tmp3', 'tmp33'), name => 'tmp33' },
			[
				{ path => File::Spec->catdir('/tmp', 'tmp3', 'tmp33', 'tmp333'), name => 'tmp333' },
			],
		],
	],
];
my @IMAGES = (
	'tmp/img.jpg',
	'tmp/tmp1/img1.jpg',
	'tmp/tmp2/img2.jpg',
	'tmp/tmp2/tmp22/img22.jpg',
	'tmp/tmp3/img3.jpg',
	'tmp/tmp3/tmp33/img33.jpg',
	'tmp/tmp3/tmp33/tmp333/img333.jpg',
);

create_test_dir_and_file(temp_dir);
my $dirs = get_dirs(temp_dir);
is_deeply($dirs, $DIR_TREE);

my $images = get_images('tmp');
is($images->[0]->{path}, File::Spec->catfile(temp_dir, 'tmp', 'img.jpg'));
is($images->[0]->{src} , File::Spec->catfile(          'tmp', 'img.jpg'));
is($images->[0]->{size}, '0byte');


done_testing;

sub create_test_dir_and_file {
	my $temp_dir = shift;
	sub mkdir_r {
		my $dirs = shift;
		for my $dir (@$dirs) {
			if (ref($dir) eq 'ARRAY') {
				mkdir_r($dir);
			}
			else {
				mkdir(File::Spec->catdir(temp_dir, $dir->{path})) or die $!;
			}
		}
	}
	mkdir_r($DIR_TREE);
	for my $img (@IMAGES) {
		system('touch', File::Spec->catfile($temp_dir, $img)) and die $!;
	}
}

