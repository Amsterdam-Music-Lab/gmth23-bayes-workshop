# Bayesian Corpus Studies

Code and data for the workshops on Bayesian modelling and probabilistic programming
at the GMTH congress (September 2023),
and in Würzburg (February 2024).

The repo is organized as follows:
- The directory [`presentation`](presentation/) contains
  - a brief introduction to Bayesian corpus studies in German (from GMTH 2023),
  - a set of longer presentations in English (from Würzburg 2024).  
- [`regularity.ipynb`](regularity.ipynb) contains a simple introduction to PyMC
  using a model of rhythmic regularity introduced in the longer slides
- [`intervals_exercise.ipynb`](intervals_exercise.ipynb)
  contains an extended exercise using models of interval sizes in polyphonic music.
  The solution to this exercise can be found in [`intervals_exercise_solution.ipynb`](intervals_exercise_solution.ipynb).
- [`intervals_complete.ipynb`](intervals_complete.ipynb)
  contains an additional model comparison that is not part of the exercise notebook.
- The dataset (`bigrams.tsv`) have been derived from the
  [aligned Bach chorale dataset](https://github.com/johentsch/aligned_bach_chorales/).
  If you want to know how exactly the bigrams are computed,
  have a look at [`prepare_data.py`](prepare_data.py).

If you are interested in using probabilistic models and Bayesian statistics for musical research
(e.g. for corpus studies or computational models of music theory),
feel free to get in touch with:
- Christoph Finkensiep (c.finkensiep@uva.nl)

## Getting Started

The notebooks in this repository can be run in two ways,
either using Google Colab or using a local Python/Jupyter installation.

### On Colab

1. Download the notebook that you want to use (or clone the repository using git).
2. Go to https://colab.research.google.com/ and upload the notebook.
3. You should be able to use the notebook right away as Colab comes with all required dependencies.

### On your computer

This requires a local installation of Python and Jupyter.

1. Clone (or download) this repository
2. Install the dependencies. The recommended way to do this is to
   - create a new virtual environment using `venv`
   - install the dependencies from `requirements.txt`
   - install an IPython kernel from within the environment
   ```
   $ cd gmth23-bayes-workshop
   $ python -m venv env
   $ source env/bin/activate
   (env)$ pip install -r requirements.txt
   (env)$ python -m ipykernel install --user --name gmth-bayes-tutorial
   ```
3. Start Jupyter (notebook or lab) and open the notebook you want to work on.
   Make sure that the notebook uses the kernel that you installed in the previous step.
