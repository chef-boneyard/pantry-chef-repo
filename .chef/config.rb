current_dir = File.dirname(__FILE__)
# https://github.com/chef/chef/issues/2449
chef_repo_path File.join(current_dir, '..', 'zero-repo')

# We'll use policyfiles with local mode.
use_policyfile true
policy_group 'local'
policy_name 'pantry'
versioned_cookbooks true
policy_document_native_api true
