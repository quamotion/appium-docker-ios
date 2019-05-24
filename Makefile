docker: Dockerfile
	sudo docker build . -t quamotion/appium-docker-ios:dev
	docker image ls -q quamotion/appium-docker-ios:dev > docker_id

docker_id: docker

run: docker_id
	sudo docker run \
		-p 4723:4723 \
		-v /var/run/usbmuxd:/var/run/usbmuxd \
		-v ${DEVELOPER_PROFILE_PATH}:/quamotion/quamotion.developerprofile \
		-v ${LICENSE_PATH}:/quamotion/.license \
		-e DEVELOPER_PROFILE_PASSWORD=${DEVELOPER_PROFILE_PASSWORD} \
		--rm \
		--name appium-docker-ios \
		`cat docker_id`

debug: docker_id
	sudo docker run \
		-p 4723:4723 \
		-v /var/run/usbmuxd:/var/run/usbmuxd \
		-v ${DEVELOPER_PROFILE_PATH}:/quamotion/quamotion.developerprofile \
		-v ${LICENSE_PATH}:/quamotion/.license \
		-e DEVELOPER_PROFILE_PASSWORD=${DEVELOPER_PROFILE_PASSWORD} \
		--rm \
		--name appium-docker-ios \
		-it `cat docker_id` \
		/bin/bash