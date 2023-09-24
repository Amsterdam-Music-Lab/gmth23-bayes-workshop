# gmth23-bayes-workshop

Code and data for the workshop on Bayesian modelling and probabilistic programming
at the GMTH congress 2023.

The [presentation](presentation/slides.pdf) gives a general introduction to Bayesian statistics.
The [notebook](models.ipynb) demonstrates probabilistic programming on an extended case study.
In this case study, we try to understand the sizes of melodic intervals with three different models,
inferring the models' parameters and comparing their plausibility.

The dataset (`bigrams.tsv`) have been derived from the
[aligned Bach chorale dataset](https://github.com/johentsch/aligned_bach_chorales/).
If you want to know how exactly the bigrams are computed,
have a look at [`prepare_data.py`](prepare_data.py).

If you are interested in using probabilistic models and Bayesian statistics for musical research
(e.g. for corpus studies or computational models of music theory),
feel free to reach out to us:
- Christoph Finkensiep (c.finkensiep@uva.nl)
- Martin Rohrmeier (martin.rohrmeier@epfl.ch)
