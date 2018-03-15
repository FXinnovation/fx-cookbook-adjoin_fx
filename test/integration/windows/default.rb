#
# Inspec test for adjoin_fx on rhel platform family
#
# the Inspec refetence, with examples and extensive documentation, can be
# found at https://inspec.io/docker/reference/resources/
#
control 'adjoin_fx - windows - 01' do
  title 'The computer should be joined to a domain'
  describe powershell('(gwmi win32_computersystem).partofdomain') do
    its('stdout') { should match(/True/) }
  end
end
