DemeterMate
===========

DemeterMate gives your ActiveRecord models a way to access association methods
without violating the Law of Demeter. For example, say a person `has_many`
projects. If you'd like to find a person's project by id, you'd normally use

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

-----

Copyright (c) 2011 Nick Morgan, released under the MIT license
