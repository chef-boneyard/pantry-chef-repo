#
# Author:: Joshua Timberman (<jtimberman@opscode.com>)
# Author:: Graeme Mathieson (<mathie@woss.name>)
# Cookbook Name:: homebrew
# Resources:: tap
#
# Copyright 2011-2013, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

actions :tap, :untap
attribute :name,
          :name_attribute => true,
          :kind_of        => String,
          :regex          => /^[\w-]+(?:\/[\w-]+)+$/

attribute :tapped,
          :kind_of => [TrueClass, FalseClass]

### hax for default action
def initialize(*args)
  super
  @action = :tap
end
