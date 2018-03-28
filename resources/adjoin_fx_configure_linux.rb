#
# cookbook::adjoin_fx
# resource::adjoin_fx_configure
#
# author::fxinnovation
# description::Allows you to configure realmd on linux machines
#

# Declaring resource name
resource_name :adjoin_fx_configure

# Declaring provider
provides :adjoin_fx_configure, os: 'linux'

# Declaring properties
property :login_groups, Array
property :login_users,  Array
property :deny_all,     [true, false]
property :domain,       String, required: true

# Declaring default action
default_action :configure

# Declaring configure action
action :configure do
  # Deny login from all groups if property is set for defined realm
  if property_is_set?(:deny_all)
    execute 'adjoin_fx_confgiure_deny_all' do
      command "realm deny -all --unattended --realm \"#{new_resource.domain.upcase}\""
      action  :run
    end
  end

  # Allow login from login groups if property is set
  if property_is_set?(:login_groups)
    # TODO: Add removal of any group which isn't passed on
    # For each login_groups
    new_resource.login_groups.each do |login_group|
      # Add the login group
      execute "adjoin_fx_configure_login_group_#{login_group}" do
        command "realm permit --realm \"#{new_resource.domain}\" --groups \"#{login_group.tr(' ', '_').downcase}\""
        not_if  "echo \"$(realm list | grep -Pzo \"^#{new_resource.domain}(\\s{2}.*){1,}\")\" | grep \"permitted-groups:\" | grep \"#{login_group}\""
        action  :run
      end
    end
  end

  # Allow login from login users if property is set
  if property_is_set?(:login_users)
    # TODO: Add removal of any user which isn't passed on
    new_resource.login_users.each do |login_user|
      execute "adjoin_fx_configure_login_user_#{login_user}" do
        command "realm permit --realm \"#{new_resource.domain}\" \"#{login_user.tr(' ', '_').downcase}\@#{new_resouce.domain}""
        not_if  "echo \"$(realm list | grep -Pzo \"^#{new_resource.domain}(\\s{2}.*){1,}\")\" | grep \"permitted-logins:\" | grep \"#{login_user}\""
        action  :run
      end
    end
  end
end
