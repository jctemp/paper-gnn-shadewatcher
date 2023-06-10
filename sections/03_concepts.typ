#show math.equation: set text(size: 8.5pt)
#set math.equation(numbering: "(1)")

= Concepts <sec-concepts>

In this section, we will discuss the various concepts that enable `ShadeWatcher` to predict malicious and benign behaviour of system entities.
We will cover the following topics: graph theory, recommender systems, provenance graphs, context awareness, knowledge graphs, translational embeddings, and graph neural networks.

== Graph theory <sec-graph-theory>

In mathematics, a graph (@eq-graph) is defined as a tuple consisting of nodes ($cal(V)$) and edges ($cal(E)$), which together describe the structure of the graph. 
Each edge tuple connects two nodes that are part of the set of nodes.
The connection can be uni- or bidirectional as directed (set) or undirected (tuple).

$
cal(G) &= (cal(V), cal(E)) \
cal(E) &= {(h, t) : h,t in cal(V)}
$ <eq-graph>

Graphs have the necessary properties to work with complex data.
They allow for various topological structures while capturing information in an arbitrary form.
Hence, one has the opportunity to model complex relationships across different data domains, and it is natural to visualise, explore, interact and search in #cite("knowledge-graphs-2022", "knowledge-graph-science-2018").
Additionally, graphs can handle incomplete and degenerated data, which is essential as data can occur sparsely, resulting in many empty fields regarding classic table-like structures @sparsity-problem-2004.
Further, one can incorporate additional information by assigning attributes to nodes and edges.

ShadeWatcher @shadewatcher-2022 utilises the graph structure extensively across all upcoming sections.
It leverages the fact that it can encode structured information efficiently and exploits it to gain valuable information about the data.


== Recommender systems <sec-recommender-systems>

Recommender systems are methods that one typically uses in user-item relationship scenarios @recommendation-2021.
It analyses the user-item interactions using approaches like collaborative filtering.
The method can make personalised recommendations to users based on the gained information through a selected approach.

We can express the idea as a $k$-partite graph, where $k$ denotes the number of disjoint sets.
For example, a bipartite graph (@eq-graph-bipartite) represents user-items interactions where we have two sets: users ($cal(U)$) and items ($cal(I)$).

$
cal(G) &= (cal(V), cal(E)) \
cal(E) &= {{u, i} : u in cal(U),i in cal(I)} \
cal(V) &= cal(U) union cal(I) : cal(U) sect cal(I) = nothing
$ <eq-graph-bipartite>

Literature #cite("sparsity-problem-2004", "recommendation-2021", "kgat-2019") elaborates on challenges like incomplete connections and the amount of data that is needed to be analysed.
Research aimed to improve collaborative filtering for these challenges.
However, it still needs more performance and explainability in some cases, e.g. e-commerce  @collaborative-filtering-2018.
Further, one aims to improve recommendations by accommodating more information, e.g., partitioning and side information, to discover high-order connections #cite("kgat-2019", "collaborative-filtering-2018").

The ShadeWatcher authors adopted the recommendation approach for threat detection and effectively applied the concept described in @kgat-2019.
Accordingly, the following sections will reveal the connection between threat analysis and recommendation.

== Provenance graph <sec-provenance-graph>

// (formal definiton, structure, properties, related use case)
System provenance is essential for computer forensics as it describes entities (process, files and sockets) in a computer system with metadata @trustworthy-provenance-2015.
The metadata, also called audit data, is gathered during the execution of a system and provides valuable insights into an entity's interaction history, allowing specialists to comprehend and reason about the system's current state.
Furthermore, one can derive a provenance graph (PG) commonly accepted as a directed acyclic graph @trustworthy-provenance-2015.
Accordingly, we can define the PG (@eq-graph-provenance) as a set of system entities representing nodes ($h,t in cal(V)$) and a set of interactions between the entities representing edges ($cal(E)$).
In addition, we add a label ($r_"ht" in cal(R)$) to the edges representing a relation type.

$
cal(G)_P &= (cal(V), cal(E)) \
cal(V) &= {italic("process, file, socket")} \
cal(E) &= {(h, r_"ht" , t) : h, t in cal(V) : r_"ht" in cal(R)} \
cal(R) &= {italic("clone, fork, read, write, ...")}
$ <eq-graph-provenance>

We want to include an example (@fig-audit-data) of audit data in `JSON` format for completeness.
The audit data has various information about the performed action.
More specifically, a process with the PID `18113` successfully reads `105` bytes of a file with the file descriptor `98`.

#figure(
  align(left)[
  ```json
  {
      "@timestamp": "2020-10-31T14:14:47.785Z",
      "user": {
          // ...
      },
      "process": {
          "pid": "18113",
          "ppid": "18112",
          // ...
      },
      "auditd": {
          "sequence": 166817,
          "result": "success",
          "session": "705",
          "data": {
              // ...
              "syscall": "read",
              // fd in hex => 98 in dec
              "a0": "b",        
              // amount of read bytes
              "exit": "105",
              // ...
          }
      }
  }
  ```],
  caption: [The figure presents a single audit record of a Linux system @shadewatcher-source-2022.],
) <fig-audit-data>

Considering a secure collection process of the audit data, it is feasible to gather all system entities, having a complete representation of a system's history.
The authors @trustworthy-provenance-2015 introduced this as whole-systems provenance showing the interaction of agents, processes and data types.
Provenance collection is available on the three major operating systems (OS): Linux, MacOS and Windows @provenance-auditing-2012.
Note that it is feasible on other OS derivatives; however, we cannot provide any reference.
Regardless, this paper will focus on Linux-based systems as the ShadeWatcher authors only considered Linux because it supports capturing provenance on a system-call level.

ShadeWatcher utilises the PG as a foundation for the knowledge graph.
Furthermore, the authors perform additional analysis on the PG to enrich the knowledge graph with crucial information about entity relations.

To clarify the concept of PG, we will provide an illustrative example explained in @provenance-aware-2006. 
We constructed a theoretical illustration (@fig-pg-example) based on the scenario described.

#figure(
    image("../figures/provenance-example.drawio.png", alt: "Constructed example to illustrate provenance."),
    caption: [The figure displays a theoretical provenance graph (own illustration).]
) <fig-pg-example>

Imagine a user with an alias for the `rm` command that moves deleted files to a folder containing the deleted files.
An attacker successfully infiltrated the user's system and replaced this specific folder with a symbolic link to a location accessible to the attacker.
Accordingly, deleting a sensitive file would move it to a location where the attacker can perform further disguising actions.

By utilising provenance data, one can systematically analyse the changed state in the system and recognise that sensitive information is moved to an odd location (e.g. sockets) which is suspicious and an indicator of malicious behaviour.

== Context awareness <sec-context-awareness>

$
cal(G)_C &= (cal(V), cal(E)) \
cal(E) &= {(h, r_"ht" , t) : h,t in cal(V) : r_"ht" in {0,1}} \
cal(V) &= cal(D) union cal(S)  : cal(D) sect cal(S) = nothing \
cal(D) &= {italic("file, socket, ...")} \
cal(S) &= {italic("process, ...")} \
$ <eq-graph-context>

#figure(
    image("../figures/provenance-context.drawio.png", alt: "Constructed example to illustrate provenance."),
    caption: [The figure displays a theoretical provenance graph (own illustration).]
) <fig-pg-context>

== Knowledge graph <sec-knowledge-graph>

$
cal(G)_K &= cal(G)_P union cal(G)_C
$ <eq-graph-knowledge>

== Translational embeddings <sec-translational-embeddings>

$
(h,r,t) : bold(e)_h, bold(e)_t in RR^k and bold(e)_r in RR^d
$ <eq-transr-embeddings>

$
bold(M_r) in RR^(k times d)
$ <eq-tranr-projection-matrix>

$
bold(e)_h^r = bold(e)_h bold(M)_r and bold(e)_t^r = bold(e)_t bold(M)_r\ 
f(h,r,t) = || bold(bold(e)_h^r + bold(e)_r - bold(e)_t^r) ||
$ <eq-tranr-measure>

$
cal(L)_"first" &= sum_((h,r,t) in cal(G)_K) sum_((h',r,t') in.not cal(G)_K) sigma(f(h,r,t) - f(h',r,t') + gamma) \
$ <eq-tranr-loss>

== Graph neural network <sec-graph-neural-networks>

$
bold(z)_h^((l)) = g(bold(z)_h^((l-1)), bold(z)_(cal(N)_h)^((l-1)))
$ <eq-gnn-layer-activations>

$
bold(z)_(cal(N)_h)^((l-1)) = sum_(t in cal(N)_h) alpha(h,r,t)bold(z)^((l-1))_t : (h,r,t) in cal(G)_K
$ <eq-gnn-neighbourhood>

$
e(h,r,t) = bold(e)_t^r^top tanh(bold(e)_h^r + bold(e)_r)\
alpha(h,r,t) = "softmax"(e(h,r,t))=(exp(e(h,r,t)))/(sum_(t_h in cal(N)_h) exp(e(h,r,t_h)))
$ <eq-gnn-attention>

$
g(bold(z)_h^((l-1)), bold(z)_(cal(N)_h)^((l-1))) = "leakyReLU"((bold(z)_h^((l-1)) || bold(z)_(cal(N)_h)^((l-1)))bold(W)^((l)))
$ <eq-gnn-aggregation>

$
z_h^* = bold(z)_h^((0)) || ... || bold(z)_h^((L)) : {bold(z)_h^((0)),...,bold(z)_h^((L))}
$ <eq-gnn-embedding>

$
hat(y)_"ht" = bold(z)_h^*^top * bold(z)_t^*
$ <eq-gnn-cosine-similarity>

$
cal(L)_"higher" = sum_((h,r_0,t) in cal(G)_K) sum_((h',r_0,t') in.not cal(G)_K) sigma(hat(y)_"ht" - hat(y)_"h't'")
$ <eq-gnn-loss>

$
cal(L) = cal(L)_"first" + cal(L)_"higher" + lambda || theta ||
$ <eq-shadewatcher-loss>

$
theta = {bold(e)_h, bold(e)_r, bold(e)_t, bold(W)_r, bold(W)^((l)) : h,t in cal(V), r in cal(E), l in {1,...,L}}
$ <eq-shadewatcher-params>

$
italic("similarity") = bold(a) dot bold(b) = cos(theta) dot || bold(a) ||_2 dot || bold(b) ||_2
$ <eq_cosine_similarity>