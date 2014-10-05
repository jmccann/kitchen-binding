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
  # Add some additioanl methods to Kitchen::Instnace to allow use of
  # Kitchen::Binding
  class Instance
    # @return [Binding::Base] binding object which will the setup
    #   and invocation instructions for remote interactive ruby shells
    attr_reader :binding

    def initialize(options = {})
      validate_options(options)

      @suite        = options.fetch(:suite)
      @platform     = options.fetch(:platform)
      @name         = self.class.name_for(@suite, @platform)
      @driver       = options.fetch(:driver)
      @provisioner  = options.fetch(:provisioner)
      @binding      = options.fetch(:binding)
      @busser       = options.fetch(:busser)
      @logger       = options.fetch(:logger) { Kitchen.logger }
      @state_file   = options.fetch(:state_file)

      setup_driver
      setup_provisioner
    end
  end
end
