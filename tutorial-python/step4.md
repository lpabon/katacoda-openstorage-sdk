## Cloud credentials
In this section you will be making a backup of our volume to a cloud provider.
Since you are using the `mock-sdk-server`, all of our cloud provider calls
will be emulated.

First create a set of credentials which will enable the storage system to
save the backup in the cloud.

<pre class="file" data-filename="app.py">

try:
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
except grpc.RpcError as e:
    print('Failed: code={0} msg={1}'.format(e.code(), e.details()))

</pre>

Notice above the [`api_pb2.SdkCredentialCreateRequest`](https://libopenstorage.github.io/w/generated-api.html#sdkcredentialcreaterequest).
This struct in protobuf uses [`oneof`](https://developers.google.com/protocol-buffers/docs/proto3#oneof).
Oneof states that _one of these types_ will be used. In _SdkCredentialCreateRequest_,
only `aws_credential` is set, showing the server which type of credentials
are being registered.

## Creating a backup
The backup of the volume can now be started with the newly acquired credential id:

<pre class="file" data-filename="app.py">

try:
    # Create backup
    backups = api_pb2_grpc.OpenStorageCloudBackupStub(channel)
    backup_resp = backups.Create(api_pb2.SdkCloudBackupCreateRequest(
        volume_id=v_resp.volume_id,
        credential_id=cred_resp.credential_id,
        full=False
    ))

</pre>

This request will not block while the backup is running. Instead you should
call [OpenStorageCloudBackup.Status()](https://libopenstorage.github.io/w/generated-api.html#methodstatus)
to get information about the backup:

<pre class="file" data-filename="app.py">

    status_resp = backups.Status(api_pb2.SdkCloudBackupStatusRequest(
        volume_id=v_resp.volume_id
    ))
    backup_status = status_resp.statuses[v_resp.volume_id]
    print('Status of the backup is {0}'.format(
        api_pb2.SdkCloudBackupStatusType.Name(backup_status.status)
    ))

</pre>

Lastly, once the backup is complete, we can get a history of this and any
other backups we have created from our volume:

<pre class="file" data-filename="app.py">

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
except grpc.RpcError as e:
    print('Failed: code={0} msg={1}'.format(e.code(), e.details()))

</pre>

### Using the client
Let's now run client which will create a new snapshot, credentials, and
backup our volume:

`python app.py`{{execute}}
