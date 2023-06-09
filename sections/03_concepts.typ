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

// (formal definiton, structure, properties, related use case)

$
cal(G) &= (cal(V), cal(E)) \
cal(E) &= {{u, i} : u in cal(U),i in cal(I)} \
cal(V) &= cal(U) union cal(I) : cal(U) sect cal(I) = nothing
$ <eq-graph-bipartite>

== Provenance graph <sec-provenance-graph>

$
cal(G)_P &= (cal(V), cal(E)) \
cal(V) &= {italic("process, file, socket, ...")} \
cal(E) &= {(h, r_"ht" , t) : h, t in cal(V) : r_"ht" in cal(R)} \
cal(R) &= {italic("clone, read, write, ...")}
$ <eq-graph-provenance>

== Context awareness <sec-context-awareness>

$
cal(G)_C &= (cal(V), cal(E)) \
cal(E) &= {(h, r_"ht" , t) : h,t in cal(V) : r_"ht" in {0,1}} \
cal(V) &= cal(D) union cal(S)  : cal(D) sect cal(S) = nothing \
cal(D) &= {italic("file, socket, ...")} \
cal(S) &= {italic("process, ...")} \
$ <eq-graph-context>

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