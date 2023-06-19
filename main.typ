#import "template.typ": *

#show: ieee.with(
  title: "ShadeWatcher: Recommendation-guided Cyber Threat Analysis using System Audit Records",
  authors: (
    (
        name: "Jamie Christopher Temple",
        department: [Department of Computer Science],
        organization: [Hochschule Hannover University of Applied Sciences and Arts],
        location: [Hanover, Germany]
    ),
  ),
  abstract: [
        This paper covers the novel approach of recommendation-based threat detection `ShadeWatcher`.
        We aim to break down the various components used in `ShadeWatcher` and make them more accessible to a general audience.
        Furthermore, the paper contains inferred explanations for undiscussed aspects in the original paper.
        The paper does not contain an evaluation because of missing comparative data.
        Nonetheless, we will discuss the current concept's caveats and opportunities.
  ],
  index-terms: ("Information Security", "Data Science", "Machine Learning", "Deep Learning", "Graph Neural Networks", "Recommender Systems"),
  paper-size: "a4",
  bibliography-file: "bibliography.bib",
)

#set math.equation(numbering: "(1)")
#show math.equation.where(block: true): set text(size: 9pt)
#show math.equation.where(block: false): set text(size: .9em)
#show math.equation.where(block: true): it => {
    pad(y: .2em, it)
}

#show figure: it => {
    pad(y: 1em, it)
}

#set text(font: "Times New Roman")

#include "sections/01_introduction.typ"
#include "sections/02_related_work.typ"
#include "sections/03_concepts.typ"
#include "sections/04_recommendation.typ"
#include "sections/05_discussion.typ"
