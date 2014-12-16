current_dir = File.dirname(__FILE__)
json_attribs_file = File.join(current_dir, '..', 'dna.json')
# https://github.com/opscode/chef/issues/2449
chef_repo_path File.join(current_dir, '..')

json_attribs json_attribs_file if json_attribs_file

cookbook_path [
  File.join(current_dir, '..', 'cookbooks'),
  File.join(current_dir, '..', 'berks-cookbooks')
]
