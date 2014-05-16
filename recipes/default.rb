#
# Cookbook Name:: fetch-hadoop
# Recipe:: default
#
# Copyright 2014, Wegtam UG
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

include_recipe 'tar'

version = node['hadoop']['version']

# Create a user for hadoop.
user "#{node['hadoop']['user']['name']}" do
  comment 'User running hadoop'
  shell node['hadoop']['user']['shell']
  home "/home/hadoop"
  supports :manage_home => true
  action :create
end

# Generate password-less ssh-key for the user and allow localhost access.
directory '/home/hadoop/.ssh' do
  owner node['hadoop']['user']['name']
  mode 0700
  action :create
end
execute 'ssh-keygen -t rsa -f /home/hadoop/.ssh/id_rsa -P ""' do
  not_if { ::File.exists?("/home/hadoop/.ssh/id_rsa")}
end
execute 'ssh-keygen -t ecdsa -b 521 -f /home/hadoop/.ssh/id_ecdsa -P ""' do
  not_if { ::File.exists?("/home/hadoop/.ssh/id_ecdsa")}
end
execute 'cat /home/hadoop/.ssh/id_rsa.pub > /home/hadoop/.ssh/authorized_keys'
execute 'cat /home/hadoop/.ssh/id_ecdsa.pub >> /home/hadoop/.ssh/authorized_keys'
execute 'update ssh known_hosts' do
  command 'ssh-keyscan localhost 0.0.0.0 > /home/hadoop/.ssh/known_hosts'
  not_if { ::File.exists?("/home/hadoop/.ssh/known_hosts")}
end

# Fetch hadoop and extract it to the user's home.
tar_extract "http://apache.openmirror.de/hadoop/common/hadoop-#{version}/hadoop-#{version}.tar.gz" do
  target_dir "/home/hadoop"
  creates "/home/hadoop/hadoop-#{version}/bin/hadoop"
end

# Create hadoop directories.
dir = node['hadoop']['data-directory']
%w(/ /name /data /tmp /mapreduce /mapreduce/system /mapreduce/local).each do |name|
  directory "#{dir}#{name}" do
    owner node['hadoop']['user']['name']
    mode 0700
    action :create
  end
end

# Setup user environment.
template '/home/hadoop/.zshrc' do
  source 'user-zshrc.erb'
  mode '0600'
  owner node['hadoop']['user']['name']
  action :create
  variables :hadoop_home => "/home/hadoop/hadoop-#{version}", :java_home => node['java']['java_home']
end

# Setup core-site.xml.
vars = { :options => node['hadoop']['core-site'] }
template "/home/hadoop/hadoop-#{version}/etc/hadoop/core-site.xml" do
  source 'core-site.xml.erb'
  mode '0644'
  owner node['hadoop']['user']['name']
  action :create
  variables vars
end

# Setup hadoop-env.sh.
template "/home/hadoop/hadoop-#{version}/etc/hadoop/hadoop-env.sh" do
  source 'hadoop-env.sh.erb'
  mode '0644'
  owner node['hadoop']['user']['name']
  action :create
  variables :java_home => node['java']['java_home']
end

# Own everything to the user.
execute "chown -Rfh #{node['hadoop']['user']['name']}:#{node['hadoop']['user']['name']} /home/hadoop/"

