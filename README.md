Public Cloud Info Service
=========================

[Trello Card](https://trello.com/c/ZljyZsnv)

Customers may have their networks configured such that outgoing connections are not possible. However, they do want to allow access to our update servers. Therefore, customers are interested to get the IP addresses of our infrastructure servers to allow traffic to those systems.


Server Design
-------------

API:

```
https://publiccloudinfo.suse.com/VERSION/FRAMEWORK/TYPE/REGION/DATA-TYPE.FMT
```

Where

FRAMEWORK is one of:

amazon, google, hp, microsoft

TYPE is one of:

servers, images

REGION is optional, one of the known regions in the cloud framework, us-east-1
in Amazon for example

DATA-TYPE is one of

smt, regionserver for the servers type

current, deprecated, deleted for the images type


Design decisions for the API
----------------------------

The API flows from generic to specific. The most generic query is for the cloud
framework. More specific is the framework plus either querying server or
image information and so on. When the optional part is omitted we will provide
all information at that level.

For example:

https://susecloudinfo.suse.com/v1/microsoft/servers/us-east/smt.json

Will return information about all of our SMT servers running in this region in
Azure in JSON format

https://susecloudinfo.suse.com/v1/amazon/servers/smt.xml

Will return information about all SMT servers in Amazon in all regions in XML
format.

https://susecloudinfo.suse.com/v1/google/images/deprecated.xml

Will return information about all deprecated images in Google Compute Engine.


Service implementation
----------------------

The service will be implemented using Ruby, Sinatra framework. The data
provided will be driven by XML files, one file per cloud provider. The data
is structured as follows:

```
<framework name="">
  <servers>
    <smt name="" ip="" region=""/>
    <regionserver name="" ip="" region=""/>
  </servers>
  <images>
    <image deletedon="" deprecatedon="" id="" name="" publishedon=""
     region="" replacementid="" replacementname="" state=""/>
  </images>
</framework>
```

The "truth" for this document is in the various cloud frameworks. For Amazon
the tags used as described in the life cycle blog will be used. For Google we
will use the image information provided by the framework. For HP and Microsoft
data will be based on our image naming convention.

The XML file will be generated by a script that queries the various frameworks.
The script runs daily on a VM on our server in Provo.

The information service will return properly formatted XML or JSON data.

Client IOmplementation
---------------------

We will implement a client in Python based on the same ideas used in
ec2metadata and gcemetadata clients. The client will eventually be included in
our guest images.
