docker: Dockerfile start.sh xcode/Contents/Info.plist xcode/carthage xcode/xcodebuild xcode/xcrun
	sudo docker build . -t quamotion/appium-docker-ios:dev
	docker image ls -q quamotion/appium-docker-ios:dev > docker_id

docker_id: docker

run: docker_id
	docker stop appium-docker-ios || true && docker rm appium-docker-ios || true

	sudo docker run \
		-p 4723:4723 \
		-v /var/run/usbmuxd:/var/run/usbmuxd \
		-v ${DEVELOPER_PROFILE_PATH}:/quamotion/quamotion.developerprofile \
		-v ${LICENSE_PATH}:/quamotion/.license \
		-v ${DEVELOPER_DISK_PATH}:/quamotion/devimg \
		-e DEVELOPER_PROFILE_PASSWORD=${DEVELOPER_PROFILE_PASSWORD} \
		--rm \
		--name appium-docker-ios \
		`cat docker_id`

debug: docker_id
	docker stop appium-docker-ios || true && docker rm appium-docker-ios || true

	sudo docker run \
		-p 4723:4723 \
		-v /var/run/usbmuxd:/var/run/usbmuxd \
		-v ${DEVELOPER_PROFILE_PATH}:/quamotion/quamotion.developerprofile \
		-v ${LICENSE_PATH}:/quamotion/.license \
		-v ${DEVELOPER_DISK_PATH}:/quamotion/devimg \
		-e DEVELOPER_PROFILE_PASSWORD=${DEVELOPER_PROFILE_PASSWORD} \
		--rm \
		--name appium-docker-ios \
		-it `cat docker_id` \
		/bin/bash

test:
	curl -X POST http://localhost:4723/wd/hub/session -H "Content-Type: application/json" -d @session.json
