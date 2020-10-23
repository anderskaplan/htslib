$version = `git describe --always --dirty`;
chomp($version);

# Unless the Git description is exactly a tag with a numeric name, revert to
# the original version number, but with the patchlevel field bumped to 255.
unless ($version =~ /^\d*\.\d*(\.\d*)?$/) {
  $version =~ s/^(\d*\.\d*)\..*/$1.255/;
}

print "Setting version to \"$version\".\n";

open(VERSION, ">version.h") or die "Cannot open version.h for writing.";
print VERSION "#define HTS_VERSION \"$version\"\n";
close(VERSION);
