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
  module Binding
    # pry-remote binding
    #
    # @author Jacob McCann <jmccann.git@gmail.com>
    class PryRemote < Base
      default_config :port, 9876
      default_config :sudo, true

      # (see Base#install_command)
      def install_command
        <<-INSTALL.gsub(/^ {10}/, "")
          if [[ $(/opt/chef/embedded/bin/gem list | grep -c pry-remote) -eq 0 ]]; then
            echo "-----> Installing Binding (pry-remote)"
            #{sudo(install_string)}
          else
            echo "-----> Binding (pry-remote) installation detected"
          fi
        INSTALL
      end

      # (see Base#connect_command)
      def connect_command
        info("Connecting to remote binding")
        require 'pry-remote'
        ::Pry.config.input = STDIN
        ::Pry.config.output = STDOUT

        argv = ['--server', hostname, '--port', port.to_s]

        client = ::PryRemote::CLI.new argv
        client.run
      end

      private

      def install_string
        level = config[:log_level] == :info ? :auto : config[:log_level]

        cmd = '/opt/chef/embedded/bin/gem install pry-remote'
        args = [
          '--no-rdoc',
          '--no-ri'
        ]
        args << '--debug' if level == :debug

        cmd = [cmd, *args].join(' ')
        debug("Remote binding install command: #{cmd}")

        cmd
      end
    end
  end
end
