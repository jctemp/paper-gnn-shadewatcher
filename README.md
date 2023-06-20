# ShadeWatcher

**Recommendation-guided Cyber Threat Analysis using System Audit Records**

> This paper covers the novel approach of recommendation-based threat detection `ShadeWatcher`.
> We aim to break down the various components used in `ShadeWatcher` and make them more accessible to a general audience.
> Furthermore, the paper contains inferred explanations for undiscussed aspects in the original paper.
> The paper does not contain an evaluation because of missing comparative data.
> Nonetheless, we will discuss the current concept's caveats and opportunities.

## Project Structure

The project is structured as follows:

- figures: Contains all figures used in the paper
- paper: Contains the `.pdf` files
- sections: Contains the `.typ` files for each section
- experiments: Contains files to reproduce `ShadeWatcher`
    1. `setup`: perpares the folder
    2. `build`: builds the docker image
    3. `run`: starts the docker container
    4. `stop`: stops the docker container
    - `todo.sh`: additional stuff to run scripts in the container
