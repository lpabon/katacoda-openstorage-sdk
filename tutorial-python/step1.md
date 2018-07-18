Start the `mock-sdk-server`:

`docker run --rm --name sdk -d -p 9100:9100 -p 9110:9110 openstorage/mock-sdk-server`{{execute}}

This will start the mock server

gRPC port 9100: https://[[HOST_SUBDOMAIN]]-9100-[[KATACODA_HOST]].environments.katacoda.com/
REST port 9110: https://[[HOST_SUBDOMAIN]]-9110-[[KATACODA_HOST]].environments.katacoda.com/

