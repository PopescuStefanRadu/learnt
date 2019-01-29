Network properites:

 - scope: provide services to several apps
 - scalability: operate well on both small & large scale
 - Robustness: operate in spite of failures or lost data
 - Self-stabilization: recover from failure without human intervention
 - Autoconfigurability: self-optimizing
 - Safety: Prevent failures and contain failures from affecting other parts of the network
 - Configurability
 - Determinism: 2 network with identical conditions should yield identical results
 - Migration: add new features without disrupting the network service


## TCP

Resends message in case of failure. Uses message TTL


## IP
Logical Addr: IP
Subnet mask: mask to extract the network and subnet from the host's addr
Default Gateway: IP of router

Main DNS Servers: ICANN (internet corporation for assigned names and numbers)


## OSI (Open system interconnection)

1. Application 
2. Presentation
  - data representation so that sender and receiver can read write data
3. Session
  - dialogue betwen sender and receiver
  - muxing/demuxing messages between sender and receiver in case of multiple requests (ftp / http / etc.)
4. Transport
  - end-to-end reliable connection stream
  - deals with lost / duplicate / reordering packets
5. Network
  - Establish connection between sender and receiver
  - routing / addressing / network congestion / fragmenting data into packets / packets reassembly
6. Data link
  - transmission of groups of bits
  - verifying data integrity
    - Circuit-switched (telephone) = end-to-end comm
      - useless is no data is sent
    - Packet-switched  = data divided into packets which each needs to be routed
      - slower since each router needs to decide next hop for every packet
      - Virtual circuit switching 
        - establishing a persistent connection
        - messages are in order
        - once connection is established routing is faster
        - smaller routing tables
        - packets can be addressed by connection id
      - Datagram
        - each packet is routed individually
7. Physical
  - cables and such

## TCP/IP model

1. Application
2. Transport
  - end-to-end communication over TCP
3. Internet
  - routing - handled by IP
4. Network Interface
  - == data link layer. implemented by device drivers for net interfaces
5. Hardware
  - physical layer


Protocols:

  - ICMP - ping
  - ARP - address resolution protocol


CMD:

``traceroute <url>`` if the routers reconfigure over TCP req the results can be inaccuratie.

Stuff:

 - Network Interface Card
 - UTP cabling - unshielded twisted pair
 - Hub - every frame received by hub is reproduced on all ports
 - Switch - every frame received is routed to the correct port


Physical layer:

Carrier wave modulation: AM, FM, Phase Shift

Modem - transform digital to analog and vice-versa (modulator demodulator)

Time Division Multiplexing / Freq Div Multiplex

Carrier-sense multiple access = verify the absence of traffice before transmitting on a shared medium
CSMA/CD - with collision detection - stop communicating once a collision occurs
CSMA/CA - used by wifi - request to send/ clear to send


FDDI - fiber distributed data interconnect
 - token ring carrier network

ATM - asynchronous transfer mode 
 - uses Virtual circuits
 - atm cells do not pass through routers or network nodes




