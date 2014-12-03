#
# Cookbook Name:: pantry
# Attributes:: mac_os_x
#
# Copyright (C) 2014, Chef Software, Inc. <legal@getchef.com>
#

chef_gem 'plist'
ohai('system_profile') { plugin 'system_profile' }.run_action(:reload)

directory '/opt/homebrew-cask' do
  mode 00775
end

directory '/opt/homebrew-cask/Caskroom' do
  mode 00775
end

# Chef::Provider::User::Dscl uses this directory, but nothing actually creates it by default.
# https://github.com/opscode/chef/issues/1634
directory '/var/db/shadow/hash' do
  recursive true
end
