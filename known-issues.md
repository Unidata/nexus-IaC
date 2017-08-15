# Known Issues

## OpenStack

### Missing artifacts when Cinder volume with existing app data is attached to fresh instance

To demonstrate issue:

1. Run test.yml playbook against OpenStack VM in order to "seed" it with some example artifacts.
1. Destroy the VM in Horizon but NOT the Cinder volume. It's probably best to do a graceful shutdown,
but this problem manifests regardless.
1. Create a new VM and attach the existing volume to it.
1. Notice that while most of our seed artifacts are present, some are not. Specifically, `unit-utils-1.0.0-SNAPSHOT`
is missing from the maven-snapshots repo.

Oddly, while not visible in the Nexus GUI, it appears in the blob store:
```
ubuntu@nexus-instance:/data/nexus/blobs$ grep -r unit-utils .
./default/content/vol-16/chap-30/a3d6a684-35d4-4d65-9e31-a4c3c9b745e8.properties:@BlobStore.blob-name=edu/ucar/unit-utils/1.0.0-SNAPSHOT/unit-utils-1.0.0-20170815.051917-1.pom
./default/content/vol-16/chap-30/a3d6a684-35d4-4d65-9e31-a4c3c9b745e8.bytes:  <artifactId>unit-utils</artifactId>
./default/content/vol-20/chap-47/5a401362-49e1-4b01-8e4b-ba39b2d81edd.properties:@BlobStore.blob-name=edu/ucar/unit-utils/1.0.0-SNAPSHOT/maven-metadata.xml.sha1
./default/content/vol-20/chap-05/c1725d72-a415-470b-b93c-a52a2bbf5995.properties:@BlobStore.blob-name=edu/ucar/unit-utils/1.0.0-SNAPSHOT/unit-utils-1.0.0-20170815.051917-1.pom.md5
./default/content/vol-04/chap-27/65ac5e25-452f-4cc5-b725-d51ade2bd207.properties:@BlobStore.blob-name=edu/ucar/unit-utils/1.0.0-SNAPSHOT/maven-metadata.xml.md5
...
```
```
ubuntu@nexus-instance:/data/nexus/db$ grep -r unit-utils .
Binary file ./component/component_4.pcl matches
Binary file ./component/asset_5.pcl matches
Binary file ./component/assetdownloadcount_1.pcl matches
Binary file ./component/assetdownloadcount_2.pcl matches
...
```
Should we not expect Nexus to work properly in this instance? We should probably ask the devs.
