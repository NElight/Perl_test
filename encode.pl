#!/usr/bin/perl

use Encode;
use Encode::Guess;

require Encode::Detect;
require Encode::Detect::Detector;
#use lib qw(C:\Perl64\site\lib\Encode);

print @INC;

open IN, "<", "./r.info";
$info = <IN>;
@rinfo = split (/\t/, $info);
@temp = map {&enc_utf8($_)} @rinfo;
print "@temp";



sub enc_utf8($) {
	my $data = shift;
#      my $enc = guess_encoding($data, qw/utf8 gbk gb2312 big5/);
#      ref($enc) or die "Can't guess: $enc"; # trap error this way
   my $enc = Encode::Detect::Detector::detect($data);
      my $rel = decode($enc, $data);
      $rel = Encode::encode("gb2312", $rel);
      return $rel;
}

#sub enc_utf8($) {
#        my $str = shift;
#        my $encoding = '';
#        my @arr = qw(utf8 gbk gb2312 big5);
#        my $utf8_str = $str;
#        foreach my $enc (@arr) {
#                eval {my $str2 = $str; Encode::decode("$enc", $str2, 1)};
#                #print STDERR "$enc\t$@\n";
#                if (!$@) {
#                        $encoding = $enc;
#                        last;
#                }
#        }
#        #$encoding ||= 'utf8';
#        if ($encoding ne 'gb2312') {
#                $utf8_str = decode("$encoding",$str);
#                $utf8_str = Encode::encode("gb2312", $utf8_str, 1);
#        }
#        return $utf8_str;
#}