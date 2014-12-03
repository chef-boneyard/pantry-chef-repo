# This test recipe is used within test kitchen to perform additional
# setup, or to configure custom resources in the main cookbook.

# For example, update the apt cache on Debian systems, which avoids
# requiring the `apt` cookbook. This doesn't work, of course, if the
# apt cache must be updated before the main cookbook's default recipe
# is run.
execute 'apt-get update' if platform_family?('debian')
