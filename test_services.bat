start "Flask" cmd /c "set FLASK_APP=app\api.py && flask run"

start "Wiremock" cmd /c "java -jar C:\Unir\wiremock-standalone-3.5.3.jar --port 9090 --root-dir test\wiremock"

curl -s http://localhost:5000/health || (timeout /t 5 && goto :flask_check)

curl -s http://localhost:9090/__admin || (timeout /t 5 && goto :wiremock_check)

pytest --junitxml=result-rest.xml test\rest
