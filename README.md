
<h1 align="center">(A)ICollaboratory</h1>

<div align="center">
  :steam_locomotive::train::train::train::train::train:
</div>
<div align="center">
  <strong></strong>
</div>
<div align="center">
  A Collaboratory for the evaluation, comparison and classification of <code>(A)I</code>!
</div>

<br />


This project is conceived as a pioneering initiative for the development of a collaboratory for the analysis, evaluation, comparison and classification of  AI paradigms and systems. It will start by incorporating approaches, data, knowledge, measurements and evaluations, within the machine learning, (deep) reinforcement learning and interactive learning paradigms in the field of A(G)I, due to the priorities and particular needs in these areas. The framework will allow the study, analysis and evaluation, in a complete and unified way, of a representative selection of these sort of A(G)I systems, covering, in the longer term, the current and future panorama of the A(G)I. 

**Table of contents**


* [Infraestructure](#nfraestructure) 
* [Architecture](#architecture)
* [Database Design](#database-design)
	* [Schema](#schema)
		* [WHAT dimension](#what-dimension-behavioural-test-catalogue)
		* [WHO dimension](#who-dimension-cognitive-system-inventory)
		* [HOW dimension](#how-dimension-experimentation-repository)
		* [FACT TABLE](#fact-table)
	* [Implementation](#implementation)
		* [ERR diagram](#mysql-err-diagram)
		* [SQL Create script](#mysql-sql-create-script)
* [Data](#data)
	* [AI](#AI)
		* [Deep Learning Architectures](#deep-learning-architectures)
			* [Arcade Learning Environment](#case-study-arcade-learning-environment-atari-2600-games)
			* [General Video Game AI Competition](#case-study-the-general-video-game-ai-competition)
			* [Alpha* systems](#case-study-alpha-systems)
			* [ImageNet](#case-study-imagenet)
		* [Machine Learning algorithms](#machine-learning-algorithms)
			* [OpenML](#case-study-openml)
		* [Computer Chess Systems](#computer-chess-systems)
			* [Computer Chess Rating List](#case-study-ccrl-computer-chess-rating-lists)
	* [Human](#human)
	* [Animal](#animal-non-human)
* [Code](#code-r)
* [Related Work](#related-work)
* [TODOs](#todos)
* [Acknowledgements](#aknowledgements)

# Infraestructure

The collaboratory will integrate open data and knowledge in four domains:


* **Inventory of intelligent systems**,  which incorporates information about current, past and future systems, including hybrid and collectives, natural or artificial, from human professions to AI desiderata. They will be aggregated from individuals to species, groups or organisations, with populations and distributions over them.

* **“Behavioural Test Catalogue**, which will integrate a series of behavioural tests, the dimensions they measure and for which kinds of systems, the possible interfaces and testing apparatus. The catalogue, largely automated and accessible online, will help researchers apply or reproduce the tests.

* **Repository of experimentation**, which will record the results (measurements) of a wide range of systems (natural, artificial, hybrid or collective) for several tests and benchmarks, as the main data source of the atlas. Data will be contributed from scientific papers, experiments, psychometric repositories, AI/robotic competitions, etc. 

* **Constructs of Intelligence Corpus**, which will integrate latent and hierarchical models, taxonomical criteria, ontologies, mappings from low to high-level cognition, as well as theories of intelligence.


# Architecture

Multidimensional perspective (over a database): 

![Multidimensial perspective](https://github.com/nandomp/AICollaboratory/blob/master/Figures/MultidimensionalCollaboratory.png)

Example (simplified) of information stored in the multidimensional model:

```
DQN system, using the parameters of Mnih et al. 2015, 
is evaluated over Moctezuma game (from ALE v1.0) using 100,000 episodes, 
with a measured score of 23.3
```

Each dimension has a structure and captures (part of) the information / ontologies / constructs about intelligence / cognition / tests in the literature.



# Database design

## Schema

### WHAT dimension (Behavioural Test Catalogue)

Entity tables: 

* **TASK**: Instances, datasets, task, tests, etc.
* **SOURCE**: description, author, year, etc.
* **HIERARCHY**: task hierarchy.
* **ATTRIBUTES**: platform, format, #classes, format, etc.

Many-tomany relationships: 

* **_IS**: TASK belongs to TEST in SOURCE (PK: T x T x S)
* **_HAS**: AGENT possess ATTRIBUTES (PK: T x A)
* **_BELONGS_TO**: AGENT belongs to HIERARCHY (PK: T x H)

Examples of rows:

```
TASK "Moctezuma" _IS "Atari-Game" according to SOURCE "Bellemare et al., 2013"
TASK "Winogradschemas" _IS (requires) "Commonsense" (to some extent/weight) according to SOURCE "Levesque 2014".
TASK "Gv" (Visual Processing) _IS (composes) "G" (General Intelligence) according to SOURCE "Cattell-Horn_carroll" and _BELONGS_TO the HIERARCHY "CHC"
```

### WHO dimension (cognitive System Inventory)

* **Agent**: Systems, architectures, algorithms, etc.

Entity tables: 

* **AGENT**: system, algorithm, approach, entity, etc.
* **SOURCE**: description, author, year, etc.
* **HIERARCHY**: agent hierarchy.
* **ATTRIBUTES**: parallelism, hiperparameters, approach, batch, fit, etc.

Examples of rows:

```
AGENT "RAINBOW" _IS a "Deep Learning architecture" according to SOURCE "Hessel et al., 2013"
AGENT "weka.PART(1)_65" _IS "PART" technique according to SOURCE "OpenML".
AGENT "Human Atari gamer" IS " Homo sapiens" according to SOURCE "Bellamare et al., 2013" and _BELONGS_TO the HIERARCHY "Hominoidea"
```

Many-tomany relationships: 

* **_IS**: AGENT belongs to FAMILY in SOURCE (PK: Ag x F x S)
* **_HAS**: AGENT possess ATTRIBUTES (PK: Ag x A)
* **_BELONGS_TO**: AGENT belongs to HIERARCHY (PK: Ag x H)

### HOW dimension (Experimentation Repository)

Entity tables: 

* **METHOD**: testing apparatus, CV, hs, noop, spliting, etc.
* **SOURCE**: description, author, year, etc.
* **ATTRIBUTES**: frames, estimation procedure, folds, repeats, frames, etc.

Many-tomany relationships: 

* **_HAS**: METHOD possess ATTRIBUTES (PK: M x A)

Examples of rows:

```
METHOD "Cross-Validation-Anneal" _HAS "5" number of folds and "2" repetitions according to SOURCE "OpenML"
METHOD "PriorDuel-noop" _HAS  "no-op actions" as procedure, "57" games in testing phase and "200M" training frames according to SOURCE "Wang et al, 2015"
```

### Fact table

Measures:

* **Results**: score, accuracy, kappa, f.measure, recall, RMSE, etc.

Examples of rows:

```
"DDQN-v3.4 AGENT", using a "Dual DQN" approah, "human data" augmentation, "no" parallelism, and the hyperparameters of "Mnih et al. 2015", 
is evaluated over the TASK "Moctezuma" game which belongs to the benchmark "ALE 1.0",  
using as evaluation METHOD "100,000" episodes, "57" test games and "200M" training frames,
obtains a measured score of "23.3"
```

## Implementation

We use a free, lightweight, open source MySQL database.

### MySQL ERR diagram

![ERR](https://github.com/nandomp/AICollaboratory/blob/master/MySQL/Atlas_ERR_v1.png)

### MySQL SQL Create script

[SQL script](https://github.com/nandomp/AICollaboratory/blob/master/MySQL/Atlas_schema_v1.sql)







# Data 

## AI

### Deep Learning Architectures

#### Case Study: Arcade Learning Environment (Atari 2600 games)

The Arcade Learning Environment (ALE) was introduced by [Mnih et al, 2015](https://www.cs.toronto.edu/~vmnih/docs/dqn.pdf), after compiling a good number of games for Atari 2600, a popular console of the late 1970s and most of the 1980s. The simplicity of the games from today’s perspective and the use of a visual input of 210 × 160 RGB pixels at 60Hz makes the benchmark sufficiently rich (but still simple) for the AI algorithms of today. After [Mnih et al, 2015](https://www.cs.toronto.edu/~vmnih/docs/dqn.pdf) achieved superhuman performance for many of the ALE games, the benchmark became very popular in AI. There are so many platforms, techniques and papers using ALE today that the results on this benchmark are usually analysed when talking about breakthroughs and progress in AI.

Data: 

We have performed a bibliographical search to find all the papers that include experiments with a wide range of ALE games. 


Code: 

* OpenML [R API](https://github.com/openml/openml-r).
* [R code]()

Figures: 

Tasks | Systems | Methods | #Results
----- | ------- | ------- | --------
X | Y | Z | R



#### Case Study: The General Video Game AI Competition

The [General Video Game AI](http://www.gvgai.net/) (GVGAI) competition is a benchmark which comprises a large number of real-time 2D grid games such as puzzles, shooters, classic arcades and many more. The games can also differ in the way players are able to interact with the environment (actions), the scoring systems, the objects that are part of a game or the conditions to end the game. Unlike ALE, GVGAI was created to avoid participants tailoring their submissions to a few well-known games. Instead, participants are pitted against a number of unseen games. Another difference is that controllers are able to access an abstract representation of the game state (so complex perception is not needed) as well
as a simulator so that (look-ahead) tree search algorithms and other planning approaches can be used. This environment is usually addressed by non-deterministic learning algorithms such as Monte-Carlo Tree Search (MCTS) and Evolutionary Algorithms (EA). Still as of yet, there has not been an approach able to consistently be successful on all games, showing that all the techniques used have their strengths and weaknesses.

Data: 

We have gathered the scores of 49 games and the 23 controllers (agents) that were submitted to the 2015 GVGAI competition [31]. Each game has 5 levels,
and each level was attempted 5 times. This makes a total of 23×49×5×5 = 28175 trials. For each trial the data includes the win/loss achieved by the controller.

Code: 

* [R code]()

Figures: 

Tasks | Systems | Methods | #Results
----- | ------- | ------- | --------
X | Y | Z | R



#### Case Study: Alpha* systems

Alpha* refers to a series of papers and associated techniques by DeepMind to play board games. We analyzed the whole series, from *AlphaGo* [33] (including the Fan and Lee versions, used against Fan Hui and Lee Sedol, respectively, and its latest version, *AlphaGo Master*, which won 60 straight online games against professional Go players), *AlphaGo Zero* [35] (a version created without using data from human games) and *AlphaZero* [34] (which uses an approach similar to AlphaGo Zero to master not just Go, but also chess and shogi).

Data: 

We have performed a bibliographical search to find all the papers that include experiments performed by Alpha* systems:

 

Code: 

* [R code]()

Figures: 

Tasks | Systems | Methods | #Results
----- | ------- | ------- | --------
X | Y | Z | R



#### Case Study: ImageNet

This case study aims to analyse state-of-the-art DNN architectures submitted for the ImageNet challenge over the last years, in terms of computational requirements (memory, parameters, operations count, inference time, power consumption, size, etc.) and performance (accuracy), as well as, if reported, data, knowledge, software, human attention, and calendar time. The purpose of this analysis is to stress the importance of these figures, which are essential to the measurement of AI progress.

Data: 

We have performed a bibliographical search to find all the papers that include experiments performed DNN systems/architectures which have addressed (and won!) the ImageNet challenge:


Code: 

* [R code]()

Figures: 

Tasks | Systems | Methods | #Results
----- | ------- | ------- | --------
X | Y | Z | R





### Machine Learning algorithms

#### Case Study: OpenML 

[OpenML](https://www.openml.org/) is an online machine learning platform for sharing and organizing data, machine learning algorithms and experiments. It is designed to create a frictionless, networked ecosystem, that you can readily integrate into your existing processes/code/environments, allowing people all over the world to collaborate and build directly on each other’s latest ideas, data and results, irrespective of the tools and infrastructure they happen to use.

Data has been gathered from the [OpenML Study 14](https://www.openml.org/s/14), a collaborative, reproducible benchmark. This study collects experiments from multiple researchers, run with different tools (mlr, scikit-learn, WEKA,...) and compares them all on a benchmark set of 100 public datasets (the OpenML-100). All algorithms were run with optimized (hyper)parameters using 200 random search iterations.

Data: 

Code: 

* OpenML [R API](https://github.com/openml/openml-r).
* [R code]()


Tasks | Systems | Methods | #Results
----- | ------- | ------- | --------
X | Y | Z | R



### Computer Chess Systems 

#### Case Study: (CCRL) Computer Chess Rating Lists


Engine vs engine chess testing. Web-scraped data from [CCRL](http://www.computerchess.org.uk/ccrl/). 

3 evaluation methodologies:

* **40/40**: Ponder off, General book (up to 12 moves), 3-4-5 piece EGTB. Time control: Equivalent to 40 moves in 40 minutes on Athlon 64 X2 4600+ (2.4 GHz), about 15 minutes on a modern Intel CPU.
* **40/4**: Ponder off, General book (up to 12 moves), 3-4-5 piece EGTB. Time control: Equivalent to 40 moves in 4 minutes on Athlon 64 X2 4600+ (2.4 GHz), about 1.5 minutes on a modern Intel CPU.
* **404FRC**: Shredder GUI, ChessGUI by Matthias Gemuh, Ponder off, 5-men EGTB, 128MB hash, random openings with switched sides. Time control: Equivalent to 40 moves in 4 minutes on Athlon 64 X2 4600+ (2.4 GHz), about 1.5 minutes on a modern Intel CPU.

Tasks | Systems | Methods | #Results
----- | ------- | ------- | --------
X | Y | Z | R


...

## Human

...

## Animal (non-human)

...








# Code (R)




# References




# TODOs 

- [x] Definition of repository requirements
- [ ] Inventory of A(G)I systems








# Aknowledgements

European Commission's [HUMAINT](https://ec.europa.eu/jrc/communities/en/community/humaint) project within the [JRC's Centre for Advanced Studies](https://ec.europa.eu/jrc/en/research/centre-advanced-studies)

<a href="https://ec.europa.eu/jrc/communities/en/community/humaint"><img src="https://ec.europa.eu/jrc/communities/sites/jrccties/themes/jrccities_subtheme/logo.png?sanitize=true&raw=true" alt="Example" width="100" /><img src="https://ec.europa.eu/jrc/communities/sites/jrccties/files/styles/community_banner/public/banner_0.jpg?itok=Q15FvEkx?sanitize=true&raw=true" alt="Example" width="400" /></a>