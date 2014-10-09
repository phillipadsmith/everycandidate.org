---
layout: post
title: "Popularity contest: Which candidate is winning in your ward?"
date: 2014-10-10 9:25:00 # This is used in place of the filename
---

Admitedly, social media doesn't tell the whole story, but in today's media-obsessed culture it is certainly something worth looking at. In the table below, we've gathered up the latest data on city council candidate's Twitter accounts and presented it sorted by ward, then by number of followers (most followers to least). Feel free to sort the table any way you like to get a sense of the numbers. 

What stands out at first glance is outlier candidates like [Benjamin Dichter](/toronto-city-council/benjamin-dichter-1976/) with a whopping 100,000+ followers -- that's three times more than previous mayoralty candidate, [Sarah Thompson](toronto-city-council/%7B%20candidate.slug%20%7D%7D). While Twitter followers or social media savvy may not be a deciding factor in a race, people across the country applaud personalities like Calgary Mayor [Naheed Nenshi](https://twitter.com/nenshi/) (190,000 followers) for his candid and witty remarks online.

Have a look below. Let us know what you think!

(And, keep in mind that only candidates who've provided a link to their Twitter account are included. Know of a candidate's Twitter account that is missing? <a href="mailto:everycandidate@gmail.org">Drop us a line.</a>)

<table id="popularity" class="tablesorter-blue sortable">
<thead> 
<tr> 
    <th>Photo</th> 
    <th>Ward</th> 
    <th>Last Name</th> 
    <th>First Name</th> 
    <th>Follower Count</th> 
</tr> 
</thead> 
<tbody> 
{% for candidate in site.data.toronto_council  %}
{% if candidate.twitter_friends_count != nil %}
<tr>
    <td><a href="/toronto-city-council/{{ candidate.slug }}"><img src="{{ candidate.twitter_profile_photo }}" /></a></td><td><a href="/wards#{{ candidate.ward }}">{{ candidate.ward }}</a></td><td>{{ candidate.name_last }}</td><td>{{ candidate.name_first }}</td><td>{{ candidate.twitter_friends_count }}</td>
</tr>
{% endif %}
{% endfor %}
</table>
