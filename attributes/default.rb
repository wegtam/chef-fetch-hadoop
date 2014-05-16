#
# Cookbook Name:: fetch-hadoop
# Attributes:: default
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

data_directory = '/hadoop'

default['hadoop']['version'] = '2.4.0'
default['hadoop']['data-directory'] = data_directory
default['hadoop']['user']['name'] = 'hadoop'

case node['platform']
when 'freebsd'
  shell = '/usr/local/bin/zsh'
else
  shell = '/usr/bin/zsh'
end

default['hadoop']['user']['shell'] = shell

default['hadoop']['core-site'] = {
  'hadoop.tmp.dir' => "#{data_directory}/tmp",
  'fs.defaultFS' => 'hdfs://localhost:49152',
  'dfs.name.dir' => "#{data_directory}/name",
  'dfs.data.dir' => "#{data_directory}/data",
  'dfs.replication' => 1,
  'mapred.system.dir' => "#{data_directory}/mapreduce/system",
  'mapred.local.dir' => "#{data_directory}/mapreduce/local",
  'mapred.job.tracker' => 'localhost:49153',
  'mapred.tasktracker.tasks.maximum' => 3,
  'mapred.child.java.opts' => '-Xmx1024'
}

