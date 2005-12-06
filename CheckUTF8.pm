=head1 NAME

Unicode::CheckUTF8 - checks if scalar is valid UTF-8

=head1 SYNOPSIS

   use Unicode::CheckUTF8;
   my $is_valid = Unicode::CheckUTF8::isLegalUTF8String($scalar, length $scalar);

=head1 DESCRIPTION

This is an XS wrapper around some Unicode Consortium code to check
if a string is valid UTF-8.

=cut

package Unicode::CheckUTF8;

use base 'Exporter';

BEGIN {
   $VERSION = 0.01;

   @EXPORT = qw();
   @EXPORT_OK = qw(isLegalUTF8String is_utf8);

   require XSLoader;
   XSLoader::load Unicode::CheckUTF8, $VERSION;
}

1;

=head1 BUGS

Probably.

=head1 AUTHOR

Brad Fitzpatrick, based on Unicode Consortium code.

Artur Bergman, helping me kill old Inline code using his awesome
knowledge of all things Perl and XS.



