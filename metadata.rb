name             'adjoin_fx'
license          'MIT'
maintainer       'FXinnovation'
maintainer_email 'cloudsquad@fxinnovation.com'
description      'Joins a machine to a Active Directory'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.1'
chef_version     '>= 12.14' if respond_to?(:chef_version)
issues_url       'https://bitbucket.org/fxadmin/public-common-cookbook-adjoin_fx/issues'
source_url       'https://bitbucket.org/fxadmin/public-common-cookbook-adjoin_fx'
supports         'redhat',  '>= 7.0'
supports         'centos',  '>= 7.0'
supports         'windows', '>= 6.1'
