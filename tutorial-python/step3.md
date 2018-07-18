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

## Backup
In this section we will be making a backup of our volume to a cloud provider.
To do this, we must first create a set of credentials which will enable
the storage system to save the backup in the cloud.

```python
    # Create a credentials
    creds = api_pb2_grpc.OpenStorageCredentialsStub(channel)
    cred_resp = creds.Create(api_pb2.SdkCredentialCreateRequest(
        aws_credential=api_pb2.SdkAwsCredentialRequest(
            access_key='dummy',
            secret_key='dummy',
            endpoint='dummy',
            region='dummy'
        )
    ))
    print('Credential id is {0}'.format(cred_resp.credential_id))
```

Notice above the [`api_pb2.SdkCredentialCreateRequest`](https://libopenstorage.github.io/w/generated-api.html#sdkcredentialcreaterequest).
This struct in protobuf uses [`oneof`](https://developers.google.com/protocol-buffers/docs/proto3#oneof).
Oneof states that _one of these types_ will be used. In SdkCredentialCreateRequest,
only `aws_credential` is set, showing the server which type of credentials
are being registered.

The backup of the volume can now be started with the newly acquired
credential id:

```python
    # Create backup
    backups = api_pb2_grpc.OpenStorageCloudBackupStub(channel)
    backup_resp = backups.Create(api_pb2.SdkCloudBackupCreateRequest(
        volume_id=v_resp.volume_id,
        credential_id=cred_resp.credential_id,
        full=False
    ))
```

This request will not block while the backup is running. Instead you should
call [OpenStorageCloudBackup.Status()](https://libopenstorage.github.io/w/generated-api.html#methodstatus)
to get information about the backup:

```python
    status_resp = backups.Status(api_pb2.SdkCloudBackupStatusRequest(
        volume_id=v_resp.volume_id
    ))
    backup_status = status_resp.statuses[v_resp.volume_id]
    print('Status of the backup is {0}'.format(
        api_pb2.SdkCloudBackupStatusType.Name(backup_status.status)
    ))
```

Lastly, once the backup is complete, we can get a history of this and any
other backups we have created from our volume:

```python
    # Show history
    history = backups.History(api_pb2.SdkCloudBackupHistoryRequest(
        src_volume_id=v_resp.volume_id
    ))
    print('Backup history for volume {0}'.format(v_resp.volume_id))
    for item in history.history_list:
        print('Time:{0} Status:{1}'.format(
            item.timestamp.ToJsonString(),
            api_pb2.SdkCloudBackupStatusType.Name(item.status)
        ))
```

## Example output
Below is an example output run of this tutorial:

```
Conntected to portworx with status STATUS_OK
Volume id is 9b64012f-db53-4a7b-8393-94b3d1ba0b02
Snapshot created with id 26a7262c-3eec-4352-a0be-3710d25f8335
Credential id is 716ed48f-f089-453d-ba07-7072eacd2ba0
Status of the backup is SdkCloudBackupStatusTypeDone
Backup history for volume 9b64012f-db53-4a7b-8393-94b3d1ba0b02
Time:2018-07-18T02:04:53.278579951Z Status:SdkCloudBackupStatusTypeDone
```

## Next
As you can see from the above, working with OpenStorage SDK is quite easy,
fun, and powerful. Please refer to the [API Reference](generated-api.html)
for a complete list of services.