
GOCMD=go
GOFMT=gofmt

BIN=gitrob
REPO=github.com/rleibl/gitrob

# -------------------------------------------------------------------
all: fmt build test docker

# -------------------------------------------------------------------
#  For local development. Will build a static binary, build a docker 
#  container and run it locally
docker_dev: docker_run


# -------------------------------------------------------------------
#  Build 
# -------------------------------------------------------------------
build:
	$(GOCMD) build -o $(BIN) $(REPO)

test:
	$(GOCMD) test -v $(REPO)


# -------------------------------------------------------------------
#  Lint 
# -------------------------------------------------------------------
#
# Cannot use -w in development. Files will be open in the editor and
# will overwrite the changes or complain about modified files.
# Also, this step does not fail when there are differences found
fmt:
	$(GOFMT) -d $(GOPATH)src/$(REPO)

# go get -u golang.org/x/lint/golint
lint:
	$(GOPATH)/bin/golint -set_exit_status $(REPO)


# -------------------------------------------------------------------
# Docker
# -------------------------------------------------------------------
build_static:
	CGO_ENABLED=0 GOOS=linux $(GOCMD) build -o $(BIN) -a $(REPO) 
docker: build_static
	docker build -t $(REPO):latest .

# -------------------------------------------------------------------
clean:
	go clean
	rm -f $(BIN)
	# docker image rm $(REPO):latest
