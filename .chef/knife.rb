current_dir = File.dirname(__FILE__)
# https://github.com/opscode/chef/issues/2449
chef_repo_path File.join(current_dir, '..')

cookbook_path [
  File.join(current_dir, '..', 'cookbooks'),
  File.join(current_dir, '..', 'berks-cookbooks')
]
