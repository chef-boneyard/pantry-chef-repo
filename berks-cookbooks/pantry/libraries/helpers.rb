#
# Cookbook Name:: pantry
# Libraries:: helpers
#
# Author:: Joshua Timberman <jtimberman@getchef.com>
# Copyright:: Copyright (c) 2014, Joshua Timberman
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
#

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

module Pantry
  module Helpers
    def wifi_interface
      shell_out(%Q(networksetup -listallhardwareports | awk '$3=="Wi-Fi" { getline; print $2 }')).stdout.chomp
    end

    def wifi_powered_on?
      shell_out("networksetup -getairportpower #{wifi_interface} | awk '{print $NF}'").stdout.chomp.eql?('On')
    end

    def using_ntp?
      systemsetup_on?('getusingnetworktime')
    end

    def remote_login_enabled?
      systemsetup_on?('getremotelogin')
    end

    private

    def systemsetup_on?(getflag)
      getflag.gsub!(/-/, '') if getflag.start_with?('-')
      getflag.gsub!(/^/, 'get') unless getflag.start_with?('get')
      shell_out("systemsetup -#{getflag} | awk '{print $NF}'").stdout.chomp.eql?('On')
    end
  end
end

Chef::Recipe.send(:include, Pantry::Helpers)
Chef::Resource.send(:include, Pantry::Helpers)
Chef::Provider.send(:include, Pantry::Helpers)
