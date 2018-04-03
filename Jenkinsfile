#!/bin/groovy
library(
    identifier: 'fxinnovation@1',
    retriever: legacySCM(
        [
            $class: 'GitSCM',
            branches: [[name: '*/1']],
            doGenerateSubmoduleConfigurations: false,
            extensions: [],
            submoduleCfg: [],
            userRemoteConfigs: [[
                credentialsId: 'jenkins_fxinnovation_bitbucket',
                url: 'https://bitbucket.org/fxadmin/fxinnovation-common-pipeline-library.git'
            ]]
        ]
    )
)

node{
  checkout scm
  foodcritic()
  cookstyle()
}
