compute, storage, big data and machine learning. 


On-demand self-service
On the internet
Provider shares resources to customers
Resources are elastic
Customer pays only for what they reserve/use


Every company will be a data company


IaaS - Infrastructure as a service, pay for what you allocate
PaaS - platform as a service, pay for what u use (uses platform libraries)

Google has it's own network optimizations and serves content from closest node

Regions have Zones. Zones have a single point of failure. 5ms delay in same region. Google is eco-friendly, carbon-neutral.

Multi-region-s have Regions.

GCP bills per second. You get discounts for using more, consistently.



Cloud Bigtable uses same api as Apache HBase
Cloud Dataproc = Hadoop
Google uses open-source a lot: TensowrFlow, K8s, etc.


Data analyst learning track


Server boards & networking are designed by Google.

Custom hardware security chip: Titan, deployed on both servers and peripherals.

Google server machines use cryptographic signatures to make sure they are booting correct software.

Data centers have multiple layers of security, access is limited.

Google services communicate with each other via data-on-the-network ??? which is secured cryptographically. 

The infrastructure automatically encrypts the transit between data centers.

Universan Second Factor, U2F open standard can be used.

Storage has hardware encryption support.

Google Front End is the way in/out and checks incoming connections for security best practices (correct certificates, etc.), protects against DoS attacks via sheer scale + multi-tier, multi-layer protection against DoS. 

To guard against phishing there's U2F. Google gives libraries that help deal with security issues/mistakes.

Google runs a Vulnerability rewards program.


Billing: Google has Budgets and Alerts

Reports: see your costs visually.

Quotas: 

 - Rate quota: 1k requests/100 secs.
 - limit of 5 networks per project



Google Cloud Identity and Access Mgmt = IAM

Projects are used to organize resources you use. Group by common business interests.

Least privilege principle


### Cloud security:

OnPremi: full responsibility.i

Infrastructure as a service: Operations, Acces and Auth, network security, OS data & content, Audit logging, network, storage and encryption, hardware - managed by google

Plaftform as a service: above + identity

Managed services: Web application security + deployment.

Always your responsibility: Usage, Access policies, Content. 


Management can be done via: web-based console, SDK + command line tools, API-s, mobile app

Google provides tools such as IAM to help users handle their security responsibilities (Usage, access policies, content)


### Resource hierarchy

Some resources allow fine grained access control, like storage buckets. 

Resources are grouped into projects where you have another layer of:

 - Resource and quota usage
 - Billing
 - permissions and credentials
 - Services and API-s

Projects have:
 
 - project id - globally unique, chosen by creator, immutable
 - project name - mutable, non-unique, chosen by creator
 - project number - globally unique, assigned by GCP, immutable

Projects can be grouped into folders.

Folders are all under a central organisation node.

IAM policies are inherited.

GSuite comes with a ORG node.

Google Cloud Identity - create ORG node


lower level, less restrictive policy wins


### IAM

Who - can do what - on which resource


Who = google account | google group | service account | entire g-suite domain | cloud identity domain

Permissions are grouped in roles.

Roles: 

 - Primitive - applied to a project and they affect all resources
   - Owner - Invite/remove members, delete projects + Editor+viewer, Has FULL undeniable control over project
   - Editor - Deploy applications, Modify code, Configure services + Viewer
   - Viewer - Read-only
   - Billing administrator - Manage billing, add/remove administrators
 - Predefined - apply to a particular GCP service in a project.
 - Custom - pick permissions into a role. Custom roles can only be used at project or org level, not at Folder level.

Service accounts 

 - to give permissions to applications, not users.
 - is also a resource and can have IAM policies attached to it (e.g. someone can edit, others can view the service acc)
 - a way to allow users to act with service account permissions

### Interacting with GCP


GCP Console - web

 - manage & create projects
 - cloud shell (use the SDK without installing it) (gcloud, gsutil, bq)

Install SDK locally / install SDK via docker image

REST apis - uses OAuth2.0

GCP Console can open/close APIs.


Cloud Client Libraries - community-owned, hand-crafted client libraries

Google api cloud client library - generated code


Cloud Platform Console | Cloud shell & Cloud SDK | Cloud Console Mobile App | REST Api's



### Cloud marketplace, formerly Cloud Launcher

Pre-packaged, ready-to-deploy solutions. Offered by google or 3rd party.

Some come at a cost, (commercially licensed software), they have estimates, they do not estimate networking costs.

GCP updates the base images for the software packages, but it doesn't update it after it has been deployed, you have to maintain them manually.(and you have the access) 


### Getting started 

### Virtual private cloud

Connects all resources and whatnot in a project.


You can: segment the network, use firewall rules, create static routes to fwd traffic to specific dest.

VPC-s have global scope, subnets are regional.

Increasing the size of a subnet in a custom VPC network does not affect the IP addresses of VM's already on that subnet.

VPCs have builtin routing tables and firewall.

Firewall on metadata tags (VMs tagged with "web", and allow https on "web")

Network across projects:

 - VPC Peering.
 - Shared VPC - to share a network/subnets with other projects - more IAM control

#### Cloud Load Balancing:

External traffic goes to a single IP.

Cross-regional load balancing:

 - Global HTTP(S) - layer 7 balancing based on load, can route different URL's to different backends
 - Global SSL Proxy - layer 4 load balancing of non HTTPS SSL traffic based on load - on specific port numbers
 - Global TCP Proxy - layer 4, non-SSL TCP traffic, on specific port numbers
 - Regional - any traffic, any port
 - Regional internal - only inside VPC, used for internal tiers of multi-tier apps


Cloud DNS as a DNS solution. Can be used from gcloud, GCP Console, REST api.

Cloud CDN. Caches resources as close as possible. CDN interconnect for different CDN

Connecting own network to google VPC:

 - VPN - using IPsec. + Cloud Router so that route info is exchanged over VPN using Border Gateway Protocol.
 - Direct peering - via router + point of presence.
 - Carrier peering - if you're not in a google point of presence, google SLA's are not available though
 - Dedicated interconnect - direct private connections to google



 
### Compute engine


Create and run VMs.

Create via GCP Console or gcloud cli tool.

Can run both Linux & Windows.

Can pick: CPU, memory, GPU. Custom or predefined. Can have persistent storage or local storage: Either standard or SSD.

Can give VM's startup scripts and other metadata.

Can take disk snapshots easily and migrate them.

Preemptible VM's:

 - Per-second billing. Sustained use discounts
 - Preemptible instances
 - High throughput to storage at no extra cost
 - Custom machine types

Jobs need to be stoppable and restartable though.

Can scale both up and out.

Autoscaling - add and take away VMs based on load metrics + load balancing accross VMs




### gcloud stuff


```
gcloud compute zones list

gcloud config set compute/zone us-central1-b

gcloud compute instances create "my-bm-2" \
--machine-type "n1-standard-1" \
--image-project "debian-cloud" \
--image "debian-9-stretch-v20190213" \
--subnet "default"
```

```
gsutil mb -l US gs://$DEVSHELL_PROJECT_ID

gsutil cp gs://blahblah blahblah

ls

gsutil cp blahblah gs://$DEVSHELL_PROJECT_ID/blahblah
```

```
gcloud auth list


gcloud config list project

gcloud components install app-engine-python

gcloud app create --project=$DEVSHELL_PROJECT_ID


```





### Storage

Aside from persistent Compute Engine VM storage there are other persistent storage solutions.


#### Object Storage

No file hierarchy, no chunk management. Get object by hash, accessible via HTTP. Does not require capacity management.

Uses buckets, immutable. No edit, only delete/create. Buckets are namespaces. 

Uses HTTPS and is encrypted at rest.

Buckets:

 - globally unique name
 - storage class
 - location: region | multi-region
 - IAM policies | ACLs
 - object versioning setting
 - object lifecycle mgmt rules - delete objects older than x days, created before asd, keep latest 3 versions

Bucket objects:

 - files
 - ACLs


Storage classes:

---              | Multi-regional | Regional | Nearline | Coldline
---              | -------------- | -------- | -------- | --------
Access           | Highly freq    | freq     | <1/month | <1/yr  
Availability SLA | 99.95          | 99.9     | 99       | 99
Use-case         | CDN            | In-region analytics, transcoding | 


Storage price: multi-regional > coldline  per (gb * month)
Retrieval price: multi-regional < coldline per gb of data read

multi-regional = geo-redundant

Storing: Online transfer via cli/ drag&drop. Storage transfer service (scheduled, managed batch transfers), Transfer Appliance (ship data physically)


Other GCP services have access to Cloud Storage as an ingress point.


#### Cloud Bigtable

Can scale to thousands of columns and hold sparsely populated data. Similar to persistent hashtable. Can be looked up with a single key

Same API as HBase

IAM integration. Data encryption in-flight & at rest.

Access patterns: Streaming(Spark storm etc.), Batch processing(Hadoop), Application API.


#### Cloud SQL managed service

CloudSQL can replicate data with auto failover. Has backups on-demand or scheduled. Can scale up (rw) and horizontally(r)
Is accessible by other GCP services via standard drivers.


#### Cloud spanner

Transactions, consistency, managaed instances with HA. SQL queries (ANSI 2011 w/ extensions), automatic replication.

Sharding style.


#### Cloud datastore

Sharding & replication & scalability automagically.

Has transactions, unlike bigtable. Has SQL-like api. Uses structured data.

Available across App engine and Compute Engine as well as the other platforms.


#### Comparison

Cloud datastore: structured data. Has transactions. No complex queries. TB+. 1MB/entity (unit size)

Bigtable: wide column, single row transaction. no complex queries. PB+. 10MB/cell, 100MB/row. Query only by hashcode

Cloud Storage: blob store. 

Cloud SQL: Relational. Managed service on top of PostgreSQL / MySQL. OLTP

Cloud Spanner: Relational. Transactions + complex queries. PB. 10.240MiB/row. OLTP

BigQuery: Relational. Complex queries. No transactions. PB+. 10MB/row. Typical OLAP


### K8s engine

IaaS - run system on hw. Access hw resources directly.

PaaS - use services. Deploy code using services.

You give up control of server architecture.

Container is combo between both??? supposedly.

Lose control over OS and HW for easier scalability.


Cloud Build vs Docker.


Google Anthos - on-prem + multi-cloud + hybrid cloud env


GKE on-prme uses same MarketPlace, Stackdriver as Google K8s Engine

Isio Service Mesh from On-Prem si synced via Cloud Interconnect with Anthos Service Mesh


Policy Repository (located either on-prem or in the cloud) is a git repo from which both on-prem and cloud 
Anthos Config Management instances take sync policies and sync the local k8s (cloud/on-prem)

LoadBalancer is a service that maps a router from Compute Engine and infrastructure to a deployment(and others?).
It is a physical router coupled with logical routing.


### App Engine


PaaS

Standard env:

 - free daily quota
 - autoscale workloads
 - usage based pricing

SDK's for several langs

Runtime provided by google: Java, Python, PHP & Go

Code is sandboxed:

 - No writing to local files
 - Requests timeout at 60s
 - Limits on 3rd party software
 - instance startup in milliseconds
 - network access is via App Engine services
 - After free daily use pay per instance class with automatic shutdown

Access to services: memcache, task queues, scheduled tasks, search, logs, etc.


Flexible env:

 - can specify container you run your code in
 - can choose geographical region
 - ssh access(not by default)
 - instance startup in minutes
 - can write to disk (ephemeral)
 - has support for 3rd party binaries
 - has network access
 - pay for resource allocation per hour
 - no automatic shutdown

Google Cloud Endpoints & Apigee Edge

 - Auth0 (OIDC + OAuth2.0)
 - supported over App Engine Flexible Environment, K8s engine, Compute Engine, with clients in Android, iOS, js???

apigee - rate limiting on API's, analytics, monetization, etc. 


#### Others

Google Cloud Sources


Deployment Manager 

 - uses .yaml or python to describe the environment 
 - e.g. create a Compute Engine VM instance
 - `gcloud deployment-manager` etc. 

### Google Cloud BigData platform

Serverless - you don't have to provision compute engine instances, services are fully mangaged, pay as you use

#### Cloud dataproc

Managed Hadoop, MapReduce, Spark, Pig, Hive

Can scale up/down on the run

Save money with preemptible compute engine instances(~80% cheaper)

1 minute billing intervals

#### Cloud dataflow

Stream + Batch processing

Automated scaling, no instance provision required

ETL, batch & streaming.

Integrated with GCP services (Cloud Storage, Pub/Sub, BigQuery, BigTable)

Open source Java & Python sdk.

#### BigQuery

Ad-hoc SQL(2011) query on petabyte of data. Pay as you go.

Has free monthly quotas for smaller orgs.

Can specify the region in which you store your dataset, you don't need to setup a cluster there.

Storage and queries are paid separately. Queries only when they are running. 

Can share datasets, query cost is paid by project that queries, not owner of data.

After 90 days of storage Google drops storage price.


#### Cloud Pub/Sub

At least once.

#### Cloud Datalab

Jupyter notebook. Google Charts and matplotlibi. Pay for used resources.


### ML Cloud Machine learning platform

TensorFlow + Tensor Processing Units (TPU) = love

Structured vs unstructured data.


#### Cloud vision API

Extract text, Detect inappropriate content, analyze sentiment, gain insight from imgs, etc.


#### Cloud Natural Language API

80 langs, STT. Entity recognition - identify events, people, products, etc.

#### Cloud Translate API

#### Cloud Video Intelligence

Annotate contents, detect scene changes, flag inappropriate content.

### Review

Compute engine - General computing workloads, IaaS

K8s engine - Container based workloads, Hybrid

App Engine Flex - Web and mobile applications, container based workloads

App Engine Standard - Web & mobile apps

Cloud functions - Ephemeral functions


# Essential Google Cloud Infrastructure: Foundation


Cloud Shell = temporary VM with 5GB of persistent storage


can add variables to env by adding them to `.profile`: e.g. `source configs/myconfigs` at the end of `.profile`


### VPC network types


#### Default

Every project has it. One subnet per region. Default firewall rules

#### Auto Mode

Default network is auto-mode. One subnet per region. Regional IP allocation. Fixed /20 subnet per region, expandable to /16

#### Custom mode

Auto-mode can be transformed to custom, but not vice-versa. Full control over IP ranges, Regional IP allocation, no default subnets created.

--- 

Networks are global.

Cross network traffic can be done via internet, but hits google's edge routers, so it doesn't leave google necessarily.

Subnetworks are at a regional scale only.


New subnets cannot overlap with other subnets. (duh)

Can expand but not shrink.

Avoid large subnets. Overly large networks can cause collisions when peering etc.


2 IP's:

Internal: 

 - allocated from subnet range to VMs by DHCP. 
 - DHCP lease renewed every 24h. 
 - VM name + IP is registered with network-scoped DNS

External:

 - assigned from poop (ephemeral)
 - reserved (static) and billed more when not attached to a running VM


External IP's are mapped to the internal IP's via VPC.

Each instance has a hostname, same as instance name, that can be resolved to the internal ip address.

FQDN is [hostname].[zone].c.[project-id].internal

Name resolution done by internal DNS resolver:

 - provided as part of Compute Engine (169.254.169.254)
 - configured with DHCP (delete -> recreate => new internal IP address)
 - has a LUT that matches internal IP addresses with external IP addresses.


Instances with external IP addresses can allow connections from hosts outside the project. Users can connect directly via IP address.
Admins can publish DNS records pointing to the instance. Public DNS records are not published automatically.


DNS records for external addresses can be published using other DNS servers or Cloud DNS.

Cloud dns - G100% SLA. Manage via UI, cli, API.

Alias IP ranges: VM has an IP, container in VM has another, sth along these lines TODO



