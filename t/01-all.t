use Test::More no_plan => 1;
use Unicode::CheckUTF8 qw(isLegalUTF8String);

ok(1);

ok(  isLegalUTF8String("this is ascii",   13));
ok(! isLegalUTF8String("this is \0 null", 14));
