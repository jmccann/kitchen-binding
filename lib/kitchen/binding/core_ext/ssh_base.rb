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
  module Driver
    # Override converge method from Kitchen::Driver::SSHBase to allow use of
    # Kitchen::Binding
    class SSHBase < Base
      # Overriding to add watching Chef Converge and connecting to
      # binding if started
      def converge(state)
        provisioner = instance.provisioner
        provisioner.create_sandbox
        sandbox_dirs = Dir.glob("#{provisioner.sandbox_path}/*")

        binding = instance.binding
        binding.state = state

        Kitchen::SSH.new(*build_ssh_args(state)) do |conn|
          run_remote(provisioner.install_command, conn)
          run_remote(binding.install_command, conn)

          run_remote(provisioner.init_command, conn)
          transfer_path(sandbox_dirs, provisioner[:root_path], conn)
          run_remote(provisioner.prepare_command, conn)

          # Run converge in a thread
          chef_run_thread = Thread.new do
            run_remote(provisioner.run_command, conn)
          end

          # Endlessly check until converge has completed
          while chef_run_thread.alive?
            debug("Chef thread still running")
            debug("Binding server running?: #{binding.test_connection}")
            binding.connect_command if binding.test_connection
          end
        end
      ensure
        provisioner && provisioner.cleanup_sandbox
      end
    end
  end
end
