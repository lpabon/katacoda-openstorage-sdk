## Setting up mock-sdk-server

For simplicity this tutorial will use the `mock-sdk-server` provided by the
OpenStorage project. It is an in-memory storage system implementation of the
OpenStorage SDK and it makes it possible to develop your client by simply
running a container on your laptop or system.

Run the following command to start the server:

`
$ docker run --rm --name sdk -d -p 9100:9100 -p 9110:9110 openstorage/mock-sdk-server
`{{execute}}

Running this docker command will expose port `9100` for the gRPC server, and
port `9110` for the gRPC REST Gateway connection.

Let's test the connection now before continuing by running the following to the
gRPC REST Gateway:

`curl -X GET "http://docker:9110/v1/clusters/current" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{}"
`{{execute}}

This should return information about the cluster in JSON format, as shown below:

`{"cluster":{"status":"STATUS_OK","id":"mock"}}`

## REST Swagger User Interface
If you would like to access the Swagger-ui for use with `curl` or other REST clients,
follow the link below. Once on the Swagger UI, you must the the _Schemes_ value to
**HTTPS** to make it work with Katacoda.

[Swagger UI](https://[[HOST_SUBDOMAIN]]-9110-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui)

