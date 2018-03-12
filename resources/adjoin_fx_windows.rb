#
# cookbook::adjoin_fx
# resource::adjoin_fx
#
# author::fxinnovation
# description::Custom resource for join a windows machine to an Active Directory
#

# Defining resource name
resource_name :adjoin_fx

# Declare provider
provides :adjoin_fx, platform_family: 'windows'

# Defining properties
property :target_ou,     String
property :username,      String,        required: true
property :domain,        String,        required: true
property :password,      String,        required: true, sensitive: true
property :handle_reboot, [true, false], default:  true

# Defining default action
default_action :join

# Defining join action
action :join do
  # Defining a reboot resource
  reboot "adjoin_fx_reboot_#{new_resource.name}" do
    reason     'Rebooting because of adjoin_fx_windows chef resource'
    delay_mins 0
    action     :nothing
  end

  # Defining target_ou_string
  if property_is_set?(:target_ou)
    target_ou_string = "-OUPath \"#{new_resource.target_ou}\""
  else
    target_ou_string = ''
  end

  # Joining to the domain
  powershell_script "ad_join_#{new_resource.name}" do
    not_if   '((gwmi win32_computersystem).partofdomain -eq $true)'
    notifies :reboot_now, 'reboot[reboot]', :immediately if new_resource.handle_reboot == true
    code     <<-EOH
$username = "#{new_resource.domain}\\#{new_resource.username}"
$password = "#{new_resource.password}" | ConvertTo-SecureString -asPLainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
$DomainNameFQDN = "#{new_resource.domain}"
Add-Computer $DomainNameFQDN #{target_ou_string} -Credential $credential -WarningAction SilentlyContinue -WarningVariable Message -Force -ErrorAction Stop
    EOH
  end
end
