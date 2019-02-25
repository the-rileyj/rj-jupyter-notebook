rm nohup.out

docker-compose down

docker-compose up --build -d && \
nohup pipr -hr -cp ./config.json -rp ./requirements.txt &
