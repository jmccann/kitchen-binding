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
  # Add some additioanl methods to Kitchen::DataMunger to allow use of
  # Kitchen::Binding
  class DataMunger
    # Generate a new Hash of configuration data that can be used to construct
    # a new Binding object.
    #
    # @param suite [String] a suite name
    # @param platform [String] a platform name
    # @return [Hash] a new configuration Hash that can be used to construct a
    #   new Binding
    def binding_data_for(suite, platform)
      merged_data_for(:binding, suite, platform).tap do |bdata|
        set_kitchen_config_at!(bdata, :kitchen_root)
        set_kitchen_config_at!(bdata, :test_base_path)
        set_kitchen_config_at!(bdata, :log_level)
      end
    end
  end
end
