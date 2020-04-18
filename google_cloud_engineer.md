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






