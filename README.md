# Fetch Hadoop Cookbook

This cookbook fetches a hadoop distribution and installs it as a local
user. Some **very** basic configuration is done.

## Requirements

You should have `java` installed and the cookbook assumes a `zsh` on the
system for the user setup.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['hadoop']['version']</tt></td>
    <td>String</td>
    <td>The hadoop version.</td>
    <td><tt>2.4.0</tt></td>
  </tr>
  <tr>
    <td><tt>['hadoop']['data-directory']</tt></td>
    <td>String</td>
    <td>Which directory is the root directory for the hadoop data.</td>
    <td><tt>/hadoop</tt></td>
  </tr>
  <tr>
    <td><tt>['hadoop']['user']['name']</tt></td>
    <td>String</td>
    <td>Username for the hadoop user.</td>
    <td><tt>hadoop</tt></td>
  </tr>
  <tr>
    <td><tt>['hadoop']['user']['shell']</tt></td>
    <td>String</td>
    <td>The shell for the hadoop user.</td>
    <td>Platform dependent <tt>/usr/local/bin/zsh</tt> or
    <tt>/usr/bin/zsh</tt>.</td>
  </tr>
  <tr>
    <td><tt>['hadoop']['core-site']</tt></td>
    <td>Hash</td>
    <td>Settings for the <tt>core-site.xml</tt>.</td>
    <td>
    <pre><code>
      'hadoop.tmp.dir' => "#{data-directory}/tmp",
      'fs.defaultFS' => 'hdfs://localhost:49152',
      'dfs.name.dir' => "#{data-directory}/name",
      'dfs.data.dir' => "#{data-directory}/data",
      'dfs.replication' => 1,
      'mapred.system.dir' => "#{data-directory}/mapreduce/system",
      'mapred.local.dir' => "#{data-directory}/mapreduce/local",
      'mapred.job.tracker' => 'localhost:49153',
      'mapred.tasktracker.tasks.maximum' => 3,
      'mapred.child.java.opts' => '-Xmx1024'
    </code></pre>
    </td>
  </tr>
</table>

## Usage

Just include `fetch-hadoop` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[fetch-hadoop]"
  ]
}
```

You can include the recipe `fetch-hadoop::format-namenode` to format the
name node directly after the installation.

If the DFS service is running you can use
`fetch-hadoop::dfs-create-user-dir` to create the following directories:
* `/user`
* `/user/#{node['hadoop']['user']['name']}`

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

* Freely distributable and licensed under the [Apache 2.0 license](LICENSE).
* Copyright 2014 [Wegtam UG](http://www.wegtam.org)

### Authors:

* [@jan0sch](https://github.com/jan0sch)

