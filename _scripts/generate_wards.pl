#!/usr/bin/env perl 

use strict;
use warnings;
use utf8;
use feature 'say';

# Find modules installed w/ Carton
use FindBin;
use lib "$FindBin::Bin/../local/lib/perl5";

# Actual modules the script requires
use Data::Dumper;

use Mojo::Util qw/ encode slurp spurt /;
use Mojo::Loader;
use Mojo::Template;
use Mojo::JSON;


# Read the output path and filename from STDIN
my $input_file = shift @ARGV;
die 'No input file specified' unless $input_file;
my $raw_data = slurp( $input_file );

my $j = Mojo::JSON->new();
my $data = $j->decode( $raw_data );
my $wards = $data->{'objects'};

for my $ward ( @$wards ) {
    my $name = $ward->{'name'};
    $name =~ s/ \(\d+\)//g;
    $ward->{'name'} = $name;
    my $url = $ward->{'url'};
    my @parts = split('/', $url);
    my $slug  = $parts[3];
    $ward->{'slug'} = $slug;
    my $output_path = '_toronto_wards/' . $slug . '.md';
    my $loader      = Mojo::Loader->new;
    my $template    = $loader->data( __PACKAGE__, 'ward' );
    my $mt          = Mojo::Template->new;
    my $output_str  = $mt->render( $template, $ward);
    $output_str = encode 'UTF-8', $output_str;
    ## Write the template output to a filehandle
    spurt $output_str, $output_path;
    say "Wrote $ward->{'external_id'} to $output_path";
}

__DATA__
@@ ward
% my $ward = shift;
---
layout: ward
title: "<%= $ward->{'name'} =%>"
wid: "<%= $ward->{'external_id'} %>"
ward: "ward_<%= $ward->{'external_id'} %>"
permalink: "/toronto-ward/<%= $ward->{'slug'} %>/"
---
