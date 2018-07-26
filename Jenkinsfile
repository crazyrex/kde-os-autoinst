env.DIST = 'xenial'
env.PWD_BIND = '/workspace'

if (env.TYPE == null) {
  if (params.TYPE != null) {
    env.TYPE = params.TYPE
  } else {
    type = inferType()
    if (type != null) {
      env.TYPE = type
    }
  }
}

if (env.OPENQA_SERIES == null) {
  env.OPENQA_SERIES = 'xenial'
}

if (env.TYPE == null) {
  error 'TYPE param not set. Cannot run install test without a type.'
}

properties([
  pipelineTriggers([upstream(threshold: 'UNSTABLE',
                             upstreamProjects: "iso_neon_${env.OPENQA_SERIES}_${TYPE}_amd64")]),
  pipelineTriggers([cron('0 H(9-22) * * *')])
])


lock(inversePrecedence: true, label: 'OPENQA_INSTALL', quantity: 1) {
  fancyNode('openqa') {
    try {
      stage('clone') {
        git 'git://anongit.kde.org/sysadmin/neon-openqa.git'
      }
      stage('rake-test') {
        sh 'rake test'
      }
      stage('iso-handover') {
          if (params.ISO) {
            echo 'Picking up ISO from trigger job.'
            sh "cp -v ${params.ISO} incoming.iso"
        }
      }

      stage('test_installation') {
        wrap([$class: 'LiveScreenshotBuildWrapper', fullscreenFilename: 'wok/qemuscreenshot/last.png']) {
          sh 'INSTALLATION=1 bin/contain.rb /workspace/bin/bootstrap.rb'
        }
      }
      if (env.ARCHIVE) {
        stage('archive-raid') {
          sh 'bin/archive.rb'
        }
      }
    } finally {
      dir('metadata') { archiveArtifacts allowEmptyArchive: true, artifacts: '*' }
      dir('wok') { archiveArtifacts allowEmptyArchive: true, artifacts: 'testresults/*, ulogs/*, video.*, vars.json, slide.html' }
      junit 'junit/*'
      sh 'bin/contain.rb chown -R jenkins .'
      // Make sure we fail if metadata was empty, we didn't assert this earlier
      // because we want the rest of the post-build to run.
      sh 'ls metadata/*'
    }
  }
}

def fancyNode(label = null, body) {
  node(label) {
    wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
      wrap([$class: 'TimestamperBuildWrapper']) {
        finally_cleanup { finally_chown { body() } }
      }
    }
  }
}

def finally_chown(body) {
  try {
    body()
  } finally {
    sh 'bin/contain.rb chown -R jenkins .'
  }
}

def finally_cleanup(body) {
  try {
    body()
  } finally {
    if (!env.NO_CLEAN) {
      cleanWs()
    }
  }
}

// When not called from an ISO build we'll want to infer the type from our own name.
def inferType() {
  if (!env.JOB_NAME) {
    return null
  }
  String[] types = ["useredition", "userltsedition", "devedition-gitunstable", "devedition-gitstable"]
  for (type in types) {
    if (env.JOB_NAME.contains(type)) {
      return type
    }
  }
  return null
}
