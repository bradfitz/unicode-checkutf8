use Test::More no_plan => 1;
use Unicode::CheckUTF8 qw(isLegalUTF8String is_utf8);

ok(1);

ok(  isLegalUTF8String("this is ascii",   13));
ok(! isLegalUTF8String("this is \0 null", 14));

ok(  is_utf8("this is ascii"));
ok(! is_utf8("this is \0 null"));


my @tests;  # array of arrayrefs of form [filename, good_or_bad, contents]

my $data_dir = "t/data";
opendir(D, $data_dir) or die "Couldn't open data directory: $!\n";
foreach my $f (readdir(D)) {
    next unless -f "$data_dir/$f";
    next if $f =~ /~$/;
    next unless $f =~ /^(GOOD|BAD)-/;
    my $good = ($f =~ /^GOOD/) ? 1 : 0;
    open (F, "$data_dir/$f") or die;
    my $contents = do { local $/; <F>; };
    push @tests, [ $f, $good, $contents ];
}
closedir(D);

my @subs = (
            ["with-len",    sub { return isLegalUTF8String($_[0], length $_[0]); }],
            ["without-len", sub { return is_utf8($_[0]); }],
            );


foreach my $s (@subs) {
    my $sb = $s->[1];
    foreach my $t (@tests) {
        my $rv = $sb->($t->[2]);
        is($rv, $t->[1], "file: $t->[0], func: $s->[0]");
    }
}
