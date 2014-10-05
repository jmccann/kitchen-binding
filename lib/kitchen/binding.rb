# -*- encoding: utf-8 -*-
#
# Author:: Jacob McCann (<jmccann.git@gmail.com>)
#
# Copyright (C) 2014, Jacob McCann
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'thor/util'

module Kitchen
  # A binding is responsible for generating the commands necessary to
  # install, set up and use a interactive ruby shell for debugging called
  # from a Provisioner (e.g. Chef Cookbook during Chef Run)
  #
  # @author Jacob McCann <jmccann.git@gmail.com>
  module Binding
    # Default provisioner to use
    DEFAULT_PLUGIN = 'pry_remote'.freeze

    # Returns an instance of a binding given a plugin type string.
    #
    # @param plugin [String] a binding plugin type, to be constantized
    # @param config [Hash] a configuration hash to initialize the provisioner
    # @return [Binding::Base] a driver instance
    # @raise [ClientError] if a provisioner instance could not be created
    def self.for_plugin(plugin, config)
      require("kitchen/binding/#{plugin}")

      str_const = Thor::Util.camel_case(plugin)
      klass = const_get(str_const)
      klass.new(config)
    rescue LoadError, NameError
      raise ClientError,
        "Could not load the '#{plugin}' binding from the load path." \
          " Please ensure that your binding is installed as a gem or" \
          " included in your Gemfile if using Bundler."
    end
  end
end
