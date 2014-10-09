---
layout: post
title: "Popularity contest: Which council candidate is winning in your ward?"
date: 2014-10-10 9:25:00 # This is used in place of the filename
---

Admitedly, social media doesn't tell the whole story, but in today's media-obsessed culture it is always fun to observe. 

In the table below, we've gathered up the latest data on city council candidate's Twitter accounts. We've presented it sorted by ward, then by number of followers, the most followers to least. Feel free to sort the table any way you like -- just click on the header you want to sort by -- to get a sense of the numbers. 

What stands out at first glance is an outlier like [Benjamin Dichter](/toronto-city-council/benjamin-dichter-1976/) with a whopping 100,000+ followers -- that's three times more than previous mayoralty candidate, [Sarah Thompson](toronto-city-council/%7B%20candidate.slug%20%7D%7D), and almost seven times more than the councilor he is aiming to unseat, [Kristyn Wong-Tam](/toronto-city-council/kristyn-wong-tam-2010/). At this rate, Dichter might even catch up to [Toronto mayor Rob Ford](https://twitter.com/TOMayorFord) (178k followers). There must be an interesting story there. 

While Twitter followers or social media savvy may not be a deciding factor in a race, people across the country applaud personalities like Calgary Mayor [Naheed Nenshi](https://twitter.com/nenshi/) (190k followers) for his candid and witty remarks online.

Then there's Derek Power. A dashing Twitter profile photo, but only three followers! (Admission, I think that we were the first to follow the candidate). You should probably follow him because Twitter isn't very much fun with only three followers.

Enjoy the table below, and let us know what you think!

(And, keep in mind that only candidates who've provided a link to their Twitter account are included. Know of a candidate's Twitter account that is missing? <a href="mailto:everycandidate@gmail.org">Drop us a line.</a>)

<table id="popularity" class="tablesorter-blue sortable">
<thead> 
<tr> 
    <th>Photo</th> 
    <th>Ward</th> 
    <th>Name</th> 
    <th>Follower Count</th> 
</tr> 
</thead> 
<tbody> 
{% for candidate in site.data.toronto_council  %}
{% if candidate.twitter_friends_count != nil %}
<tr>
    <td><a href="/toronto-city-council/{{ candidate.slug }}"><img src="{{ candidate.twitter_profile_photo }}" /></a></td><td><a href="/wards#{{ candidate.ward }}">{{ candidate.ward }}</a></td><td><a href="/toronto-city-council/{{ candidate.slug }}">{{ candidate.name_last }}, {{ candidate.name_first }}</a></td><td>{{ candidate.twitter_friends_count }}</td>
</tr>
{% endif %}
{% endfor %}
</table>
