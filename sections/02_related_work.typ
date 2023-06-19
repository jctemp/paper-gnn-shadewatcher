= Related work <sec-related-work>

Besides `ShadeWatcher` @shadewatcher-2022, other anomaly-based detectors exist.
We will briefly present two other detectors: `Unicorn` @unicorn-2020 and `ThreaTrace` @threatrace-2022.

`Unicorn` and `ThreaTrace` leveraged the idea of whole-system provenance and were designed for real-time usage.
They also aim to allow for long-term system behaviour monitoring to detect APTs.
Finally, they suggest using a provenance graph to capture the context of a system entity (e.g., a file or a process).
Nonetheless, they differ in their approach.

== Unicorn <sec-unicorn>

`Unicorn` @unicorn-2020 utilises provenance to create so-called graph histograms, representing the history of system execution.
It also preserves the graph structure and can be efficiently updated and compared.
Furthermore, it allows the model to forget learned features, which mitigates the problem of concept drift @concept-drift-2019.

== ThreaTrace <sec-thretrace>

In contrast to `Unicorn`, `ThreaTrace` @threatrace-2022 uses inductive graph neural network learning (`GraphSAGE`) to learn the benign (normal) behaviour of a system.
Further, they leverage the idea of boosting, using multiple models for subgraphs approximating the whole graph.
Finally, detected anomalies are traceable, making the reasoning process more transparent.