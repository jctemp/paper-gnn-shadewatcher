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

To further stress this thought, we have picked two papers #cite("strgnn-2021","tbdfs-2022") that discuss the aspect of including temporal and structural information.
In general, the motivation is that attacks have a structural pattern creating a specific topology in the PG #cite("shadewatcher-2022", "threatrace-2022", "unicorn-2020", "strgnn-2021", "prov-gem-2021").
Furthermore, one constructs PG based on audit data that contains temporal information, which can reveal new insights @strgnn-2021.

The first paper @strgnn-2021 presents the so-called `StrGNN` model.
It is a temporal graph neural network that aims to detect anomalies based on the graph structure.
The idea is to extract subgraphs for representational learning, not needing the complete graph in memory.
Using the subgraphs, a GNN extracts structural features.
Finally, it employs gated recurrent units (GRU) for temporal information.
The authors provided an example of intrusion detection with promising results.
Incorporating temporal information for `ShadeWatcher` could further improve prediction.
Hence, using GAT @gat-2018 has the potential to help with this task.

The second paper @tbdfs-2022 is more concerned with the marriage of BFS and DFS.
They utilise two attention-based aggregations for BFS and DFS, where the contribution is controlled with an interpolating factor.
Additionally, they stressed an exciting idea: distinguish between what neighbours propagate (BFS) and where information is coming from (DFS).
Accordingly, leveraging information revealed through DFS can enhance predictions because a path represents the information flow.
Relating this to `ShadeWatcher`, we assume that the collaborative filtering signal is not the driving factor.
We expect that DFS in the preprocessing is the crucial step showing the information flow between entities, e.g. the sensitive file and public socket.
Furthermore, incorporating a temporal encoding refines information regarding information flow due to the encoded time dependency.
Consequentially, a GNN using this additional information can provide finer predictions.

Despite the listed ideas, we recommend investigating the influence of `TransR` because there is also the possibility that this step prepared the information signal in a way that allows the GNN to accelerate unexpectedly.
If this was clarified, follow-up work could plan the direction of research, e.g. replace or remove `TransR` and modify the GNN accordingly, as well as minimise preprocessing.

Another issue of `ShadeWatcher`, acknowledged by the authors, is that the model requires retraining the complete model for unseen data.
It is caused by the transductive model `TransR` #cite("link-prediction-article-2017", "inductive-link-prediction-2022").
Not only that, retraining is potentially expensive @inductive-link-prediction-2017, especially for high dimensions, significantly impacting runtime @link-prediction-article-2017.
Still, one can use `ShadeWatcher` for graphs that do not change their set of nodes, allowing employment in offline scenarios.
However, one has to investigate the usability of `ShadeWatcher` for large IT systems. 

Next, we want to review the used attention mechanism.
The attention is computed based on the `TransR` embeddings; however, it does not seem reasonable to introduce additional dependencies to another model, although the traditional (multi-head) attention has been proven to yield state-of-the-art predictions #cite("gat-2018", "transformer-2017").
Further, considering the replacement of `TransR` in the future would make it necessary to revise the attention.

Another aspect the authors of `ShadeWatcher` discussed is data contamination.
If the training data contains malicious behaviour, it is more likely that an anomaly-based detector will not correctly identify such type of behaviour.
The author performed measurements showing a tendency that `ShadeWatcher` is robust towards this problem.
Nonetheless, real-world usage is necessary to examine the robustness thoroughly.

Finally, specialists have to investigate the problem of adversarial attacks on GNNs.
An attacker aware of the detection system could manipulate the KG to disguise malicious behaviour.
Our concern is not only applicable to `ShadeWatcher` but also to other machine learning methods.

Besides the critique above, we are convinced that `ShadeWatcher` has an attractive approach to threat detection.
Further exploration in this direction seems promising.
Moreover, refining the `ShadeWatcher` to overcome the previously expressed concerns is necessary to make it usable for real-world usage.
