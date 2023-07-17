TAG=enexa-example-module:latest

build:
	docker build -t $(TAG) .

test:
	docker run --rm \
	-v $(PWD)/test-shared-dir:/shared \
	-e ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test/update \
	-e ENEXA_SERVICE_URL=http://enexa:36321/ \
	-e ENEXA_WRITEABLE_DIRECTORY=/shared/experiment1 \
	--network enexa-utils_default \
	$(TAG)
