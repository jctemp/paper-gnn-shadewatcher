= Recommendation <sec-recommendation>

Performing recommendations requires a KG, the `TransR` entity embeddings and the learned GNN weights.
Note that these should be available after training.
Having these three requirements met, one can pass triplets with the interact relation type denoted by $r_0$ to `ShadeWatcher` for a recommendation.
These are propagated through the GNN, yielding a representation that encodes their behaviour and neighbourhood (@eq-gnn-embedding).
Taking the dot product (@eq-gnn-cosine-similarity) of these representations gives a prediction, which is labelled depending on a pre-defined threshold.

In a real system, this process would happen automatically.
Analysts will be notified to review the potential malicious behaviour if the system detects a threat.
Note that this could be a false-positive.
To handle false-positives alarms, the authors of `ShadeWatcher` considered incorporating a feedback loop into the system, allowing it to adjust.
Furthermore, they elaborated that, in theory, reasoning about detection is more straightforward because `ShadeWatcher` provides a fine-grained detection signal with key attack indicators.
