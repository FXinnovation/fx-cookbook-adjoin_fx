name             'adjoin_fx'
license          'MIT'
maintainer       'FXinnovation'
maintainer_email 'cloudsquad@fxinnovation.com'
description      'Join a machine to a Active Directory'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
# TODO Define correct version of supported chef
chef_version     '>= 12.1' if respond_to?(:chef_version)
issues_url       'https://bitbucket.org/fxadmin/public-common-cookbook-adjoin_fx/issues'
source_url       'https://bitbucket.org/fxadmin/public-common-cookbook-adjoin_fx'
supports         'redhat'
supports         'windows'
