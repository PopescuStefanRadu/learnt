# Just faculty networking course notes

 - Network:
    - bit rate
	- latency

## Network properties

- Scope: provide services to several applications
- Scalability
- Robustness - operate in spite of failures or lost data
- Self-stabilization - return to normal without human intervention
- Autoconfigurability - optimize its params for better performance
- Safety - prevent and contain failures
- Configurability
- Determinism - two networks set up the same should behave identically
- Migration - add new features to the net without disrupting the service

Osi Reference model:

1. Application - e.g. ssh
2. Presentation - describe the syntax of the data
3. Session - rarely used, (RPC sometimes), authentication, authorization, session restoration
4. Transport - end-to-end reliable communication stream
5. Network - handles the connections between senders and receivers, packets, congestion, etc.
6. Data link - transmission and correction of bits
7. Physical - physical transimission of signal

Internet Protocol suite:

1. Application layer
2. Transport layer
3. Internet layer
4. Link layer

## TCP - transport control protocol

 - reliable transport

## IP

 - defines addressing, routing, etc.
 - ARP - in cases where you don't know all IP's connected to you
 
### Params

 - subnet mask. Mask used to extract network and subnet from the host address.
 - default gateway: the IP of the router which receives the hosts' internet bound packets

#### Address classes: ?.A.B.C

Class A:

0 | 1-7 | 8 - 31
- | --- | ------
0 | net | host

Class B:

0 | 1 | 2-15 | 16 - 31
- | - | ---- | -------
1	0 | net  |   host

Class C:

0 | 1 | 2 | 3 - 23 | 24 - 31
- | - | - | ------ | -------
1 | 1 | 0 |   net  |   host

Class D: 1110, 4-31 - multicast group address

Class E: 11110, 5-31 - reserved for future use

0.0.0.0 no assigned IP

0.0.0.hostId - send messages to some machine on this net

255.255.255.255 - send broadcast message on this net

127.0.0.1 - loopback

#### Subnetting

Using masks different from 255.

CIDR notation - /x where x is number of bits used for the network id. it can be from 1-31




## Data Link

### Ciruit switched
 - old phones - hardware end to end
### Packet switched
 
 - data is divided in packets and routing is done by routers/switches
 - types: 
   - datagram - each packet is routed individually
   - virtual circuit 

#### Datagram

datagram - each packet is routed individually

Advantages:
 - connections don't have to be created
 - infrequent messaging is not costly
 - routing each message separately makes load balancing very easy

Disadvantages:
 - more lag for continous transimissions
 - messages may arrive out of order

 
#### Virtual circuit

a VC is created between source and dest and used for all subsequent sending of packets

Advantages:
 - After 1st message routing is fast
 - Because a connection is created, the connection identifier can be used (alone) to address packets (thus reducing the size of the packet header)
 - Messages do not arrive out of order
 
Disadvantages:
 - Connections take some time to create
 - Infrequent messaging is not suitable
 - Routing tables will be dynamic and routing algorithms are more complex
 
### Carrier sensing networks

### Token passing networks

## Connecting devices

Layer 1 (physical):
 - Repeater
 - Hub - like repeater but sends data multiple ways

Layer 2 (data link):
 - Same purpose as HUB but it knows where to send the data based on MACs
 - Bridge - same as switch but the connected networks do not necessarily have to be of the same type
 
Layer 2/3:
 - Broadband or Wireless Router
 - Layer 3 Switch

Layer 3(network):
 - Layer 3 bridge
 - Router

 La