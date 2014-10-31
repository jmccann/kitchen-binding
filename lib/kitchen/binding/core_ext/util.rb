# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2012, 2013, 2014, Fletcher Nichol
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

  # Stateless utility methods used in different contexts. Essentially a mini
  # PassiveSupport library.
  #
  # @author Fletcher Nichol <fnichol@nichol.ca>
  module Util

    # Generates a command (or series of commands) wrapped so that it can be
    # invoked on a remote instance or locally.
    #
    # This method uses the Bourne shell (/bin/sh) to maximize the chance of
    # cross platform portability on Unixlike systems.
    #
    # @param [String] the command
    # @return [String] a wrapped command string
    def self.wrap_command(cmd)
      cmd = "false" if cmd.nil?
      cmd = "true" if cmd.to_s.empty?
      cmd = cmd.sub(/\n\Z/, "") if cmd =~ /\n\Z/

      "sh -c '\n#{cmd}\n'"
    end

  end
end
