#import "template.typ": *

#show: ieee.with(
  paper-size: "a4",
  title: "ShadeWatcher: Recommendation-guided Cyber
Threat Analysis using System Audit Records",
  abstract: [
    This paper covers the novel approach of recommendation-based threat detection realised by `ShadeWatcher`.
    We aim to break down the various components used in `ShadeWatcher` and make them more accessible to a general audience.
    Furthermore, the paper contains inferred explanations for undiscussed aspects in the original paper.
    The paper does not contain an evaluation because of missing comparative data.
    Nonetheless, we will discuss the current concept's caveats and opportunities.
  ],
  authors: (
    (
      name: "Jamie Christopher Temple",
      department: [Department of Computer Science],
      organization: [Hochschule Hannover University of Applied Sciences and Arts],
      location: [Hanover, Germany]
    ),
  ),
  index-terms: ("Information Security", "Data Science", "Machine Learning", "Deep Learning", "Graph Neural Networks", "Recommender Systems"),
  bibliography-file: "bibliography.bib",
)

#include "sections/01_introduction.typ"
#include "sections/02_related_work.typ"
#include "sections/03_concepts.typ"
#include "sections/04_recommendation.typ"
#include "sections/05_discussion.typ"
