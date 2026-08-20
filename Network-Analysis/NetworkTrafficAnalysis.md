# Network Traffic Analysis

Network Traffic Analysis (NTA) is a process that encompasses capturing, inspecting, and analyzing data as it flows in a network. Its goal is to have complete visibility and understand what is communicated inside and outside the network.

# Purpose

Generally, we will use network traffic analysis to:

- Monitor network performance
- Check for abnormalities in the network. E.g., sudden performance peaks, slow network, etc
- Inspect the content of suspicious communication internally and externally. E.g., exfiltration via DNS, download of a malicious ZIP file over HTTP, lateral movement, etc

# From a SOC perspective, network traffic analysis helps:

- Detecting suspicious or malicious activity
- Reconstructing attacks during incident response
- Verifying and validating alerts

Below are more scenarios that illustrate the importance of network traffic analysis :

- Based on the logs for an end-user system, the system began to deviate from its normal behavior around 4 PM UTC. Analyzing the network traffic going to and from this system, we found a suspicious HTTP request and were able to extract a suspicious ZIP-file
- We received an alert that an end-user system is sending many DNS requests in comparison to baseline of the network. After inspecting the DNS requests, we discovered that data was being exfiltrated using a technique called DNS tunneling

# What Network Traffic Can We Observe?

the best way to showcase what traffic we can observe is by using TPC/IP stack

- application
2 thing that we can observe in this stage :
    - Application header information
    - Application data(payloads)

- transport
The application data and header are segmented and encapsulated at the transport layer into smaller pieces. 
each piece inlcude transport header. in most cases TCP and UDP.

    it is valuable to detecting certain types of attack on this layer. example session hijacking.Session hijacking can be detected by analyzing the sequence numbers included in the header. If the sequence numbers are suddenly far apart, further investigation is warranted. The output below shows a series of packets captured with Wireshark. 
    ![alt text](<screenshot/Screenshot 2026-08-03 at 2.42.15 PM.png>)
    - first 3 lines is a normal TCP handshake SYN and ACK.
    - line 4 and 5 is a legitimate data transfer.
    - line 6 shows a packet from another source trying to inject itself into the session. note the massive jump in the sequence number

- internet
When the transport layer sends down a segment, the internet layer also adds its header. If the segment is larger than the Maximum Transmission Unit (MTU), it will be divided into fragments, and a header will be added to each of them. 
one of the attack that happen in this layer is fragmentation attack. For example, an attacker can create tiny fragments to evade the IDS or mess up the reassembly of fragments by using overlapping byte ranges.

- link
Once the internet layer finishes encapsulation, the IP packet is sent to the link layer. The link layer adds its header as well, containing more addressing information. Most logs will display the source and destination MAC addresses. For certain types of attacks, for example, ARP poisoning or spoofing, the information in the logs won't be sufficient. For these types of attacks, we need the full packet and context.

# Network Traffic Sources and Flows
typically has some predetermined network flows and sources. We can group the sources into two categories:
- Intermediary
These are devices through which traffic mostly passes. While they generate some traffic, it is significantly lower than what endpoint devices generate. Under this category, we can find firewalls, switches, web proxies, IDS, IPS, routers, access points, wireless LAN controllers, and many more. Maybe less relevant for us, but all the infrastructure of Internet Service Providers is also considered part of this category.
- Endpoint
These are devices where traffic originates and ends. Endpoint devices take the bulk of the network bandwidth. Devices that fall under this category are servers, hosts, IoT devices, printers, lab machines, cloud resources, mobile phones, tablets, and many more.

The flows we can also group into two categories:
- North-South: Traffic that exits or enters the LAN and passes the firewall.
NS traffic is often monitored closely as it flows from the LAN to the WAN and vice versa. The most well-known services in this category are client-server protocols like HTTPS, DNS, SSH, VPN, SMTP, RDP, and many more. Each of these protocols has two streams: ingress (inbound) and egress (outbound). All of this traffic passes the firewall in one way or another. Configuring firewall rules and logging properly are key to visibility.
- East-West: Traffic that stays within the LAN (including LAN that extends to the cloud). EW traffic stays within the corporate LAN, so it is often monitored less.