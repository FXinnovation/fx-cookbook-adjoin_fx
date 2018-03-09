#
# cookbook::adjoin_fx
# recipe::kitchen
#
# author::fxinnovation
# description::Recipe for kitchen tests, do not use in production
#

# adjoin_fx 'default' do
#   target_ou node['adjoin_fx']['target_ou']
#   username  node['adjoin_fx']['username']
#   domain    node['adjoin_fx']['domain']
#   password  node['adjoin_fx']['password']
#   action    :join
# end
file 'C:\\Windows\\test.txt' do
  action :create
end
