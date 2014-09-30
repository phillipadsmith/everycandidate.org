---
layout: post
title: "Help us find information on these eight candidates for city council"
date: 2014-09-30 9:25:00 # This is used in place of the filename
---

Yesterday we [announced on Twitter](https://twitter.com/EveryCandidate/status/516692811178315777) that we now have an e-mail for [each and every candidate running for school board trustee](/candidates/#toronto-school-board) in the upcoming election. Why is this important? Well, for starters, [There’s no excuse for ignoring the school board election](http://www.thestar.com/opinion/commentary/2014/09/19/theres_no_excuse_for_ignoring_school_board_election.html); if you have a friend or relative with public school-aged children, it's an important vote.

Similarly, we've been striving to reach 100% coverage of city council candidates in terms of contact information. We already believe that we have the [most complete open dataset of information on candidates](/data) thanks to some elbow grease and [your ongoing contributions](/about/#contributors) -- but we want to get to 100%! Can you help us get there? 

We're missing an e-mail address for these eight candidates:

{% assign candidatessource = site.data.toronto_council | sort: 'name_last_lower' %}
{% for candidate in candidatessource %}
{% if candidate.email == nil %}
* [{{ candidate.name_full }}](/toronto-city-council/{{ candidate.slug }}), [Ward {{ candidate.ward }}](/wards/#{{ candidate.ward }}) 
{% endif %}
{% endfor %}

Pitching in is easy: just ask yourself "Who do I know who would know these individuals?" and then reach out and see if you can locate their contact information. A quick search on a site like [Canada411](http://www.canada411.ca/) and a few phone calls can also get the job done.

If you live in one of the wards listed above, maybe you even have their flyer sitting in that pile of papers near your front door? If so, just snap a photo of it and <a href="mailto:everycandidate@gmail.com">send it out way</a>.

Just ten minutes can make a difference! [Thanks to more than 20 contributions from people just like you](/about/#contributors), we got to where we are today. Together, we can get to 100%.

