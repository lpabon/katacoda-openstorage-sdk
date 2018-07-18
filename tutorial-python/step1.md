Start the `mock-sdk-server`:

`docker run --rm --name sdk -d -p 9100:9100 -p 9110:9110 openstorage/mock-sdk-server`{{execute}}

Now check that it is running:

`curl -X GET "http://docker:9110/v1/clusters/current" \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -d "{}"
`{{execute}}

This will start the mock server


## REST Swagger User Interface
If you would like to access the Swagger-ui for use with `curl` or other REST clients,
follow the link below. Once on the Swagger UI, you must the the _Schemes_ value to
**HTTPS** to make it work with Katacoda.

[Swagger UI](https://[[HOST_SUBDOMAIN]]-9110-[[KATACODA_HOST]].environments.katacoda.com/swagger-ui)

