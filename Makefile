TAG=enexa-example-module:latest

DOCKER_NETWORK=enexa-utils_default
SHARED_DIR=$(PWD)/test-shared-dir
ID=mi-$(shell date +%s)
ENEXA_SHARED_DIRECTORY=/shared
ENEXA_WRITEABLE_DIRECTORY=$(ENEXA_SHARED_DIRECTORY)/writeable
ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test
ENEXA_MODULE_INSTANCE_IRI=http://example.org/$(ID)

build:
	docker build -t $(TAG) .

test: $(SHARED_DIR)/writeable
	# things which ENEXA is supposed to do
	echo "INSERT DATA { <$(ENEXA_MODULE_INSTANCE_IRI)> <http://example.org/input-parameter-1> 3 }" |docker run -i --attach STDIN --rm --network $(DOCKER_NETWORK) $(TAG) sparql-update "$(ENEXA_META_DATA_ENDPOINT)"

	docker run --rm \
	-v $(SHARED_DIR):$(ENEXA_SHARED_DIRECTORY) \
	-e ENEXA_SERVICE_URL=http://enexa:36321/ \
	-e ENEXA_SHARED_DIRECTORY=$(ENEXA_SHARED_DIRECTORY) \
	-e ENEXA_WRITEABLE_DIRECTORY=$(ENEXA_WRITEABLE_DIRECTORY) \
	-e ENEXA_META_DATA_ENDPOINT=$(ENEXA_META_DATA_ENDPOINT) \
	-e ENEXA_MODULE_INSTANCE_DIRECTORY=$(ENEXA_WRITEABLE_DIRECTORY)/$(ID) \
	-e ENEXA_MODULE_INSTANCE_IRI=$(ENEXA_MODULE_INSTANCE_IRI) \
	--network $(DOCKER_NETWORK) \
	$(TAG)

$(SHARED_DIR)/writeable:
	mkdir -p $(SHARED_DIR)/writeable
