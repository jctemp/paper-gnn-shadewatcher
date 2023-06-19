= Introduction <sec-introduction>

`ShadeWatcher` #cite("shadewatcher-2022", "shadewatcher-source-2022") is a recommendation-guided cyber threat analysis detector.
It is a novel approach to detect advanced persistent threats (APT), combining the concept of provenance, graph neural networks and recommendation systems.
The goal of this paper is to present `ShadeWatcher`.
We aim to provide a comprehensive overview and clarify the approach.

== Motivation <sec-motivation>

In recent years, APTs emerge as a new class of cyber threats, becoming increasingly common #cite("apt-2014", "apt-2019").
The problem with APTs is that they use various techniques to breach a system, which can extend over a long period.
Hence, detection is challenging.

Traditional methods of detection are not sufficient, as APTs have been known to bypass detection despite efforts to identify them #cite("shadewatcher-2022","threatrace-2022","unicorn-2020"). 
As a result, a new approach, provenance-based anomaly detection, has been proposed, capable of detecting APTs @unicorn-2020. 
This technique takes a more comprehensive approach to monitoring system activity and can detect suspicious behaviour that may indicate an APT, leveraging systems provenance and machine learning.

== Approach <sec-approach>

`ShadeWatcher` uses two aspects to detect malicious behaviour in an IT system: provenance graphs and graph neural networks.
We can see this in @fig-sw-example.
The illustration shows the architecture of `ShadeWatcher` with the required steps to make a prediction.
The first step is to collect provenance data from the system.
After collecting the data, it is utilised to create the provenance and the context graph.
These two yield together the knowledge graph, being the input to `TransR` @transr-2015 and the graph neural network @graph-convolutional-network-2016.
Both models compute various embeddings, which are then used to give a recommendation.

#figure(
    image("../figures/shadewatcher-illustrations-arch-vertical.drawio.png", alt: "Constructed example to illustrate provenance."),
    caption: [The figure displays the `ShadeWatcher` architecture (adapted and modified @kgat-2019).]
) <fig-sw-example>


== Overview <sec-overview>

The paper is structured as follows.
We start with a brief overview of the related work in @sec-related-work, discussing other approaches to detect APTs.
In @sec-concepts, we will cover the used concepts by `ShadeWatcher`, explaining the parts seen in @fig-sw-example in more detail.
@sec-recommendation is about the recommendation process.
Finally, we have a short discussion in @sec-discussion.
