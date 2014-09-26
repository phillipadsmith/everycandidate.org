---
layout: post
title: "Are seven lobbyists running for city council in Toronto's upcoming election?"
date: 2014-09-26 15:25:00 # This is used in place of the filename
published: false
---

Following up on [this morning's post on candidate's past campaign contributions](/2014/09/26/campaign-contributions/), we are releasing a list of candidates who are running for city council positions and where the candidate's name appears to be listed in the [City of Toronto's Lobbyist Registry System](http://app.toronto.ca/lobbyistsearch/disclaimer.do): 

{% assign candidatessource = site.data.toronto_council | sort: 'name_last_lower' %}
{% for candidate in candidatessource %}
{% if candidate.lobbyist_registry %}
* [{{ candidate.name_full }}](/toronto-city-council/{{ candidate.slug }}), [Ward {{ candidate.ward }}](/wards/#{{ candidate.ward }}) (Listed as "{{ candidate.lobbyist_registry }}")
{% endif %}
{% endfor %}

Note that these results are based on a name match with a record in the City's Lobbyist Registry System. Records may indicate a prior or current registration: please search the [registry](http://app.toronto.ca/lobbyistsearch/disclaimer.do) for more information on the specific activities. If you believe that there is an error in the information listed above, please <a href="mailto:everycandidate@gmail.com">let us know</a>.

According to the [Office of the Lobbyist Registrar site](http://www1.toronto.ca/wps/portal/contentonly?vgnextoid=cf1fb7537e35f310VgnVCM10000071d60f89RCRD&appInstanceName=default), the office's responsibilities are to:

> [To] promote and enhance the transparency and integrity of City government decision making through public disclosure of lobbying activities and regulation of lobbyists' conduct.

The office defines "lobbying" as follows:

> In general, lobbying consists of activities that can influence the opinions or actions of a public office holder ... lobbying is communicating with a public office holder on a range of subjects including decisions on by-laws, policies and programs, grants, purchasing, and applications for services, permits, licenses or other permission.

There are two types of lobbyst listed above, and here are how they are defined by the city:

> A **consultant lobbyist** is someone who — for payment — lobbies on behalf of a client (another individual, company, partnership or organization). 

> An **in-house lobbyist** is an employee, partner or sole proprietor who lobbies on behalf of their own employer, business or organization. 
