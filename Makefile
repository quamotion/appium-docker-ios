docker: Dockerfile
	sudo docker build . -t quamotion/appium-docker-ios:dev
	docker image ls -q quamotion/appium-docker-ios:dev > docker_id

docker_id: docker

run: docker_id
	sudo docker run \
		-p 4723:4723 \
		--rm \
		-it `cat docker_id` \
		/bin/bash