---
layout: post
title: "A first look at more than 50 Toronto District School Board candidates"
date: 2014-10-06 9:25:00 # This is used in place of the filename
---

<p>We've collected every Toronto District School Board candidate's Twitter profile photo that we could find so you don't have to visit 50+ separate websites to get a sense of who is running.</p>

<p>For the first time all the TDSB candidates Twitter profile photos on one page. Drop us a note in the comment section below and let us know what it says to you.</p>

{% assign candidatessource = site.data.toronto_school_board | sort: 'name_last_lower' %}
{% for candidate in candidatessource %}
{% if candidate.twitter_profile_photo != nil %}
<a title="{{ candidate.name_full }} (Ward {{ candidate.ward }}): {{ candidate.twitter_description | escape }}" href="/toronto-school-board/{{ candidate.slug }}"><img style="float: left;" src="{{ candidate.twitter_profile_photo}}" title="{{ candidate.name_full }} (Ward {{ candidate.ward }}): {{ candidate.twitter_description | escape }}" /></a>
{% endif %}
{% endfor %}
<br clear="all" />

Hover over any of the photos above to find out who the candidate is and where they are running. Click on the photo for more info. 

And, by the way, all of the candidate profile pages now have profile photos!
