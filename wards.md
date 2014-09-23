---
layout: page
title: Wards 
seo_title: Toronto City Council & School Wards 
---

The (very small) "[team](/about#team)" at Every Candidate is working hard to gather and publish information on each and eery ward in Toronto, for both Toronto city council and the Toronto District School Board. 

If you'd like to know why we started this project, start [here](/about). If you'd like to [take the raw data](/data) and do something interesting, please do. If you'd like to help out, please [get in touch](/about#contact).

As of September 22nd, 2014, we are publishing the information we've collected on all 44 Toronto city council wards. In the coming days, we will publish information on the Toronto District School Board wards.

(You can also [view a list of council candidates here](/candidates/#toronto-council) and [school board trustee candidates here](/candidates/#toronto-school-board).)

<ul>
    <li><a href="#toronto-wards">Toronto Wards</a></li>
    <li><a href="#toronto-school-wards">Toronto District School Board Wards</a></li>
</ul>

<h2 id="toronto-wards">Toronto Wards</a></h2>

{% assign wards = site.toronto_wards %}
{% for ward in wards %}
<a id="{{ ward.wid }}" title="Toronto City Council ward {{ ward.title }}" href="{{ ward.permalink }}">{{ ward.title }} ({{ ward.wid }})</a>
{% endfor %}

<h2 id="toronto-school-wards">Toronto District School Board Wards</h2>

{% assign school_wards = site.toronto_school_wards %}
{% for ward in school_wards %}
<a id="school-{{ ward.wid }}" title="Toronto District School Board ward {{ ward.title }}" href="{{ ward.permalink }}">{{ ward.title }} ({{ ward.wid }})</a>
{% endfor %}
