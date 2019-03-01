rm nohup.out

docker-compose down

docker-compose up --build -d && \

# Kill any running rjin instances
ps -aux | grep -Po ".*?\s+(\d+).*.*rjin.*" | grep -Po "^\w+\s+\d+" | grep -Po "\d+$" | xargs kill -9

nohup rjin -hr -cp ./config.json -dp ./dependency-lists/ &
