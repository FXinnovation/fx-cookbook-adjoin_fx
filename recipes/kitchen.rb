#
# cookbook::adjoin_fx
# recipe::kitchen
#
# author::fxinnovation
# description::Recipe for kitchen tests, do not use in production
#

# Joining the AD
# NOTE: In order for this test to be succesfull we need a working AD
# we decided to launch a test AD with no config, nothing in it execpting
# a user to join the server. It won't be accessible publicly and only from
# our kitchen servers.
adjoin_fx 'default' do
  username   node['adjoin_fx']['username']
  domain     node['adjoin_fx']['domain']
  password   node['adjoin_fx']['password']
  server     node['adjoin_fx']['server']
  os_name    node['platform']              unless node['platform_family'] == 'windows'
  os_version node['platform_version']      unless node['platform_family'] == 'windows'
  new_name   node['platform']              if node['platform_family'] == 'windows'
  action     :join
end
