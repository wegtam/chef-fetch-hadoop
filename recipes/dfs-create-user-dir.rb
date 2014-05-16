#
# Cookbook Name:: fetch-hadoop
# Recipe:: dfs-create-user-dir
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

version = node['hadoop']['version']
hadoop_home = "/home/hadoop/hadoop-#{version}"

execute 'dfs-create-user-dir' do
  command "#{hadoop_home}/bin/hdfs dfs -mkdir /user"
  user node['hadoop']['user']['name']
  environment ({ 'JAVA_HOME' => node['java']['java_home'], 'HADOOP_HOME' => "#{hadoop_home}" })
end

execute 'dfs-create-user-home-dir' do
  command "#{hadoop_home}/bin/hdfs dfs -mkdir /user/#{node['hadoop']['user']['name']}"
  user node['hadoop']['user']['name']
  environment ({ 'JAVA_HOME' => node['java']['java_home'], 'HADOOP_HOME' => "#{hadoop_home}" })
end

