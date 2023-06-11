= Recommendation <sec-recommendation>

Once the audit data has been captured and processed and the training on `ShadeWatcher` is complete, users can predict interactions between existing entities within a system. 
For that, entities are passed to `ShadeWatcher` for a recommendation, propagated through the GNN, yielding a representation that encodes their behaviour and neighbourhood (@eq-gnn-embedding).
Taking the dot product (@eq-gnn-cosine-similarity) of these representations gives a prediction, which is labelled depending on a pre-defined threshold.

In a real system, this process would happen automatically.
Analysts will be notified to review the potential malicious behaviour if the system detects a threat.
Note that this could be a false-positive.
To handle false-positives alarms, the authors of `ShadeWatcher` considered incorporating a feedback loop into the system, allowing it to adjust.
Furthermore, they elaborated that, in theory, reasoning about detection is more straightforward because `ShadeWatcher` provides a fine-grained detection signal.