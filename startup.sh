docker-compose down

docker-compose up --build -d

nohup pipr -hr -rp ./requirements.txt & > log.txt