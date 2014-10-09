// Let the user search for their ward by address
var message_div = $('.riding-message');
// Riding lookup based on user input
$('.riding-search').submit(function (e) {
    e.preventDefault();
    // First, find the latitude and longitude for this address
    var geocoder = new google.maps.Geocoder();
    var search   = $('#riding-search input[type=text]').val();
    var mobile   = $('#riding-search-mobile input[type=text]').val();
    var address  = search ? search : mobile;
    geocoder.geocode({'address': address,
                     'region': 'ca'}, function(results, status) {
                         show_options( results );
                     });
});

function show_options(results) {
    message_div.children().remove();
    if ( results.length > 1 ) {
        // Resolve multiple possible addresses
        message_div.append('<p>Which of these looks like your address:</p>').removeClass("alert-error alert-success").addClass("alert alert-warning");
        $.each(results, function() {
            var result = this;
            message_div.append($('<a href="#" onClick="event.preventDefault();">' + this.formatted_address + '</a><br />').click(function () {
                districts_for_geocoder_result(result);
            }));
        });
    } 
    else if ( results.length === 0 ) {
        message_div.append('<p>No match for that address.</p>').removeClass("alert-warning").addClass("alert alert-error");
    }
    else {
        districts_for_geocoder_result( results[0] );
    }
}

// Try to automatically find the user
if (navigator.geolocation) {
    var geocoder = new google.maps.Geocoder();
    $('#geolocate-span').show();
    $('#geolocate-link').click(function (e) {
        e.preventDefault();
        navigator.geolocation.getCurrentPosition(function(position) {
            var geolocateLatLng = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
            geocoder.geocode({'latLng': geolocateLatLng},
                             function(results, status) {
                                 show_options( results );
                             });
        });
    });
}

// With a lat/lng we can request information from Represent
function districts_for_geocoder_result(result) {
    // 'result' is a Google geocoder response object
    // latitude lives in result.geometry.location.lat()
    message_div.children().remove();
    message_div.append('<p>' + result.formatted_address + '</p>');
    var lat = result.geometry.location.lat();
    var lng = result.geometry.location.lng();
    var url = 'http://represent.opennorth.ca/boundaries/?callback=?&contains=' + lat + ',' + lng;
    $.getJSON(url, function (data) {
     data = data.objects;
    var boundary_sets = data.map(function(d) { return d.boundary_set_name; });
    boundary_sets = boundary_sets.filter(function(d) { return d === 'Toronto ward'; });
        if ( boundary_sets.length === 0 ) {
            message_div.append('<p>No ward found. Is that address in Toronto?</p>').removeClass("alert-success").addClass("alert-error");
        }
        $.each(data, function (index) {
            if ( this.boundary_set_name == 'Toronto ward' ) {
               var link = this.name.toLowerCase();
               link = link.replace(/\(/g, ""); // parens
               link = link.replace(/\)/g, ""); // parens
               link = link.replace(/'/g, ""); //  quotes
               link = link.replace(/\./g, ""); //  periods
               link = link.replace(/\W/g, "-");
               message_div.append('<p>Your ward is most likely <a href="/toronto-ward/' + link + '">' + this.name + ', visit the ward page</a>.</p>').removeClass("alert-warning").addClass("alert alert-success");
}
        });
    });
}


$(document).ready(function() 
    { 
        $('#popularity').tablesorter({
            sortList: [[1,0],[4,1]]
        }); 
        $('.sortable').tablesorter({

        }); 
    } 
); 
