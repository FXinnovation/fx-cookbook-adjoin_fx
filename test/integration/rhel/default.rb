#
# Inspec test for adjoin_fx on rhel platform family
#
# the Inspec refetence, with examples and extensive documentation, can be
# found at https://inspec.io/docker/reference/resources/
#
control 'adjoin_fx - rhel - 01' do
  title 'Ensure required packages are installed'
  packages = %w(
    sssd
    adcli
    realmd
    samba-common-tools
    krb5-libs
    krb5-workstation
  )
  packages.each do |package_name|
    describe package(package_name) do
      it { should be_installed }
    end
  end
end

control 'adjoin_fx - rhel - 02' do
  title 'Ensure ocmputer is joined to a domain'
  describe command('realm list') do
    its('stdout') { should match(/domain-name:/) }
    its('stdout') { should match(/realm-name:/) }
  end
end

control 'adjoin_fx_configure - rhel - 01' do
  title 'Ensure computer has correct login groups'
  describe command('realm list') do
    its('stdout') { should match(/fakegroup/) }
  end
end

control 'adjoin_fx_configure - rhel - 02' do
  title 'Ensure computer has correct login users'
  describe command('realm list') do
    its('stdout') { should match(/fakeuser/) }
  end
end
