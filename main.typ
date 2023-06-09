#import "template.typ": *

#show: ieee.with(
  paper-size: "a4",
  title: "ShadeWatcher",
  abstract: [
    #lorem(80)
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
