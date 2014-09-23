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
use Text::CSV_XS;
use Mojo::Util qw/ encode slurp spurt /;
use Mojo::Loader;
use Mojo::Template;
use Mojo::JSON;


# Read the output path and filename from STDIN
my $input_file = shift @ARGV;
die 'No input file specified' unless $input_file;

my $filename = $input_file;
my @rows;
my $csv
    = Text::CSV_XS->new( { binary => 1, eol => $/, allow_loose_quotes => 1 }
    )    # should set binary attribute.
    or die "Cannot use CSV: " . Text::CSV->error_diag();

open my $fh, "<:encoding(utf8)", $filename or die "$filename: $!";
$csv->column_names( $csv->getline( $fh ) );

while ( my $row = $csv->getline_hr( $fh ) ) {
    push @rows, $row;
}

$csv->eof or $csv->error_diag();
close $fh;


for my $ward ( @rows ) {
    my $name = $ward->{'fed_district_name'};
    $name =~ s/-//;
    ( my $slug = lc( $name ) ) =~ s/\W/-/g;
    $slug .= '-' . $ward->{'school_ward_id'};
    $ward->{'slug'} = $slug;
    my $output_path = '_toronto_school_wards/' . $slug . '.md';
    my $loader      = Mojo::Loader->new;
    my $template    = $loader->data( __PACKAGE__, 'ward' );
    my $mt          = Mojo::Template->new;
    my $output_str  = $mt->render( $template, $ward);
    $output_str = encode 'UTF-8', $output_str;
    ## Write the template output to a filehandle
    spurt $output_str, $output_path;
    say "Wrote $ward->{'school_ward_id'} to $output_path";
}

__DATA__
@@ ward
% my $ward = shift;
---
layout: school_ward
title: "<%= $ward->{'fed_district_name'} =%>"
wid: "<%= $ward->{'school_ward_id'} %>"
ward: "ward_<%= $ward->{'school_ward_id'} %>"
permalink: "/toronto-school-ward/<%= $ward->{'slug'} %>/"
---
