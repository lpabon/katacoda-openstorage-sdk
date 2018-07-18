## Editing the client
Through the following sections, you will be editing the file `app.py`. Please
make sure to have this opened in the editor before continuing.

## Creating a connection
To use any of the gRPC functions, you must first create a connection with
the OpenStorage SDK server:

<pre class="file" data-filename="app.py">
channel = grpc.insecure_channel('localhost:9100')
</pre>

Notice the call [`grpc.insecure_channel()`](https://grpc.io/docs/guides/auth.html).
The `mock-sdk-server` currently does not support HTTPS or authentication,
so the tutorial will only focus on an insecure connection. The SDK project
will add HTTPS and authentication support in following releases.

Now that you have made a connection, you can use the `channel` object to create
clients for each of the services we would like to use. Let's use the [OpenStorageCluster](https://libopenstorage.github.io/w/generated-api.html#serviceopenstorageapiopenstoragecluster)
service to print the `id` of the cluster:

## Cluster operations

<pre class="file" data-filename="app.py">
try:
    # Cluster connection
    clusters = api_pb2_grpc.OpenStorageClusterStub(channel)
    ic_resp = clusters.InspectCurrent(api_pb2.SdkClusterInspectCurrentRequest())
    print('Conntected to {0} with status {1}'.format(
        ic_resp.cluster.id,
        api_pb2.Status.Name(ic_resp.cluster.status)
    ))
except grpc.RpcError as e:
    print('Failed: code={0} msg={1}'.format(e.code(), e.details()))
</pre>

Notice the `except` above. As mentioned in the
[Architecture](https://libopenstorage.github.io/w/arch.html#error-handling)
all errors are encoded using the
standard gRPC status. To gain access to the error code and its message you
must use `except grpc.RpcError as e` which decodes the error value and the message.

## Using the client
Let's see what the cluster id is by running our client:

`python app.py`{{execute}}
