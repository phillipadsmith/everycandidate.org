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
use Mojo::Util qw/ encode slurp spurt /;
use Mojo::UserAgent;

use constant GOOGLE_SHEET_URL => 'https://docs.google.com/spreadsheets/d/';
use constant SHEET_ID    => '1ePIktd1I-U9DsVfeSrHWAN9-dMfefCgaBWwwHFwH0J0';
use constant OUTPUT_PATH => "$FindBin::Bin/../_data/";

my $sheets = {
    council => {
        gid        => '1832365855',
        output_csv => 'toronto_council.csv'
    },
    tdsb => {
        gid        => '1113661765',
        output_csv => 'toronto_school_board.csv'
    }
};

#https://docs.google.com/spreadsheets/d/1ePIktd1I-U9DsVfeSrHWAN9-dMfefCgaBWw…?format=csv&id=1ePIktd1I-U9DsVfeSrHWAN9-dMfefCgaBWwwHFwH0J0&gid=1113661765"

my $ua = Mojo::UserAgent->new->max_redirects( 5 );

for my $sheet ( keys %$sheets ) {

    # Get & output the CSV
    my $csv
        = $ua->get( GOOGLE_SHEET_URL
            . SHEET_ID
            . '/export?format=csv&id=' . SHEET_ID . '&gid='
            . $sheets->{$sheet}->{'gid'} )->res->body;
    say "Outputting  to $sheets->{ $sheet }->{'gid'} to "
        . OUTPUT_PATH
        . $sheets->{$sheet}->{'output_csv'};
    spurt $csv, OUTPUT_PATH . $sheets->{$sheet}->{'output_csv'};
}
