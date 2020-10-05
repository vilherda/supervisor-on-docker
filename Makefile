VENDOR=vilherda
CTXNAME=$(VENDOR)
PRODUCT_NAME=supervisor
IMGNAME=$(CTXNAME)/$(PRODUCT_NAME)
BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
VCS_URL=`git remote -v | head -1 | cut -f 2 | cut -d ' ' -f 1`
VCS_BRANCH=`git rev-parse --abbrev-ref HEAD`
VCS_REF=`git rev-parse HEAD`
DESCRIP=Docker image of python software Supervisor
LONG_DESCRIP=$(DESCRIP)
LICENSE=CC0 1.0 Universal
VERSION=1.0.0
QUAL_IMGNAME=$(IMGNAME):$(VERSION)
INSTANCE_ID=$(PRODUCT_NAME)_running

default: help

help:
	@echo "Available tasks: \\n\
	- help : prints this information message (default) \\n\
	- clean : deletes the images '$(IMGNAME):latest' and '$(QUAL_IMGNAME)' on the local repository \\n\
	- build : builds the image '$(QUAL_IMGNAME)' and stores it into the local repository \\n\
	- run : executes the image '$(QUAL_IMGNAME)' (of he local repository) in detached mode \\n\
	- run-it : executes the image '$(QUAL_IMGNAME)' (of he local repository) in iterative mode \\n\
	- debug : opens a terminal session into container based on the image '$(QUAL_IMGNAME)' \\n\
	- stop : stops the container based on the image '$(QUAL_IMGNAME)' \\n\
	- logs : prints the logs of the service running on the container based on the image '$(QUAL_IMGNAME)' \\n\
	- push : pushes the image '$(QUAL_IMGNAME)' to the remote repository \\n\
	- release : builds the images '$(IMGNAME):latest' and '$(QUAL_IMGNAME)' and pushes them to the remote repository"

clean:
	docker rmi -f $(IMGNAME):latest $(QUAL_IMGNAME)

build:
	docker build \
		--label org.label-schema.name=$(PRODUCT_NAME) \
		--label org.label-schema.schema-version=1.0 \
		--label org.label-schema.schema-info-url=http://label-schema.org/rc1/#build-time-labels \
		--label org.label-schema.build-date=$(BUILD_DATE) \
		--label org.label-schema.description="$(DESCRIP)" \
		--label org.label-schema.long-description="$(LONG_DESCRIP)" \
		--label org.label-schema.license="$(LICENSE)" \
		--label org.label-schema.usage=$(VCS_URL) \
		--label org.label-schema.url=$(VCS_URL) \
		--label org.label-schema.vcs-ref=$(VCS_REF) \
		--label org.label-schema.vcs-branch=$(VCS_BRANCH) \
		--label org.label-schema.vcs-url=$(VCS_URL) \
		--label org.label-schema.vendor="$(VENDOR)" \
		--label org.label-schema.version=$(VERSION) \
		--label org.label-schema.docker.cmd="docker run --rm -it $(IMGNAME)" \
		--label org.label-schema.docker.cmd.debug="docker exec -it $(IMGNAME) /bin/bash" \
		-t $(IMGNAME):latest -t $(QUAL_IMGNAME) .

run:
	docker run --name $(INSTANCE_ID) --rm -d $(IMGNAME)

run-it:
	docker run --name $(INSTANCE_ID) --rm -it $(IMGNAME)

debug:
	docker exec -it $(INSTANCE_ID) /bin/bash

stop:
	docker stop $(INSTANCE_ID)

logs:
	docker logs $(INSTANCE_ID)

push:
	docker push $(QUAL_IMGNAME)
	docker push $(IMGNAME):latest

release: build push
