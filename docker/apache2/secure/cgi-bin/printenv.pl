#!/usr/bin/perl
##
##  printenv -- demo CGI program which just prints its environment
##
use utf8;
#binmode STDOUT, ':encoding(UTF-8)';

use Encode qw( decode encode ) ;
#use Text::Unidecode;

print "Access-Control-Allow-Origin: *\n";
print "Content-type: text/html;\n\n";
#print "Content-type: text/html; charset=iso-8859-1\n\n";
#print "Content-type: text/html;charset=utf8\n\n";

$str = "<h1>Print Environment Variables</h1>";
print "$str";

print "Perl default encoding: iso-8859-1<br>";
print "<pre>";
foreach $var (sort(keys(%ENV))) {
    $val = $ENV{$var};
    $val =~ s|\n|\\n|g;
    $val =~ s|"|\\"|g;
    print "${var}=\"${val}\"\n";
}
print "</pre>";
