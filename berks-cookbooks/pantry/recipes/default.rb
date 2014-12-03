#
# Cookbook Name:: pantry
# Attributes:: default
#
# Copyright (C) 2014, Chef Software, Inc. <legal@getchef.com>
#

include_recipe "pantry::#{node['platform_family']}"
