---
layout: page
title: Candidates 
seo_title: Toronto Municipal Election Candidates 
---

The (very small) "[team](/about#team)" at Every Candidate is working hard to gather and publish information on each and every candidate running for Toronto city council and the Toronto District School Board. 

If you'd like to know why we started this project, start [here](/about). If you'd like to [take the raw data](/data) and do something interesting, please do. If you'd like to help out, please [get in touch](/about#contact).

As of September 22nd, 2014, we are publishing the information we've collected on all 358 candidates running for Toronto city council. In the coming days, we will publish information on the Toronto District School Board candidates.

## Toronto City Council Candidates

{% assign candidates = site.toronto_city_council | sort: 'name_sortby' %}
{% for candidate in candidates %}
<a title="Toronto City Council candidate {{ candidate.name }}" href="{{candidate.permalink }}">{{ candidate.name }} {% if candidate.incumbent == 'yes' %}(Incumbent){% endif %}</a>
{% endfor %}
