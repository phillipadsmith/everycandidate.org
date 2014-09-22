#!/usr/bin/env perl
# Install requirements with `carton install`

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
use DateTimeX::Easy;
use Mojo::Util qw/ encode slurp spurt /;
use Mojo::Loader;
use Mojo::Template;

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


for my $row ( @rows ) {
    my $candidate_name = $row->{'name_first'} . ' ' . $row->{'name_last'};
    my $candidate_id   = $row->{'candidate_id'};
    ( my $slug = lc( $candidate_name ) ) =~ s/\W/-/g;
    $slug .= '-' . $candidate_id;
    my $nomination_date   = $row->{'nomination_date'};
    my $dt = DateTimeX::Easy->new($nomination_date);
    $row->{'nomination_date'} = $dt->month_name . ' ' . $dt->day . ', ' . $dt->year;
    $row->{'slug'} = $slug;
    $row->{'name'} = $candidate_name;
    $row->{'id'} = $candidate_id;
    $row->{'sortby'} = lc( $row->{'name_last'} );
    my $output_path = '_toronto_city_council/' . $slug . '.md';
    my $loader      = Mojo::Loader->new;
    my $template    = $loader->data( __PACKAGE__, 'candidate' );
    my $mt          = Mojo::Template->new;
    my $output_str  = $mt->render( $template, $row);
    $output_str = encode 'UTF-8', $output_str;
    # Write the template output to a filehandle
    spurt $output_str, $output_path;
    say "Wrote $candidate_name to $output_path";
}

__DATA__
@@ candidate
% my $c = shift;
---
layout: candidate
title: "<%= $c->{'name_last'} %>, <%= $c->{'name_first'} %>"
name: "<%= $c->{'name'} %>"
name_last: "<%= $c->{'name_last'} %>"
name_first: "<%= $c->{'name_first'} %>"
name_sortby: "<%= $c->{'sortby'} %>"
id: "<%= $c->{'id'} %>"
ward: "<%= $c->{'ward'} %>"
permalink: "/toronto-city-council/<%= $c->{'slug'} %>/"
---

