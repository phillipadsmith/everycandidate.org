#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

# Find modules installed w/ Carton
use FindBin;
use lib "$FindBin::Bin/../local/lib/perl5";

use Config::JFDI;
use Data::Dumper;
use Getopt::Long::Descriptive;
use DateTime;
use Date::Parse;
use Net::Google::Spreadsheets;
use FindBin qw($Bin);
use Mojo::DOM;
use Mojo::UserAgent;

my ( $opt, $usage )
    = describe_options( '%c %o',
    [ 'debug|d', "don't actually do anything, but be verbose" ],
    [ 'council|c', "scrape council" ],
    [ 'trustees|t', "scrape trustees" ],
    );
say "Not doing anything because the debug flag is set..." if $opt->debug;

print($usage->text), exit unless $opt->council or $opt->trustees;

my $config
    = Config::JFDI->new( name => "everycandidate", path => "$FindBin::Bin" );
my $conf = $config->get;
say Dumper( $conf ) if $opt->debug;

my $office = $opt->council ? '2' : '3';
say "Scraping office $office" if $opt->debug;

my $office_worksheet = $opt->council ? 'council_worksheet_title' : 'tdsb_worksheet_title';
say "Using the worksheet: $office_worksheet" if $opt->debug;

my $TORONTO_CA_VOTE      = 'http://app.toronto.ca/vote/';
my $START                = $TORONTO_CA_VOTE . 'campaign.do';
my $CANDIDATES_BY_OFFICE = $TORONTO_CA_VOTE
    . 'searchCandidateByOfficeType.do?criteria.officeType=' . $office;
my $CANDIDATE_DETAIL         = $TORONTO_CA_VOTE . 'candidateInfo.do?id=';
my $TABLE_ACTIVE_CSS_PATH    = '#activeTable';
my $TABLE_WITHDRAWN_CSS_PATH = '#withdrawnTable';

my $ua      = Mojo::UserAgent->new;
my $service = Net::Google::Spreadsheets->new(
    username => $conf->{'google_user'},
    password => $conf->{'google_pass'},
);

main();

sub main {
    my @candidates_active = _scrape_candidate_data();
    my %candidates = map { $_->{'candidateid'} => $_ } @candidates_active;
    my $results    = _check_data_and_update( \%candidates );
}

sub _check_data_and_update {
    my $candidates = shift;
    my $worksheet  = get_worksheet_from_google( $service );
    return unless $worksheet;
    my $dt = DateTime->now( time_zone => 'America/New_York' );
    my @rows = $worksheet->rows;
    my @cols_to_check
        = qw/ address facebook phonecampaignoffice misc phonecell website home email phone phonebusiness twitter /;
    for my $row ( @rows ) {
        my $r = $row->{'content'};

        # Do I have missing data for this candidate?
        for my $field ( @cols_to_check ) {
            if ( !$r->{$field} ) {

                # If so, let's try to add it from the city's data
                #say "No data for $field for candidate " . $r->{'namefull'};
                #say "Looking for data from city";
                my $city_data
                    = $candidates->{ $r->{'candidateid'} }->{$field};
                if ( $city_data ) {
                    say "Updated the field '$field' with '$city_data' for $r->{'namefull'}";
                    $row->param( { $field    => $city_data } );
                    $row->param( { 'updated' => $dt->ymd . ' ' . $dt->hms } );
                }
            }
        }

        # If not, we're missing it!
    }
}

sub _scrape_candidate_data {
    my $page_start_for_session_id = $ua->get( $START => { DNT => 1 } );
    my $page_candidates
        = $ua->get( $CANDIDATES_BY_OFFICE => { DNT => 1 } )->res->body;

    my $dom               = Mojo::DOM->new( $page_candidates );
    my @rows_active       = $dom->find( '#activeTable > tbody > tr' )->each;
    my @candidates_active = _extract_active_candidate_data( \@rows_active );
    @candidates_active
        = sort { lc( $a->{'namelast'} ) cmp lc( $b->{'namelast'} ) }
        @candidates_active;

    return @candidates_active;
}

sub _extract_active_candidate_data {
    my $rows = shift;
    my @candidates;
    for my $row ( @$rows ) {
        my $name = $row->td->[0]->a->text;
        my $candidate_id
            = _extract_candidate_id( $row->td->[0]->{'onclick'} );
        say "Scraping $candidate_id ...";
        my %candidate = (
            candidateid => $candidate_id,
            namefirst   => _extract_name( 'first', $name ),
            namelast    => _extract_name( 'last', $name ),
            email       => $row->td->[3]->a->text,
            phone       => $row->td->[4]->text,
            website     => $row->td->[5]->a->text
        );

        # Grab the extra data here, once we have the ID
        my $extra_data = _extract_candidate_extra_data( $candidate_id );
        for my $key ( keys %$extra_data ) {
            my $slug = $key;
            $slug =~ s/\W/_/;
            $slug = lc( $slug );
            $candidate{$slug} = $extra_data->{$key};
        }
        push @candidates, \%candidate;
    }
    return @candidates;
}

sub _fix_urls {

    # Not used
}

sub _extract_candidate_id {
    my $string = shift;
    $string =~ m/(?<id>\d{4})/;
    my $id = $+{'id'};
    return $id;
}

sub _extract_candidate_extra_data {
    my $candidate_id = shift;
    my $url          = $CANDIDATE_DETAIL . $candidate_id;
    my $page_candidate
        = $ua->get( $CANDIDATE_DETAIL . $candidate_id => { DNT => 1 } )
        ->res->body;
    my $dom      = Mojo::DOM->new( $page_candidate );
    my $fb_link  = $dom->at( '.fb a' );
    my $tw_link  = $dom->at( '.twit a' );
    my $address  = $dom->at( '.address' );
    my $facebook = $fb_link ? $fb_link->attr( 'href' ) : '';
    my $twitter  = $tw_link ? $tw_link->text : '';
    $address = $address ? $address->text : '';
    my %candidate_other = (
        facebook => $facebook,
        twitter  => $twitter,
        address  => $address,
    );
    my $others = $dom->find( '.other' );
    my $phones = $dom->find( '.phoneNum' );

    for my $number ( $phones->each ) {
        $number->text =~ /^(.*): (.*)$/;
        my $num_type = $1;
        $num_type =~ s/\W//g;
        $num_type = lc( $num_type );
        $candidate_other{ 'phone' . $num_type } = $2;
    }
    my @others;
    for my $other ( $others->each ) {
        $other->text =~ /^(.*): (.*)$/;
        push @others, $2;
    }
    $candidate_other{'misc'} = join( ', ', @others );
    return \%candidate_other;
}

sub _extract_name {
    my $part_of_name = shift;    # First, or Last
    my $string       = shift;
    my ( $last, $first ) = split( ', ', $string );
    $part_of_name eq 'first' ? return $first : return $last;
}

sub _extract_date {
    my $date_str = shift;
    my $time = str2time( $date_str, 'EST' );
    return $time;
}

sub get_worksheet_from_google {
    my $service = shift;

    # find a spreadsheet by title
    my $spreadsheet = $service->spreadsheet(
        { title => $conf->{'google_spreadsheet_title'} } );

    #find a worksheet by title
    my $worksheet = $spreadsheet->worksheet(
        { title => $conf->{ $office_worksheet } } );
    return $worksheet;
}
