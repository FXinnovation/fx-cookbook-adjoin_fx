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
        sh 'chef --version'
        sh 'foodcritic --version'
        sh 'cookstyle --version'
      }
      // Foodcritic stage
      // This will launch foodcritic tests on current cookbook only
      stage ('foodcritic'){
        message = 'foodcritic: FAILED'
        sh 'foodcritic ./'
      }
      // Cookstyle stage
      // This will launch cookstyle tests on current cookbook only
      // NOTE: For the time being we do not allow exceptions because cookstyle is
      // already very permissive. Exception will be handled seperatly for every case
      stage ('cookstyle'){
        message = 'cookstyle: FAILED'
        sh 'cookstyle -D --force-default-config ./'
      }
      // Kitchen stage
      // This will launch kitchen tests on current cookbook
      stage ('kitchen') {
        message = 'kitchen: FAILED'
        // Execute only if on master or on a pull request branch
        sh 'kitchen test --destroy=always -c 5'
      }
      stage ('publish') {
        message = 'publish: FAILED'
        if (commit_id != tag_id){
          // TODO Define publishing steps
        }else{
          println 'Not a tagged version, skipping deployment'
        }
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
      message = 'SUCCESS'
      hipchatSend (
        color: color,
        credentialId: '',
        message: "Job Name: ${JOB_NAME} (<a href=\"${BUILD_URL}\">Open</a>)<br /> \
                  Job Status: ${result} <br /> \
                  Job Message: ${message}",
        room: '',
        notify: notify,
        sendAs: 'Jenkins',
        server: 'api.hipchat.com',
        v2enabled: true
      )
    }
    // Clean workspace and other folders, needed to ensure we're capable of rebuilding
    // our cache.
    stage('clean workspace'){
      cleanWs()
      sh 'rm -rf ~/.berkshelf/.cache/git'
    }
  }
}
