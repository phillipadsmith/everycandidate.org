---
layout: page
title: Candidates 
seo_title: Toronto Municipal Election Candidates 
---

The (very small) "[team](/about#team)" at Every Candidate is working hard to gather and publish information on each and every candidate running for Toronto city council and the Toronto District School Board. 

If you'd like to know why we started this project, start [here](/about). If you'd like to [take the raw data](/data) and do something interesting, please do. If you'd like to help out, please [get in touch](/about#contact).

As of September 22nd, 2014, we are publishing the information we've collected on all 358 candidates running for Toronto city council. In the coming days, we will publish information on the Toronto District School Board candidates.

(You can also [view a list of wards here](/wards/#toronto-wards) and a [list of school board wards here](/wards/#toronto-school-wards).)

<ul>
    <li><a href="#toronto-council">Toronto City Council Candidates</a></li>
    <li><a href="#toronto-school-board">Toronto District School Board Candidates</a></li>
</ul>

<h2 id="toronto-council">Toronto City Council Candidates</h2>

{% assign candidates = site.toronto_city_council | sort: 'name_sortby' %}
{% for candidate in candidates %}
<a title="Toronto City Council candidate {{ candidate.name }}" href="{{candidate.permalink }}">{{ candidate.name }} (Ward {{ candidate.ward }})</a> {% if candidate.incumbent == 'yes' %}(Incumbent){% endif %}
{% endfor %}

<h2 id="toronto-school-board">Toronto District School Board Candidates</h2>

{% assign school_candidates = site.toronto_school_board | sort: 'name_sortby' %}
{% for candidate in school_candidates %}
<a title="Toronto District School board trustee candidate {{ candidate.name }}" href="{{candidate.permalink }}">{{ candidate.name }} (Ward {{ candidate.ward }})</a> {% if candidate.incumbent == 'yes' %}(Incumbent){% endif %}
{% endfor %}
