# Networking

 - Network:
    - bit rate
	- latency

## Network properties

- Scope: provide services to several applications
- Scalability: operate well on both small & large scale
- Robustness - operate in spite of failures or lost data
- Self-stabilization - return to normal without human intervention
- Autoconfigurability - optimize its params for better performance
- Safety - prevent and contain failures
- Configurability
- Determinism - two networks set up the same should behave identically
- Migration - add new features to the net without disrupting the service


## OSI Reference Model (Open System Interconnection)

1. Application - e.g. ssh
2. Presentation - data representation so that sender and receiver can read write data; describe the syntax of the data
3. Session - dialogue between sender and receiver; muxing/demuxing messages between sender and receiver in case of multiple requests (ftp / http / etc.); rarely used (RPC sometimes), authentication, authorization, session restoration
4. Transport - end-to-end reliable communication stream; deals with lost / duplicate / reordering packets
5. Network - establish connection between sender and receiver; routing / addressing / network congestion / fragmenting data into packets / packets reassembly
6. Data link - transmission and correction of bits; verifying data integrity
7. Physical - physical transmission of signal; cables and such


## TCP/IP Model (Internet Protocol Suite)

1. Application
2. Transport - end-to-end communication over TCP
3. Internet - routing - handled by IP
4. Link (Network Interface) - == data link layer. implemented by device drivers for net interfaces
5. Hardware (Physical)


## TCP - Transport Control Protocol

 - reliable transport
 - Resends message in case of failure. Uses message TTL


## IP

 - defines addressing, routing, etc.
 - ARP - in cases where you don't know all IP's connected to you

### Params

 - Logical Addr: IP
 - Subnet mask: mask to extract the network and subnet from the host's addr
 - Default gateway: the IP of the router which receives the hosts' internet bound packets

Main DNS Servers: ICANN (internet corporation for assigned names and numbers)

### Address classes: ?.A.B.C

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

### Subnetting

Using masks different from 255.

CIDR notation - /x where x is number of bits used for the network id. it can be from 1-31


## Data Link

### Circuit switched
 - old phones - hardware end to end
 - useless if no data is sent

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
 - more lag for continuous transmissions
 - messages may arrive out of order

#### Virtual circuit

a VC is created between source and dest and used for all subsequent sending of packets

Advantages:
 - After 1st message routing is fast
 - Because a connection is created, the connection identifier can be used (alone) to address packets (thus reducing the size of the packet header)
 - Messages do not arrive out of order
 - smaller routing tables
 - packets can be addressed by connection id

Disadvantages:
 - Connections take some time to create
 - Infrequent messaging is not suitable
 - Routing tables will be dynamic and routing algorithms are more complex

### Carrier sensing networks

### Token passing networks


## Physical Layer

Carrier wave modulation: AM, FM, Phase Shift

Modem - transform digital to analog and vice-versa (modulator demodulator)

Time Division Multiplexing / Freq Div Multiplex

Carrier-sense multiple access = verify the absence of traffic before transmitting on a shared medium
CSMA/CD - with collision detection - stop communicating once a collision occurs
CSMA/CA - used by wifi - request to send/ clear to send

FDDI - fiber distributed data interconnect
 - token ring carrier network

ATM - asynchronous transfer mode 
 - uses Virtual circuits
 - atm cells do not pass through routers or network nodes


## Connecting Devices

Layer 1 (physical):
 - Repeater
 - Hub - like repeater but sends data multiple ways

Layer 2 (data link):
 - Switch - every frame received is routed to the correct port (knows where to send based on MACs)
 - Bridge - same as switch but the connected networks do not necessarily have to be of the same type

Layer 2/3:
 - Broadband or Wireless Router
 - Layer 3 Switch

Layer 3 (network):
 - Layer 3 bridge
 - Router

Stuff:
 - Network Interface Card
 - UTP cabling - unshielded twisted pair
 - Hub - every frame received by hub is reproduced on all ports
 - Switch - every frame received is routed to the correct port


## Protocols

 - ICMP - ping
 - ARP - address resolution protocol


## CMD

``traceroute <url>`` if the routers reconfigure over TCP req the results can be inaccurate.
