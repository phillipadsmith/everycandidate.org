Every Candidate
================

![Every Candidate logo by the fine people at ethicalux.com](/https://github.com/phillipadsmith/everycandidate.org/blob/master/public/img/everycandidate_colour_logo.png "Every Candidate")

Every Candidate is a project that aims to chronical municipal elections in new an interesting ways. The project will start with Toronto's upcoming election on October 27th, 2014.

This repository contains the code that runs the public-facing [EveryCandidate.org](http://everycandidate.org) web site. It also contains any of the data that has been aquired and cleaned in the process.

This is very much a "minimum viable product" at the moment. Things should get more interesting ([especially if you contribute](#pitching-in)). 

If you'd like to contact me directly, you can do so [here](https://twitter.com/everycandidate) or [here](https://twitter.com/phillipadsmith). 

## Pitching in

This is a personal passion project, and incredibly under-resourced one. If you'd like to pitch in, there are a variety of ways to do so, including:

* Fixing typos
* Adding missing data
* [Web site improvements](#web-site-improvements)

## Web site improvements

You've got some mad web skillz and want to lend a hand? Super! Here's what you'll need to do:

* Get the project running locally on your computer
* Make your imrovements
* Send a pull request back to this repository

It's that easy. :)

### Install requirements

This is very much a work in progress!

* Jekyll 2.4.0 (and dependencies)

#### Installation

1. Get the source

`git clone git@github.com:phillipadsmith/everycandidate.org.git`


2. Install the JavaScript dependencies

`bower install`

3. Install the Ruby dependencies

If you don't have a global install of [Bundler](http://bundler.io/), you'll want to install that first:

`gem update && gem install bundler`

Then install the project requirements in local directory so that you know you're using the right ones:

`bundle install --path _vendor`

#### Bundler, Jekyll & development modes

If you run Jekyll though Bundler the project can the gems installed in the `_vendor` directory:

`bundle exec jekyll serve -w --config _config.yml`

That helps to ensure the project is using the right version of each gem, and that it's easily deployed. If you need to add more Ruby dependencies, add them to the `gemfile` and then run `bundle install --path _vendor`.

Configuration files can be added to switch modes:

`bundle exec jekyll serve -w --config _config.yml,_config.development.yml`

`bundle exec jekyll serve -w --config _config.yml`
