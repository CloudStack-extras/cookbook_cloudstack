# Cookbook Name:: co-cloudstack3
# Recipe:: management_server
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
#
# Copyright:: Copyright (c) 2014 CloudOps.com
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
####
# Install CloudStack Management Server and perform required tunings.
####

include_recipe "co-cloudstack3::repo"

package "cloudstack-management" do
   action :install
   if ! node['cloudstack']['version'].empty?
     version node['cloudstack']['version']
   end
end
include_recipe "co-cloudstack3::vhd-util"


#
# Set nproc limits for user cloud
#
template node['cloudstack']['nproc_limit_file'] do
  source 'nproc_limits.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables :user          => node['cloudstack']['username'],
            :hard      => node['cloudstack']['nproc_limit_hard'],
            :soft          => node['cloudstack']['nproc_limit_soft'],
            :recipe_file   => (__FILE__).to_s.split("cookbooks/").last,
            :template_file => source.to_s
end
#
# Set nofile limits for user cloud
#
template node['cloudstack']['nofile_limit_file'] do
  source 'nofile_limits.erb'
  owner 'root'
  group 'root'
  mode 0755
  variables :user          => node['cloudstack']['username'],
            :hard          => node['cloudstack']['nofile_limit_hard'],
            :soft          => node['cloudstack']['nofile_limit_soft'],
            :recipe_file   => (__FILE__).to_s.split("cookbooks/").last,
            :template_file => source.to_s
end




#bash "cloudstack-setup-management" do
#  code "/usr/bin/cloudstack-setup-management"
#  not_if { ::File.exists?("/etc/cloudstack/management/tomcat6.conf") }
#end