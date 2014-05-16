name             'fetch-hadoop'
maintainer       'Wegtam UG'
maintainer_email 'devops@wegtam.com'
license          'Apache 2.0'
description      'Installs/Configures Hadoop in pseudo distributed mode.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.9.6'

depends 'tar'
depends 'zsh'

recommends 'java'

%w(hadoop hadoop_cluster hadoop_cluster_rpm hadoop_for_hbase hbase hbase_cluster hive pig zookeeper zookeeper_cluster).each do |name|
  conflicts name
end

