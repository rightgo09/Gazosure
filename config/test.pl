use File::Spec;
use File::Temp qw/ tempdir /;
+{
	'BASE_DIRECTORY' => tempdir(CLEANUP => 1),
};
