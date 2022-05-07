#!/usr/bin/perl

#######################################################
# Fixes multiple references that are grouped together #
#######################################################

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std :utf8);

my $filename = $ARGV[0];

if (not defined $filename) {
  die "Need filename\n";
}

my $content = '';

open FILE, '<', $filename or die $!;

while (<FILE>) {
    $content .= $_;
}


# Get multiple references
my @matches = $content =~ /<sup>([0-9,]+)<\/sup>/g;
for(@matches){
  my $newstring = $_ =~ s/(\d+),?/[^$1] /gr;
  $content =~ s/$_/$newstring/;
}

$content =~ s/(<sup>|<\/sup>)//g;

open(FH, '>', $filename) or die $!;
print FH $content;
close(FH);
