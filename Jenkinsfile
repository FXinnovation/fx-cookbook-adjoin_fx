#!/bin/groovy
// Setting some notification variables
notify      = false
color       = "GREEN"
result      = "SUCCESS"
message     = "Build finished"
command_out = ""

// Call a slave 
node() {
  // Encapsulate everythig into a try catch for error handling
  try {
    // Enable colored output in Jenkins
    ansiColor('xterm') {
      // Pre-build stage
      stage ('pre-build') {
        message = 'pre-build: FAILED'
        // Checking out repository
        checkout scm
        // Retrieving commit id
        commit_id = sh(
          returnStdout: true, 
          script: "git rev-parse HEAD"
        ).trim()
        // Retrieving tag if it exists, if not commit id is saved again
        tag_id = sh(
          returnStdout: true, 
          script: "git describe --tags --exact-match || git rev-parse HEAD"
        ).trim()
        // Fetching branch name
        branch = sh (
          returnStdout: true,
          script:       'echo "${BRANCH_NAME}"'
        ).trim()
        // Verifying versions of tools
        sh 'docker run --rm fxinnovation/chefdk chef --version'
        // Generating new temporary key
        sh 'ssh-keygen -t rsa -f /tmp/id_rsa -P \'\''
      }
      // Foodcritic stage
      // This will launch foodcritic tests on current cookbook only
      stage ('foodcritic'){
        message = 'foodcritic: FAILED'
        sh 'docker run --rm -v \$(pwd):/data -w /data fxinnovation/chefdk foodcritic ./'
      }
      // Cookstyle stage
      // This will launch cookstyle tests on current cookbook only
      // NOTE: For the time being we do not allow exceptions because cookstyle is
      // already very permissive. Exception will be handled seperatly for every case
      stage ('cookstyle'){
        message = 'cookstyle: FAILED'
        sh 'docker run --rm -v \$(pwd):/data -w /data fxinnovation/chefdk cookstyle -D --force-default-config ./'
      }
      // Kitchen stage
      // This will launch kitchen tests on current cookbook
      stage ('kitchen') {
        message = 'kitchen: FAILED'
        sh 'docker run --rm -v \$(pwd):/data -v /tmp:/tmp -w /data fxinnovation/chefdk kitchen test --destroy=always -c 5'
      }
      stage ('publish') {
        message = 'publish: FAILED'
        if (commit_id != tag_id){
          // TODO Define publishing steps
        }else{
          println 'Not a tagged version, skipping publish'
        }
        message = 'SUCCESS'
      }
    }
  }catch(error){
    // Setting notification errors
    notify  = true
    color   = "RED"
    result  = "FAILURE"
    throw(error)
  }finally{
    // Notification stage
    // This will send a notification on hip chat :)
    stage('notification'){
      hipchatSend (
        color:        color,
        credentialId: 'jenkins-hipchat-token',
        message:      "Job Name: ${JOB_NAME} (<a href=\"${BUILD_URL}\">Open</a>)<br /> \
                       Job Status: ${result} <br /> \
                       Job Message: ${message}",
        room:         '942680',
        notify:       notify,
        sendAs:       'New-Jenkins',
        server:       'api.hipchat.com',
        v2enabled:    false
      )
    }
    // Clean workspace and other folders, needed to ensure we're capable of rebuilding
    // our cache.
    stage('cleaning'){
      // Making sure kitchen instances are destroyed
      sh 'docker run --rm -v \$(pwd):/data -v /tmp:/tmp -w /data fxinnovation/chefdk kitchen destroy -c 5'
      // Clean workspace
      cleanWs()
    }
  }
}
