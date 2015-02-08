kitchen-binding
===============
[![Gem Version](https://badge.fury.io/rb/kitchen-binding.svg)](https://rubygems.org/gems/kitchen-binding)
[![Dependency Status](https://gemnasium.com/jmccann/kitchen-binding.svg)](https://gemnasium.com/jmccann/kitchen-binding)

kitchen-binding is an extension to [test-kitchen](https://github.com/test-kitchen/test-kitchen) to allow setting breakpoints in your cookbooks.  When encountered during a converge test-kitchen will then login to an interactive ruby shell for your debugging pleasure.  When you are finished the converge will continue where it left of.  It will continue to pickup any other breakpoints you may have setup through the run as well.

A product from discussion @ [Chef Summit 2014](https://github.com/opscode/chef-summit-2014/wiki/friday_metropolitan_1000)

Try It Out
----------
Check out what it does with the help of my cookbook [tk-bindings](https://github.com/jmccann/tk-bindings).  Make sure to adhear to the [Pre-Setup for Ruby](https://github.com/jmccann/kitchen-binding#ruby-version-dependencies) below first.  The other items are already in the .kitchen.yml for tk-bindings.

Pre-Setup
---------

Currently there is some required pre-setup you will need to do in order to use this extension.

### Instance Networking

If you are using vagrant then the instance must currently have a 33.33.33.200 IP accessbile from the host as this is currently hardcoded.  This is one of the first things I plan on working to address.

If you are using Openstack or some other driver it should just work.

#### Vagrant
If you are using a vagrant driver you will need to have a virtual private newtwork setup on the guest with an IP.  This is a requirement for the default binding plugin 'pry-remote' as pry-remote's dependencies use RPC which eventually uses a random port that you can not dynamically create a port forward for (or atleast not easily).  An idea to make this easier would be to setup a virtual private network for all of your vagrant instances by setting the following in your ~/.kitchen/config.yml

```ruby
driver:
  network:
  - ["private_network", {ip: "33.33.33.200"}]
```

### Ruby Version Dependencies
The version of uby you use on your host system must match the version of ruby
being used by Chef in the instance.  This is ruby 1.9.3-p547 for Chef 11 and
ruby 2.1 for Chef 12.  This is a requirement because DRB libraries used by
'pry-remote' do not seem compatible across ruby versions.

This can be easily controlled by using a ruby version/environment manager.

#### rbenv
If you use rbenv with ruby-build

Install needed ruby:
```
rbenv install 1.9.3-p547
```

Then while inside the repo for the cookbook you want to test pin the repo version specifically for that cookbook:
```
rbenv local 1.9.3-p547
```

Then you'll probably need to install bundler and/or the required gems:
```
gem install bundler
bundle install
```

How to Use
----------

The default remote binding supported is [pry-remote](https://github.com/Mon-Ouie/pry-remote).  Add anywhere in your Chef rubies code the following:

```ruby
require 'pry-remote'
binding.remote_pry '0.0.0.0'
```

This will insert a breakpoint into the code that will start a pry-remote server listening on all addresses (by default it listens only on localhost).

Setup your Gemfile for your cookbook with the line:

```
gem 'kitchen-binding'
```

Then finally you need to add some ERB to your .kitchen.yml to load the library:

```ruby
# <% require 'kitchen/binding' %>
# <% require 'kitchen/binding/base' %>
```

The above could also be added to your ~/.kitchen/config.yml if you wanted it always available.

Then do a kitchen converge doing `bundle exec kitchen converge` and if the breakpoint is hit you should get dropped into an interactive ruby shell.

Contributing
------------
* Source hosted at [GitHub](https://github.com/jmccann/kitchen-binding)
* Report issues/questions/feature requests on [GitHub Issues](https://github.com/jmccann/kitchen-binding/issues)

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Authors
-------
Created and maintained by Jacob McCann (<jmccann.git@gmail.com>)
