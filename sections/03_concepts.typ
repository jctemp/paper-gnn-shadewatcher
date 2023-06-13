#set math.equation(numbering: "(1)")
#show math.equation.where(block: true): set text(size: 9pt)
#show math.equation.where(block: false): set text(size: .9em)
#show math.equation.where(block: true): it => {
    pad(y: .2em, it)
}

= Concepts <sec-concepts>

// paragraph

In this section, we will discuss the various concepts that enable `ShadeWatcher` to predict malicious and benign behaviour of system entities.
We will cover the following topics: graph theory, recommender systems, provenance graphs, context awareness, knowledge graphs, translational embeddings, and graph neural networks.

== Graph theory <sec-graph-theory>

// paragraph

In mathematics, a graph (@eq-graph) is defined as a tuple consisting of nodes ($cal(V)$) and edges ($cal(E)$), which together describe the structure of the graph. 
Each edge connects two nodes that are part of the set of nodes.
The connection can be uni- or bidirectional as directed (tuple) or undirected (set).

$
cal(G) &= (cal(V), cal(E)) \
cal(E) &= {(h, t) : h,t in cal(V)}
$ <eq-graph>

// paragraph

Graphs have the necessary properties to work with complex data.
They allow for various topological structures while capturing information in an arbitrary form.
Hence, one has the opportunity to model complex relationships across different data domains, and it is natural to visualise, explore, interact and search in #cite("knowledge-graphs-2022", "knowledge-graph-science-2018").
Additionally, graphs can handle incomplete and degenerated data, which is essential as data can occur sparsely, resulting in many empty fields regarding classic table-like structures @sparsity-problem-2004.
Further, one can incorporate additional information by assigning attributes to nodes and edges.

// paragraph

`ShadeWatcher` @shadewatcher-2022 utilises the graph structure extensively across all upcoming sections.
It leverages the fact that it can encode structured information efficiently and exploits it to gain valuable information about the data.


== Recommender systems <sec-recommender-systems>

// paragraph

A recommender system can make personalised recommendations to users based on their existing connections.
Recommendations can be made with a technique called collaborative filtering.
To apply the concept of collaborative filtering on a graph, we must define recommendation as a graph.

// paragraph

We can express the idea as a $k$-partite graph, where $k$ denotes the number of disjoint sets.
For example, a bipartite graph (@eq-graph-bipartite) represents user-items interactions where we have two sets: users ($cal(U)$) and items ($cal(I)$).

$
cal(G) &= (cal(V), cal(E)) \
cal(E) &= {{u, i} : u in cal(U),i in cal(I)} \
cal(V) &= cal(U) union cal(I) : cal(U) sect cal(I) = nothing
$ <eq-graph-bipartite>

// paragraph

Literature #cite("sparsity-problem-2004", "recommendation-2021", "kgat-2019") elaborates on challenges like incomplete connections and the amount of data that is needed to be analysed.
Research aimed to improve collaborative filtering for these challenges.
However, it still needs improvement in performance and explainability in some cases, e.g. e-commerce  @collaborative-filtering-2018.
Therefore, one aims to improve recommendations by accommodating more information (also discussed as side information @kgat-2019).
The side information helps to discover high-order connections #cite("kgat-2019", "collaborative-filtering-2018"), making predictions theoretically better.

// paragraph

The `ShadeWatcher` authors adopted the recommendation approach for threat detection by applying the concept described in @kgat-2019.
Accordingly, the following sections will reveal the connection between threat analysis and recommendation.

== Provenance graph <sec-provenance-graph>

// paragraph

System provenance is essential for computer forensics as it describes entities (process, files and sockets) in a computer system with metadata @trustworthy-provenance-2015.
The metadata, also called audit data, is gathered during the execution of a system and provides valuable insights into an entity's interaction history, allowing specialists to comprehend and reason about the system's current state.
Using the provenance data, one can derive a provenance graph (PG) @trustworthy-provenance-2015 by analysing the audit data to find connections between entities and append them to the graph accordingly.
Consequently, we can define the PG (@eq-graph-provenance) as a set of system entities representing nodes ($h,t in cal(V)$) and a set of interactions between the entities representing edges ($cal(E)$).
In addition, we add a label ($r_"ht" in cal(R)$) to the edges representing a relation type.

$
cal(G)_P &= (cal(V), cal(E)) \
cal(V) &= {italic("process, file, socket")} \
cal(E) &= {(h, r_"ht" , t) : h, t in cal(V) : r_"ht" in cal(R)} \
cal(R) &= {italic("clone, fork, read, write, ...")}
$ <eq-graph-provenance>

// paragraph

We want to include an example (@fig-audit-data) of audit data in `JSON` format for completeness.
The audit data has various information about the performed action.
More specifically, a process with the PID `18113` successfully reads `105` bytes of a file with the file descriptor `98`.

#figure(
text(size: 8pt)[
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
    ```
],
  caption: [The figure presents a single audit record of a Linux system @shadewatcher-source-2022.],
) <fig-audit-data>

// paragraph

Considering a secure collection process of the audit data, it is feasible to gather all system entities, having a complete representation of a system's history.
The authors @trustworthy-provenance-2015 introduced this as whole-systems provenance showing the interaction of agents, processes and data types.
Provenance collection is available on the three major operating systems (OS): Linux, MacOS and Windows @provenance-auditing-2012.
Note that it is feasible on other OS derivatives; however, we cannot provide any reference.
Regardless, this paper will focus on Linux-based systems as the `ShadeWatcher` authors only considered Linux because it supports capturing provenance on a system-call level.

// paragraph

`ShadeWatcher` utilises the PG as a foundation for the knowledge graph.
Furthermore, the authors perform additional analysis on the PG to enrich the knowledge graph with crucial information about entity relations.

// paragraph

Finally, to clarify the concept of PG, we will provide an illustrative example explained in @provenance-aware-2006. 
We constructed a theoretical illustration (@fig-pg-example) based on the scenario described.

// paragraph

Imagine a user with an alias for the `rm` command that moves deleted files to a folder called `garbage` containing the deleted files.
An attacker successfully infiltrated the user's system and replaced the `garbage` folder with a symbolic link to a location accessible to the attacker.
Accordingly, deleting a sensitive file would move it to a location where the attacker can perform further disguising actions.

// paragraph

By utilising provenance data, one can systematically analyse the changed state in the system and recognise that sensitive information is moved to an odd location (e.g. sockets) which is suspicious and an indicator of malicious behaviour.

#figure(
    image("../figures/shadewatcher-illustrations-pg-example.drawio.png", alt: "The figure displays a theoretical provenance graph.", width: 80%),
    caption: [The figure displays a theoretical provenance graph (own illustration).]
) <fig-pg-example>

== Entity context graph <sec-entity-context-graph>

// (formal definiton, structure, properties, related use case)
In a previous @sec-recommender-systems, we discussed how side information is essential for recommendation @kgat-2019.
In the case of threat analysis, side information allows one to form high-order connections #cite("shadewatcher-2022", "watson-2021") in the PG.
High-order connections mean that two system entities are indirectly connected via multiple hops (a hop means traversing an edge in a graph).
Consequentially, it supplies additional semantics regarding the system entity's context @shadewatcher-2022.

The problem is that the PG does not directly encode the side information @shadewatcher-2022.
Therefore, `ShadeWatcher` uses the system entity's context to derive side information.
A context captures a collection of system entities and interactions representing system behaviour @watson-2021.
One can extract the context from the PG by building multiple subgraphs encoding the side information.

The `ShadeWatcher` authors proposed applying depth-first search (DFS) to discover relevant subgraphs.
However, to make DFS usable for this task, one requires further constraints for the method @watson-2021.

First, one must enforce the time monotony of the events.
With that, the authors @watson-2021 mitigate cyclic dependencies that could happen because some events can connect to others that are in the past relative to the current event.
Nonetheless, such connections have the potential to deliver crucial information.
Therefore, one allows a single hop to consider past events.
Secondly, handling entities with a high node degree is necessary because these can lead to a dependency explosion.
Accordingly, the authors suggested filtering these events through statistical analysis and expert knowledge.

After incorporating the constraints, it is possible to conduct additional semantic analysis and explore subgraphs.
`ShadeWatcher` uses methods to determine the subgraphs for root entity objects (entities at which the method starts the discovery).
The authors limited the root entities by partitioning the entity set ($cal(V)$) into two disjoint subsets.
One has data entities ($cal(D)$), files and sockets.
All other entities belong to the subset of system entities ($cal(S)$).
The final step is to take all descending entities in the graph and create the root-children interactions.
These connections will be labelled with an _interact_ relation type.

Finally, we can define the entity context graph (CG), modelling semantic system entity interactions.
The corresponding @eq-graph-context expresses the configuration.
Note that the `ShadeWatcher` author called this graph a bipartite; however, we changed the name to avoid confusion with the mathematical definition of a bipartite graph.
The authors intended to assemble a similar structure to a bipartite graph because it preserves the collaborative filtering signal @gnn-recommendation-2020 (the concept of user-item interactions).
The meaning of a similar structure is that the context graph has partitions for entities; however, we do not constrain the interactions within the disjoint subsets.

$
cal(G)_C &= (cal(V), cal(E)) \
cal(E) &= {(h, r_"ht" , t) : h,t in cal(V) : r_"ht" in {italic("interact")}} \
cal(V) &= cal(D) union cal(S)  : cal(D) sect cal(S) = nothing \
cal(D) &= {italic("file, socket, ...")} \
cal(S) &= {italic("process, ...")} \
$ <eq-graph-context>

== Knowledge graph <sec-knowledge-graph>

`ShadeWatcher` gives a knowledge graph (KG) as an input to the machine learning methods.
The KG represents data and dependencies with context-specific entities and their interactions @knowledge-graphs-2022.
The authors of `ShadeWatcher` retrieve this representation by combining the PG and CG.
One can union the two graphs due to their similar structure (see @eq-graph-provenance and @eq-graph-context).
The PG provides the system's topological structure, while the CG provides system behaviour @watson-2021.

$
cal(G)_K &= cal(G)_P union cal(G)_C
$ <eq-graph-knowledge>

For completeness, we have provided a visual representation of a KG (@fig-kg).
It shows a data exfiltration scenario where a user tried to mislead a threat detection system by disguising the copy of a sensitive file @watson-2021.

`ShadeWatcher` utilises the KG to create two types of embeddings:

+ Embeddings for first-order entities enclose *first-hop relations* using translation-based methods like `TransE` @transe-2013, `TransH` @transh-2014, or `TransR` @transr-2015.
+ Embeddings for higher-order entities enclose *multi-hop relations* using graph convolutions @graph-convolutional-network-2016 with attentive propagation @gat-2018 and `GraphSAGE` aggregation @graph-sage-2017.

The following two sections will discuss these two approaches in detail.

#figure(
    image("../figures/shadewatcher-illustrations-pg-context-single.drawio.png", alt: "The figure displays a simple knowledge graph."),
    caption: [The figure displays a simple knowledge graph (Modified @watson-2021).]
) <fig-kg>

== Translational embeddings <sec-translational-embeddings>

One technique for creating embeddings for multi-relational data involves using a directed graph @transe-2013. 
The idea is to generate low-dimensional embeddings for entities and relations in a shared embedding space ($RR^k$).
In this space, relations are represented as translations, and if a triplet like $(italic("h, l, t"))$ represents a valid relationship, then the desired outcome is that $italic(h) + italic(l) approx italic(t)$.

However, for more complex relationship cardinalities like 1-to-Many, Many-to-1 or reflexive relations, simply creating three embeddings and optimising their distance is not enough, as pointed out by @transh-2014.
The capacity of the `TransE` model for this purpose is relatively low #cite("transe-2013", "transh-2014"). 
Therefore, `TransH` introduces the concept of hyperplane translations.

In `TransH` @transe-2013, entity and relation space are separated, and each entity has a relations-specific translation.
To achieve this, the authors describe the hyperplane using a normal vector, which is then used to perform a projection onto the hyperplane. 
The relation vector is orthogonal to the normal vector.
This approach allows for more sophisticated modelling of relations beyond the essential translations used in `TransE`.

Still, because `TransH` assumes identical entity and relation embedding dimensions, it misses delicate nuances @transr-2015.
Accordingly,  the authors of `TransR` @transr-2015 incorporated the differentiation of embedding dimensions, allowing the model to outperform its predecessors.

`ShadeWatcher` employs the `TransR` method because it provides state-of-the-art performance regarding link predictions.
The following paragraphs elaborate on the learning process of `TransR`.

Embeddings are n-dimensional vectors that aim to represent an entity and relation in the KG.
In the case of a triplet, $(h, r, t)$, both entities - $h$ and $t$ - and the relation - $r$ - have their corresponding embeddings, which are trainable (@eq-transr-embeddings). 
`ShadeWatcher` did not further define the initialisation, but one can use one-hot encoding or random values. 

$
(h,r,t) : bold(e)_h, bold(e)_t in RR^k and bold(e)_r in RR^d
$ <eq-transr-embeddings>

The translation of an entity is only possible in _relation space_.
Therefore, we perform a projection using a relation-specific projection matrix (@eq-tranr-projection-matrix). 
Accordingly, `TransR` expects a similar outcome to `TransE` ($bold(bold(e)_h^r + bold(e)_r approx bold(e)_t^r)$).
Subscript $r$ indicates the projection.
As with the embedding, the projection matrix is trainable, and the initialisation is undefined but likely random.

$
bold(M_r) in RR^(k times d)
$ <eq-tranr-projection-matrix>

The performance of the embeddings is measured with a score function (@eq-tranr-measure) that indicates dissimilarity @transe-2013.
`ShadeWatcher` deviates from the original suggestion in `TransR` @transr-2015 by only measuring the distance without squaring the result. 
This change has the effect of less penalty for significant differences. 

$
bold(e)_h^r = bold(e)_h bold(M)_r and bold(e)_t^r = bold(e)_t bold(M)_r\ 
f(h,r,t) = || bold(bold(e)_h^r + bold(e)_r - bold(e)_t^r) ||
$ <eq-tranr-measure>

The model's performance is calculated using a margin-based pairwise ranking loss function #cite("shadewatcher-2022", "transe-2013", "transr-2015"). 
This function optimises the learnable parameters based on the knowledge graph's observed and unobserved (corrupted) triplets.
We obtain corrupted triplets by replacing the entity -  $h$ or $t$ - with a random entity. 
Since there is a risk of sampling valid triplets, `TransR` @transr-2015 must account for the relationship cardinality, e.g. in a 1-to-many scenario corrupting $t$ would have a higher likelihood of being a valid triplet again.
The margin, a hyperparameter, is used to separate further corrupted and valid triplets. 
The loss function aims to maximise similarity for valid and minimise similarity for corrupted tuples. 
The loss term contributes to the complete loss later. 

$
cal(L)_"first" &= sum_((h,r,t) in cal(G)_K) sum_((h',r,t') in.not cal(G)_K) sigma(f(h,r,t) - f(h',r,t') + gamma) \
$ <eq-tranr-loss>

In the loss function, $sigma$ denotes a non-linear transformation. 
`ShadeWatcher` replaced the ReLU @transe-2013 with the Softplus function, $log(1+exp(x))$.

// @fig-transr

// #figure(
//     image("../figures/shadewatcher-illustrations-transr.drawio.png", alt: "The illustration shows the translational-based entity embedding approach.", width: 90%),
//     caption: [The illustration shows the translational-based entity embedding approach (modified @transr-2015).]
// ) <fig-transr>

== Graph neural network <sec-graph-neural-networks>

As previously discussed, when it comes to system entities, their context can be used as additional information represented by high-order connections via a multi-hop path. 
A graph neural network (GNN) #cite("shadewatcher-2022", "kgat-2019", "graph-convolutional-network-2016") aims to provide higher-level information.
With message passing, entities update their representations by accumulating recursively propagated neighbour information.
Hence, the GNN consists of $L$ layers.

With these layers (@eq-gnn-layer-activations), the GNN can update the representation $bold(z)_h^((l))$ for a given entity $h$. 
For each layer, the algorithm updates the representation of an entity $h$ using its previous value and the neighbourhood $cal(N)_h$. 
The initialisation of $bold(z)_h^((0))$ is done using the embedding $e_h^r$ provided by `TransR`.

$
bold(z)_h^((l)) = g(bold(z)_h^((l-1)), bold(z)_(cal(N)_h)^((l-1)))
$ <eq-gnn-layer-activations>

The neighbourhood representation is the sum of neighbour values in layer $l-1$ (@eq-gnn-neighbourhood).
The `ShadeWatcher` authors highlight that not all neighbourhood entities are relevant.
Therefore, they incorporated an attention mechanism @gat-2018.
Hence, each neighbour has an attention coefficient $alpha$ assigned to show its importance in the neighbourhood.
Note that a triplet $(h, r, t)$ must include in KG. 

$
bold(z)_(cal(N)_h)^((l-1)) = sum_(t in cal(N)_h) alpha(h,r,t)bold(z)^((l-1))_t : (h,r,t) in cal(G)_K
$ <eq-gnn-neighbourhood>

`ShadeWatcher` uses a customised function to calculate the attention coefficient #cite("shadewatcher-2022","gat-2018").
The `ShadeWatcher` paper @shadewatcher-2022 does not detail the decision-making process, but we can still make some inferences about the design.
Determining the energy value, denoted as $e(h,r,t)$, involves utilising the `TransR` embeddings.
By using the dot product, a scalar is obtained that indicates similarity.
Recall that two entities, $h$ and $t$, with a well-learned relation, will result in a similar direction in relation space ($bold(e)_t^r^top approx bold(e)_h^r + bold(e)_r$).
Furthermore, the `TransR` embeddings encoding semantic and behaviour information #cite("shadewatcher-2022", "watson-2021").
For entities that are not related, the scalar will be negative.
The $tanh$ function is applied to increase the expressiveness @gat-2018.
The `ShadeWatcher` authors applied a softmax over the neighbourhood to acquire a normalised coefficient.

$
e(h,r,t) &= bold(e)_t^r^top * tanh(bold(e)_h^r + bold(e)_r)\
alpha(h,r,t) &= "softmax"(e(h,r,t)) \
             &= (exp(e(h,r,t)))/(sum_(t_h in cal(N)_h) exp(e(h,r,t_h)))
$ <eq-gnn-attention>

For the aggregation function (@eq-gnn-aggregation), it follows the `GraphSAGE` @graph-sage-2017 specified criteria (symmetric and trainable). 
Furthermore, the authors of `ShadeWatcher` have adopted an individual solution @kgat-2019. 
In terms of each layer, there is a shared learnable weight represented by $bold(W)^((l))$, which linearly transforms the concatenated values of the current node $h$ and $cal(N)_h$. 
It is worth mentioning that the symbol $dot || dot$ denotes the used concatenation operator. 
Additionally, for enhanced expressiveness, the value undergoes a non-linear transformation using a leakyReLU function.

$
g(bold(z)_h^((l-1)), bold(z)_(cal(N)_h)^((l-1))) = "leakyReLU"((bold(z)_h^((l-1)) || bold(z)_(cal(N)_h)^((l-1)))bold(W)^((l)))
$ <eq-gnn-aggregation>

After the GNN, `ShadeWatcher` has $L$ entity representation.
One concatenates the values of each layer to provide $z_h^*$ (@eq-gnn-embedding), effectively preserving the information from each layer.
Recollect that $bold(z)_h^((0))$ is an embedding that is produced by `TransR`.

$
z_h^* = bold(z)_h^((0)) || ... || bold(z)_h^((L)) : {bold(z)_h^((0)),...,bold(z)_h^((L))}
$ <eq-gnn-embedding>

For recommender systems, one possible measure is the cosine similarity.
`ShadeWatcher` utilises only the dot product, meaning no normalisation of entity embeddings (@eq-gnn-cosine-similarity). 
$
hat(y)_"ht" = bold(z)_h^*^top * bold(z)_t^*
$ <eq-gnn-cosine-similarity>

For a given prediction $hat(y)_"ht"$, one can label it based on a pre-defined threshold @shadewatcher-2022.
The optimisation goal is to recommend entities with which a current entity $h$ will not interact.
Thus, for a positive example, the angle between the embeddings of two entities should be maximised, yielding a negative dot product.
Likewise, the angle should be minimised for a negative example, yielding a positive dot product. 
Applying the Bayesian personalised ranking (BPR) optimisation @bpr-2012 for the GNN's loss function (@eq-gnn-loss), the model learns differences in interaction probabilities, thus providing a total order in the ranking.
Regarding BPR, `ShadeWatcher` replaces the logistic sigmoid function with a softplus function @shadewatcher-source-2022.

$
cal(L)_"higher" = sum_((h,r_0,t) in cal(G)_K) sum_((h',r_0,t') in.not cal(G)_K) sigma(hat(y)_"ht" - hat(y)_"h't'")
$ <eq-gnn-loss>

To complete the process, we need to specify the overall objective.
Accordingly, we can identify the parameters that can be trained.

== Training

For the overall objective (@eq-shadewatcher-loss), `ShadeWatcher` combines the loss functions of `TransR` and GNN.
An L2-regularisation term with a hyperparameter $lambda$ is incorporated to combat overfitting.
Furthermore, it is possible to train all embeddings together @shadewatcher-source-2022.
Alternatively, `ShadeWatcher` can load pre-trained embedding.

$
cal(L) = cal(L)_"first" + cal(L)_"higher" + lambda || theta ||
$ <eq-shadewatcher-loss>

Finally, we can give an overview of the trainable parameters (@eq-shadewatcher-params).
We can see that `ShadeWatcher` learns the first-order entity embeddings using `TransR` with the various projection matrices for each relation type.
More, the GNN allows the learning of the shared layer weights.
Note that the attention parameters are indirectly trained through `TransR`.

$
theta = {bold(e)_h, bold(e)_r, bold(e)_t, bold(W)_r, bold(W)^((l)) : h,t in cal(V), r in cal(E), l in {1,...,L}}
$ <eq-shadewatcher-params>
