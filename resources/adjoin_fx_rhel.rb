#
# cookbook::adjoin_fx
# resource::adjoin_fx
#
# author::fxinnovation
# description::Executing an adjoin on a rhel machine
#

# Declaring resource name
resource_name :adjoin_fx

# Defining default action
default_action :join

# Declare provider
provides :adjoin_fx, platform_family: 'rhel'

# Defining properties
property :target_ou, String, required: true
property :username,  String, required: true
property :domain,    String, required: true
property :password,  String, required: true, sensitive: true

# Defining join action
action :join do
  # Defining package list
  packages = $w(
    sssd
    adcli
    realmd
    samba-common-tools
    krb5-libs
    krb5-workstation
  )

  # Installing packages
  packages.each do |package_name|
    package package_name
  end

  # Joining AD
  # NOTE Putting 
  execute "adjoin_fx_#{new_resource.name}" do
    environment 'JOIN_USER_SECRET' => new_resource.password
    command     "echo \"${JOIN_USER_SECRET}\" | realm join -v \
                   --user=#{new_resource.username} \
                   #{new_resource.domain} \
                   --computer-ou=#{new_resource.target_ou} \
                   --unattended"
    not_if      "realm list | grep '^#{new_resource.domain}'"
    retries     3
    retry_delay 5
  end
end
