## Create a volume

Now that we have connected to the cluster, let's go ahead and create a
volume of size 100Gi:

<pre class="file" data-filename="app.py">

try:
    volumes = api_pb2_grpc.OpenStorageVolumeStub(channel)
    v_resp = volumes.Create(api_pb2.SdkVolumeCreateRequest(
        name="myvol",
        spec=api_pb2.VolumeSpec(
            size=100*1024*1024*1024,
            ha_level=3,
        )
    ))
    print('Volume id is {0}'.format(v_resp.volume_id))
except grpc.RpcError as e:
    print('Failed: code={0} msg={1}'.format(e.code(), e.details()))

</pre>

### Using the client
Let's create the volume:

`python app.py`{{execute}}

## Create a snapshot

Notice the value of `name` provided above. This value is important since
it allows for the function to be idempotent. In other words, this function
will always return the same volume id for the volume of same name.

You can now create a snapshot of this volume:

<pre class="file" data-filename="app.py">

try:
    # Create a snapshot
    snap = volumes.SnapshotCreate(api_pb2.SdkVolumeSnapshotCreateRequest(
        volume_id=v_resp.volume_id,
    ))
    print('Snapshot created with id {0}'.format(snap.snapshot_id))
except grpc.RpcError as e:
    print('Failed: code={0} msg={1}'.format(e.code(), e.details()))

</pre>

### Using the client
Let's create the snapshot for the volume:

`python app.py`{{execute}}

Notice that a new volume is not created when we run the application again.
That is due to the the call being idempotent. Unlike the creation call,
calling snapshots again will create a new snapshot. Let's try that:

`python app.py`{{execute}}

Notice the id of the latest snapshot is different than the one previous.
