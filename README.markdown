DemeterMate
===========

Introduction
------------

DemeterMate is a Rails 3 plugin that gives your ActiveRecord models a way to
access association methods without violating the Law of Demeter. For example,
say a person `has_many` projects. If you'd like to find a person's project by
id, you'd normally use

    @person.projects.find id

This breaks the Law of Demeter, increasing coupling and making testing with
stubs and mocks a chore. DemeterMate fixes this by making the following possible:

    @person.find_project id

The following ActiveRecord methods are supported by DemeterMate:

    :push
    :concat
    :build
    :create
    :create!
    :size
    :length
    :count
    :sum
    :empty?
    :clear
    :delete
    :delete_all
    :destroy_all
    :find
    :find_first
    :exists?
    :uniq
    :reset

So, if your `Person` model `has_many` `Project`s, you could add a new project like so:

    @person.push_project project

DemeterMate is flexible with the order - both of the following are valid:

    @person.projects_empty?
    @person.empty_projects?

It's also flexible on inflection - use whichever makes sense:

    @person.push_project project
    @person.push_projects project


Usage
-----

    Person < ActiveRecord::Base
      has_many :projects
      demeter_mate :projects
    end


Installation
------------

    rails plugin install git@github.com:skilldrick/demeter_mate.git

-----

Copyright (c) 2011 Nick Morgan, released under the MIT license
