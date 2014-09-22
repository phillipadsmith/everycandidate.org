Bareword "downcase" not allowed while "strict subs" in use at template line 8, <DATA> line 79.
3: layout: candidate
4: title: "<%= $c->{'name_last'} %>, <%= $c->{'name_first'} %>"
5: name: "<%= $c->{'name'} %>"
6: name_last: "<%= $c->{'name_last'} %>"
7: name_first: "<%= $c->{'name_first'} %>"
8: name_sorby: "<%= $c->{'name_last'} | downcase %>"
9: id: <%= $c->{'id'} %>
10: ward: <%= $c->{'ward'} %>
11: permalink: /toronto-city-council/<%= $c->{'slug'} %>/
12: ---
