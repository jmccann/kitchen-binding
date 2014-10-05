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

module Kitchen
  # Override certain methods from Kitchen::Config to allow use of
  # Kitchen::Binding
  class Config
    # Generates the immutable Test Kitchen configuration and reasonable
    # defaults for Drivers, Provisioners and Bindings.
    #
    # @return [Hash] a configuration Hash
    # @api private
    def kitchen_config
      @kitchen_config ||= {
        :defaults => {
          :driver       => Driver::DEFAULT_PLUGIN,
          :provisioner  => Provisioner::DEFAULT_PLUGIN,
          :binding      => Binding::DEFAULT_PLUGIN
        },
        :kitchen_root   => kitchen_root,
        :test_base_path => test_base_path,
        :log_level      => log_level
      }
    end

    # Builds a newly configured Instance object, for a given Suite and
    # Platform.
    #
    # @param suite [Suite,#name] a Suite
    # @param platform [Platform,#name] a Platform
    # @param index [Integer] an index used for colorizing output
    # @return [Instance] a new Instance object
    # @api private
    def new_instance(suite, platform, index)
      Instance.new(
        :busser       => new_busser(suite, platform),
        :driver       => new_driver(suite, platform),
        :logger       => new_logger(suite, platform, index),
        :suite        => suite,
        :platform     => platform,
        :provisioner  => new_provisioner(suite, platform),
        :binding      => new_binding(suite, platform),
        :state_file   => new_state_file(suite, platform)
      )
    end

    private

    # Builds a newly configured Binding object, for a given Suite and
    # Platform.
    #
    # @param suite [Suite,#name] a Suite
    # @param platform [Platform,#name] a Platform
    # @return [Binding] a new Binding object
    # @api private
    def new_binding(suite, platform)
      bdata = data.binding_data_for(suite.name, platform.name)
      Binding.for_plugin(bdata[:name], bdata)
    end
  end
end
