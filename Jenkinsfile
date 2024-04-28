pipeline 
{
    agent any

    stages{
        stage('Start'){
            steps{
                echo 'Init of pipeline'          
                echo 'Verify workspace: '
                echo WORKSPACE
            }
        }
        stage('Build'){
            steps{
                echo 'Build stage'
            }
        }
        stage('Tests'){
            parallel{
                stage('Unit'){
                    steps{
                        echo 'Perform unit tests'
                        catchError(buildResult:'UNSTABLE',stageResult:'FAILURE'){
                            bat '''
                                SET PYTHONPATH=%WORKSPACE%
                                pytest --junitxml=result-unit.xml test\\unit
                            ''' 
                        }
                    }
                }  
                stage('Rest'){
                    steps{
                        echo 'Perform service tests'
                        catchError(buildResult:'UNSTABLE',stageResult:'FAILURE'){
                            bat '''
                                SET PYTHONPATH=%WORKSPACE%
                                set FLASK_APP = app\\api.py
                                start flask run
                                start java -jar C:\\Unir\\wiremock-standalone-3.5.3.jar --port 9090 --root-dir test\\wiremock
                                pytest --junitxml=result-rest.xml test\\rest
                            '''  
                        }
                    }
                }
            }
        }
        stage('Final'){
            steps{
                junit 'result*.xml'
                echo 'End of pipeline'
            }
        }
    }
}