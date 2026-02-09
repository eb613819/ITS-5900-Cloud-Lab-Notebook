# Deliverable 3A - Industry Talk

## Objective
The purpose of this deliverable is to explore three industry talks related to our current cloud topics. Two are provided by the instructor.

---

## Table of Contents
- [Objective](#objective)
- [Talk 1 - Public Vs. Private Cloud in 2025](#talk-1)
  - [Speakers](#speakers)
  - [Overview](#overview)
  - [Interesting Points](#interesting-points)
  - [Connection to Class](#connection-to-class)
- [Talk 2 - When the Cloud was Born](#talk-2)
  - [Speakers](#speakers2)
  - [Overview](#overview2)
  - [Interesting Points](#points2)
  - [Connection to Class](#connection2)
- [Talk 3 - The Myth of Portability](#talk-3)
  - [Speakers](#speakers3)
  - [Overview](#overview3)
  - [Interesting Points](#points3)
  - [Connection to Class](#connection3)
- [Overall Takeaway](#overall-takeaway)
  
---

<a id="talk-1"></a>
## Talk 1 - Public Vs. Private Cloud in 2025
[Link to talk](https://packetpushers.net/podcasts/day-two-devops/d2do271-public-vs-private-cloud-in-2025/)
### Speakers
**Ned Bellavance** - Day Two DevOps (podcast host)
**Mark Boost** - CEO of Civo (cloud service provider)

### Overview
This talk explores the state of cloud computing in 2025 and compares public and private cloud models. Challenges such as rising cloud costs, vendor lock-in, and lack of interoperability are discussed. The speakers explain why fully abandoning cloud is difficult and often impractical.

### Interesting Points
- Mark Boost references his earlier keynote, **"The Cloud is Broken"**. He explains that cloud pricing has continued to increase, despite the promise of flexibility and cost savings from providers like AWS. This spiraling cost is one of the biggest problems for customers.
- **Cloud pricing should be going down because hardware is getting cheaper.** Ned Bellavance talks about how physical storage has gotten cheaper, so storage in the cloud should too. Mark boost explains that CPUs have far more cores than they used to, so price per physical core is really going down.
- **Vendor lock-in makes leaving the cloud difficult.** Ned Bellavance explains that there is a lack of interoperability between cloud providers. This makes changing providers complicated and costly. Mark Boost agrees and says that it is by design.
- **There is a lack of standards across cloud providers that causes interoperability.** There is work going on towards standardization in Europe.
- **A hybrid or multi-cloud approach may provide a better balance of flexibility, cost control, and performance.**

### Connection to Class
This talk showed why portability, standards,and tools like Terraform or OpenTofu are important for maintaining control over infrastructure and costs. It reinforces the idea that understanding cloud fundamentals matters more than just how to use a single provider's platform.

---

<a id="talk-2"></a>
## Talk 2 - When the Cloud was Born
[Link to talk](https://packetpushers.net/podcasts/day-two-devops/d2c244-when-the-cloud-was-born/)
<a id="speakers2"></a>
### Speakers
**Ned Bellavance** - Day Two DevOps (podcast host)
**Kyler Middleton** - Day Two DevOps (podcast host)
**Eric Chou** - Network Automation Nerds (podcast host), former AWS and Microsoft engineer

<a id="overview2"></a>
### Overview
This talk looks at the early days of cloud computing. Eric Chou's experiences working at AWS, then later at Microsoft working on Azure are explored. The discussion focuses on how AWS started as an internal Amazon project and how it grew to be what it is today.

<a id="points2"></a>
### Interesting Points
- **AWS began as an internal Amazon experiment.** Eric Chou says it was just another service that had "a moonshot project which come into fruition".
- **S3 and EC2 were foundational to cloud growth.** Chou describes S3 as the first true AWS service. He says AWS really took off with the launch of EC2. A bunch of services followed in a "hockey stick" growth.
- **Service oriented architecture enabled AWS to scale.** AWS had decided that everything was going to be service oriented. All communicating services will go through an API call. That mindset allowed them to be what they are today.
- **Early cloud tooling was inconsistent and evolving.** Automation existed, but there was no standard language or toolset.
- **Cloud scale changes infrastructure thinking.** Chou describes how the rapid growth causes cloud providers to design data centers without retrofitting older designs. It's not worth the time to go back and retrofit; rebuilding is often more efficient at scale. 

<a id="connection2"></a>
### Connection to Class
This talk connects to our class discussions on cloud architecture, automation, and infrastructure design. The early use of service-oriented architecture and strict API boundaries at AWS explains why modern cloud platforms are built around automation and infrastructure-as-code. The lack of standardized tooling in the early days highlights why tools like Terraform and OpenTofu are important today. These tools provide consistency and repeatability across complex environments.

---

<a id="talk-3"></a>
## Talk 3 - The Myth of Portability: Why Your Cloud Native App Is Married To Your Provider
[Link to talk](https://www.youtube.com/watch?v=cvv1cVi1n9I)
<a id="speakers3"></a>
### Speakers
**Corey Quinn** - Chief Cloud Economist, The Duckbill Group

<a id="overview3"></a>
### Overview
This talk examines the idea of cloud portability and challenges the assumption that cloud-native applications can easily move between providers. Corey Quinn argues that designing infrastructure around the goal of portability often harms infrastructure quality and adds unnecessary complexity. Despite these efforts, organizations frequently remain locked into a single cloud provider anyway.

<a id="points3"></a>
### Interesting Points
- **Portability is often overvalued.** Quinn argues that designing systems primarily to be portable across cloud providers usually increases complexity without delivering meaningful benefits.
- **Designing for portability can reduce infrastructure quality.** Avoiding provider-specific features often leads to weaker or less efficient architectures.
- **Cloud-native does not mean cloud-agnostic.** Even when applications use containers or Kubernetes, they still depend on provider-specific services such as networking, storage, and identity management.
- **Multi-cloud can create multiple points of failure.** Attempting to “hedge bets” by using multiple cloud providers often increases operational complexity and doubles failure modes rather than improving resilience.
- **Team expertise creates a form of lock-in.** Even if an application is technically portable, organizations remain tied to a provider through their team’s experience with its tools, services, and operational practices.
- **Switching providers often means losing existing expertise.** Moving to a new cloud provider can require teams to abandon expertise and effectively start from scratch. This increases cost and risk.
- **On-prem does not eliminate lock-in.** Moving workloads on-prem only changes the nature of the lock-in, replacing cloud-specific dependencies with hardware, software, and operational constraints.
- **Portability is less important than sustainability.** Quinn emphasizes that the real failure mode is not being unable to switch clouds, but burning out engineers. Infrastructure should be designed to reduce operational burden and allow teams to sleep, not to maximize theoretical portability.

<a id="connection3"></a>
### Connection to Class
This talk contrasts with our class discussions around provider lock-in and portability by arguing that over-optimizing for portability can create more problems than it solves. While we have focused on avoiding vendor lock-in through abstraction and infrastructure-as-code, Quinn highlights the operational and human costs of designing systems that are overly complex in the name of portability. The talk reinforces that tools like Terraform or OpenTofu should be used to improve consistency and maintainability, not to guarantee easy cloud migration. It emphasizes the importance of balancing portability concerns with sustainability, simplicity, and team well-being.

---

## Overall Takeaway
There is a common theme among all three talks: cloud decisions are less about avoiding lock-in entirely and more about managing trade-offs between cost, complexity, portability, and long-term sustainability.
