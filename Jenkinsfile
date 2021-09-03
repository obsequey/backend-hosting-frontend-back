pipeline {
  agent any

  environment {
    GIT_REPO_NAME = env.GIT_URL.replaceFirst(/^.*\/([^\/]+?).git$/, '$1')
    SOME_SECRET_KEY = credentials('some-secret-key')
    REGISTRY_HOST = credentials('docker-registry-host')
    FRONT_REPO_URL = 'git@github.com:obsequey/backend-hosting-frontend-front.git'
  }

  stages {
    stage('Build frontend') {
      steps {
        sh 'mkdir -p front'
        dir('front') {
          git(url: env.FRONT_REPO_URL, branch: env.GIT_BRANCH, credentialsId: github)
          sh 'npm i'
          sh 'npm run build:mac'
          sh 'mv -p dist ../.'
        }
      }
    }

    stage('Build backend') {
      steps {
        sh 'echo ${SOME_SECRET_KEY}'
        sh 'docker build . -t "${REGISTRY_HOST}/${GIT_REPO_NAME}-${BRANCH_NAME}"'
        sh 'docker push ${REGISTRY_HOST}/${GIT_REPO_NAME}-${BRANCH_NAME}'
        sh 'docker stop ${GIT_REPO_NAME}-${BRANCH_NAME} || true'
        sh 'IMAGE_EXPOSED_PORT=`docker inspect ${REGISTRY_HOST}/${GIT_REPO_NAME}-${BRANCH_NAME} --format="{{json .Config.ExposedPorts}}" | egrep [0-9]+ -o | head -1`'
        sh 'docker run -d --rm --name ${GIT_REPO_NAME}-${BRANCH_NAME} -p ${IMAGE_EXPOSED_PORT} ${REGISTRY_HOST}/${GIT_REPO_NAME}-${BRANCH_NAME}'
        sh '''
          JENKINS_IMAGE_PORT=`docker port ${GIT_REPO_NAME}-${BRANCH_NAME} | egrep [0-9]+$ -o | head -1`
          echo "localhost:$JENKINS_IMAGE_PORT"
        '''
      }
    }

  }
}
