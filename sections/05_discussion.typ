= Discussion <sec-discussion>

In this section, we want to discuss `ShadeWatcher`'s abilities.
We want to pick up on some aspects the authors @shadewatcher-2022 mentioned and our thoughts.
Note that this discussion will not cover the performance of `ShadeWatcher` because there is no comparison available to make an evaluation.
For an evaluation, one has to conduct additional work measuring various techniques (e.g. `Unicorn` @unicorn-2020 and `ThreaTrace` @threatrace-2022).

We have noticed that the provenance graph is used in multiple processing steps to extract semantic information about system entities.
The extra processing steps result in additional used computational resources for graph construction, training and inference (`TransR` and GNN).
Thus, the question at hand is, is there a possibility to remove the multiple processing steps, allowing the machine learning model to extract the semantic information directly?
Consequentially, it is necessary to explore concepts considering breadth-first search (BFS) through neighbour aggregation and depth-first search (DFS) for graph exploration (similar to `node2vec` @node2vec-2016).
Furthermore, the provenance of a system is constantly changing.
Considering this change can be valuable to have improved inference.
Therefore, we propose to consider the following two aspects:
- Combining DFS and BFS.
- Allow temporal stability for a dynamic provenance graph.
Hence, research is required to incorporate the concepts potentially.
We have found two other papers #cite("strgnn-2021","tbdfs-2022") already exploring the problem that covers structural temporal learning as well as GNNs that consider BFS and DFS.

#text(fill: red)[
    Elaborate how the two models StrGNN and TBDFS can be used to improve the ShadeWatcher model.
]

Another issue of `ShadeWatcher`, acknowledged by the authors, is that the model requires retraining the complete model for unseen data.
It is caused by the transductive model `TransR` #cite("link-prediction-article-2017", "inductive-link-prediction-2022").
Not only that, retraining is potentially expensive @inductive-link-prediction-2017, especially for high dimensions, significantly impacting runtime @link-prediction-article-2017.
Still, one can use `ShadeWatcher` for graphs that do not change their set of nodes, allowing employment in offline scenarios.
However, one has to investigate the usability of `ShadeWatcher` for large IT systems. 

Next, we want to review the used attention mechanism.
The attention are computed based on the `TransR` embeddings; however, it does not seem reasonable to introduce additional dependencies to another model, although the traditional (multi-head) attention have been proven to improve predictions @gat-2018.
Further, considering the replace of `TransR` in the future would make it necessary to revise the attention.

Another aspect the authors of `ShadeWatcher` discussed is data contamination.
If the training data contains malicious behaviour, it is more likely that an anomaly detection-based detector will not correctly identify such type of behaviour.
The author performed measurements showing a tendency that `ShadeWatcher` is robust towards this problem.
Nonetheless, real-world usage is necessary to examine the robustness thoroughly.

Finally, specialists have to investigate the problem of adversarial attacks on GNNs.
An attacker aware of the detection system could manipulate the KG to disguise malicious behaviour.
Our concern is not only applicable to `ShadeWatcher` but also to other machine learning methods.

Besides the critique above, we are convinced that `ShadeWatcher` has an attractive approach to threat detection.
Further exploration in this direction seems promising.
Moreover, refining the `ShadeWatcher` to overcome the previously expressed concerns is necessary to make it usable for real-world usage.
