= Discussion <sec-discussion>

- What are the benefits?
- How useful is the concept?
- How well does recommendation fit threat detection?

Authors of `ShadeWatcher` explained that the current version does not support working on unseen data.
Accordingly, a retraining of the complete model is required if the underlying system changes.
Only using the offline approach is unreasonable for large IT systems.
\
Provenance graph undergoes preprocess (discovery of entity context graph).
Therefore, it would make sense to use a technique that considers
+ combines DFS and BFS
+ works on dynamic graphs
+ considers temporal changes
@tbdfs-2022
strgnn-2021
\
There is no evaluation possible as the scores cannot be compared to other techniques.
Demand analysis of techniques.
Still, at first glance the concept is promising giving a tendency for potential real world usage.
\
TranR is an inductive approach @inductive-link-prediction-2022, might be useful to consider inductive learning.
Besides retraining for unseen data is potentially expensive @inductive-link-prediction-2017, for that consider larger numbers for dimensions and its effect on runtime @link-prediction-article-2017.
Neighbourhood information is captured three times (Context entity graph, TransR, GNN); Questional in the first place.
\
Attention utilises TranR embeddings; why not using traditional (multi-head) attention seen in GAT.
Removes requirement for TransR (initialisation of GNN can happen with One-Hot).
\
`ShadeWatcher` briefly discussed data contamination.
They suggested that their model shows the tendency of robust behaviour.
Requires confirmation in a real world environment.
\
Attacker can perform adversarial attack on GNN by manipulating KG.
In general important for ML-based techniques with that the approaches to mitigate the risk.
\
Long-term monitoring of system behaviour is troublesome (concept drift)
Current state does not mitigate that.
\
Coining recommendation to threat detection is an intresting concept.
More exploration in the direction seems promising.
Requires to overcome transductive setting.