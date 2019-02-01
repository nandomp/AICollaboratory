<div align="center">
<img src="https://github.com/nandomp/AICollaboratory/blob/master/Figures/AICollaboratoryLogo.png"
      alt="[A]I Colaboratory" width="600" />
</div>
<h1 align="center"></h1>


<div align="center">
  A Collaboratory for the evaluation, comparison and classification of <code>(A)I</code> !
</div>

<div align="center">
  :boy::girl::baby:  :monkey_face::octopus::whale2:  :space_invader::computer::iphone:
</div>


<br />


This project is conceived as a pioneering initiative for the development of a collaboratory for the analysis, evaluation, comparison and classification of [A]I systems. This project will create a unifying setting that incorporates data, knowledge and measurements to characterise all kinds of intelligence, including humans, non-human animals, AI systems, hybrids and collectives thereof. The firt prototype of the collaboratory will allow the study, analysis and evaluation, in a complete and unified way, of a representative selection of these sort of [A]I systems, covering, in the longer term, the current and future panorama of the [A]I. 


:triangular_flag_on_post: **Table of contents**


* [Infraestructure](#page_with_curl-infraestructure) 
* [Architecture](#pencil2-architecture)
* [Database Design](#books-database-design)
	* [Multidemensional Schema](#multidimensional-schema)
		* [WHAT dimension](#what-dimension-behavioural-test-catalogue)
		* [WHO dimension](#who-dimension-cognitive-system-inventory)
		* [HOW dimension](#how-dimension-experimentation-repository)
		* [FACT TABLE](#fact-table)
	* [Implementation](#implementation)
		* [ERR diagram](#mysql-err-diagram)
		* [SQL Create script](#mysql-sql-create-script)
* [Data](#file_folder-data)
	* [AI](#computer-ai)
		* [Deep Learning Architectures](#deep-learning-architectures)
			* [Arcade Learning Environment](#case-study-arcade-learning-environment-atari-2600-games)
			* [General Video Game AI Competition](#case-study-the-general-video-game-ai-competition)
			* [Alpha* systems](#case-study-alpha-systems)
			* [ImageNet](#case-study-imagenet)
		* [Machine Learning algorithms](#machine-learning-algorithms)
			* [OpenML](#case-study-openml)
		* [Computer Chess Systems](#computer-chess-systems)
			* [Computer Chess Rating List](#case-study-ccrl-computer-chess-rating-lists)
	* [Human](#woman-human)
	* [Animal](#hear_no_evil-animal-non-human)
* [Usage](#hammer-usage)
* [Code](#-code-r)
* [References](#orange_book-references)
* [TODOs](#todos)
* [Credits](#muscle-credits)
* [Acknowledgements](#heart-aknowledgements)

# :page_with_curl: Infraestructure

The collaboratory will integrate open data and knowledge in four domains:


* **Inventory of intelligent systems**,  which incorporates information about current, past and future systems, including hybrid and collectives, natural or artificial, from human professions to AI desiderata. They will be aggregated from individuals to species, groups or organisations, with populations and distributions over them.

* **Behavioural Test Catalogue**, which will integrate a series of behavioural tests, the dimensions they measure and for which kinds of systems, the possible interfaces and testing apparatus. The catalogue, largely automated and accessible online, will help researchers apply or reproduce the tests.

* **Repository of experimentation**, which will record the results (measurements) of a wide range of systems (natural, artificial, hybrid or collective) for several tests and benchmarks, as the main data source of the atlas. Data will be contributed from scientific papers, experiments, psychometric repositories, AI/robotic competitions, etc. 

* **Constructs of Intelligence Corpus**, which will integrate latent and hierarchical models, taxonomical criteria, ontologies, mappings from low to high-level cognition, as well as theories of intelligence.


# :pencil2: Architecture

Multidimensional perspective (over a database): 

<div align="center">
<img src="https://github.com/nandomp/AICollaboratory/blob/master/Figures/MultidimensionalCollaboratory.png"
      alt="Multidimensial perspective" width = "700"/>
</div>
<br>

Example (simplified) of information stored in the multidimensional model:

```
DQN system, using the parameters of Mnih et al. 2015, 
is evaluated over Moctezuma game (from ALE v1.0) using 100,000 episodes, 
with a measured score of 23.3
```

Each dimension has a structure and captures (part of) the information / ontologies / constructs about intelligence / cognition / tests in the literature.



# :books: Database design

## Multidimensional Schema

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

### WHO dimension (Cognitive System Inventory)

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

We use a free, lightweight, open source [MySQL](https://www.mysql.com/) database.

### MySQL ERR diagram

![ERR](https://github.com/nandomp/AICollaboratory/blob/master/MySQL/Atlas_ERR_v1.png)

### MySQL SQL Create script

[SQL script](https://github.com/nandomp/AICollaboratory/blob/master/MySQL/Atlas_schema_v1.sql)







# :file_folder: Data 

## :computer: AI

### Deep Learning Architectures

#### Case Study: Arcade Learning Environment (Atari 2600 games)

The Arcade Learning Environment (ALE) was introduced by [Mnih et al, 2015](https://www.cs.toronto.edu/~vmnih/docs/dqn.pdf), after compiling a good number of games for Atari 2600, a popular console of the late 1970s and most of the 1980s. The simplicity of the games from today’s perspective and the use of a visual input of 210 × 160 RGB pixels at 60Hz makes the benchmark sufficiently rich (but still simple) for the AI algorithms of today. After [Mnih et al, 2015](https://www.cs.toronto.edu/~vmnih/docs/dqn.pdf) achieved superhuman performance for many of the ALE games, the benchmark became very popular in AI. There are so many platforms, techniques and papers using ALE today that the results on this benchmark are usually analysed when talking about breakthroughs and progress in AI.

Data: 

We have performed a bibliographical search to find all the papers that include experiments with a wide range of ALE games. 


Code: 

* OpenML [R API](https://github.com/openml/openml-r).
* [R code]()

Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
Weka algorithms | 1315 | 90 | 90 | 424235
mlr algorithms | 1597 | 92 | 92 | 118190
Sklearn algorithms | 3326 | 92 | 92 | 68667
Weka algorithms | 31 | 90 | 90 | 1132
Weka algorithms | 12 | 3 | 3 | 169

Visualisation examples:




#### Case Study: The General Video Game AI Competition

The [General Video Game AI](http://www.gvgai.net/) (GVGAI) competition is a benchmark which comprises a large number of real-time 2D grid games such as puzzles, shooters, classic arcades and many more. The games can also differ in the way players are able to interact with the environment (actions), the scoring systems, the objects that are part of a game or the conditions to end the game. Unlike ALE, GVGAI was created to avoid participants tailoring their submissions to a few well-known games. Instead, participants are pitted against a number of unseen games. Another difference is that controllers are able to access an abstract representation of the game state (so complex perception is not needed) as well
as a simulator so that (look-ahead) tree search algorithms and other planning approaches can be used. This environment is usually addressed by non-deterministic learning algorithms such as Monte-Carlo Tree Search (MCTS) and Evolutionary Algorithms (EA). Still as of yet, there has not been an approach able to consistently be successful on all games, showing that all the techniques used have their strengths and weaknesses.

Data: 

We have gathered the scores of 49 games and the 23 controllers (agents) that were submitted to the 2015 GVGAI competition [31]. Each game has 5 levels,
and each level was attempted 5 times. This makes a total of 23×49×5×5 = 28175 trials. For each trial the data includes the win/loss achieved by the controller.

Code: 

* [R code]()

Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
Weka algorithms | X | Y | Z | R



#### Case Study: Alpha* systems

Alpha* refers to a series of papers and associated techniques by DeepMind to play board games. We analyzed the whole series, from *AlphaGo* [33] (including the Fan and Lee versions, used against Fan Hui and Lee Sedol, respectively, and its latest version, *AlphaGo Master*, which won 60 straight online games against professional Go players), *AlphaGo Zero* [35] (a version created without using data from human games) and *AlphaZero* [34] (which uses an approach similar to AlphaGo Zero to master not just Go, but also chess and shogi).

Data: 

We have performed a bibliographical search to find all the papers that include experiments performed by Alpha* systems:

 

Code: 

* [R code]()

Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
Weka algorithms | X | Y | Z | R



#### Case Study: ImageNet

This case study aims to analyse state-of-the-art DNN architectures submitted for the ImageNet challenge over the last years, in terms of computational requirements (memory, parameters, operations count, inference time, power consumption, size, etc.) and performance (accuracy), as well as, if reported, data, knowledge, software, human attention, and calendar time. The purpose of this analysis is to stress the importance of these figures, which are essential to the measurement of AI progress.

Data: 

We have performed a bibliographical search to find all the papers that include experiments performed DNN systems/architectures which have addressed (and won!) the ImageNet challenge:


Code: 

* [R code]()

Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
Weka algorithms | X | Y | Z | R





### Machine Learning algorithms

#### Case Study: OpenML 

[OpenML](https://www.openml.org/) is an online machine learning platform for sharing and organizing data, machine learning algorithms and experiments. It is designed to create a frictionless, networked ecosystem, that you can readily integrate into your existing processes/code/environments, allowing people all over the world to collaborate and build directly on each other’s latest ideas, data and results, irrespective of the tools and infrastructure they happen to use.

Data has been gathered from the [OpenML Study 14](https://www.openml.org/s/14), a collaborative, reproducible benchmark. This study collects experiments from multiple researchers, run with different tools (mlr, scikit-learn, WEKA,...) and compares them all on a benchmark set of 100 public datasets (the OpenML-100). All algorithms were run with optimized (hyper)parameters using 200 random search iterations.

Data: 

Code: 

* OpenML [R API](https://github.com/openml/openml-r).
* [R code]()


Hierarchy | Tasks | Systems | Methods | #Results
--------- | ----- | ------- | ------- | --------
H | X | Y | Z | R



### Computer Chess Systems 

#### Case Study: (CCRL) Computer Chess Rating Lists


Engine vs engine chess testing. Web-scraped data from [CCRL](http://www.computerchess.org.uk/ccrl/). 

3 evaluation methodologies:

* **40/40**: Ponder off, General book (up to 12 moves), 3-4-5 piece EGTB. Time control: Equivalent to 40 moves in 40 minutes on Athlon 64 X2 4600+ (2.4 GHz), about 15 minutes on a modern Intel CPU.
* **40/4**: Ponder off, General book (up to 12 moves), 3-4-5 piece EGTB. Time control: Equivalent to 40 moves in 4 minutes on Athlon 64 X2 4600+ (2.4 GHz), about 1.5 minutes on a modern Intel CPU.
* **404FRC**: Shredder GUI, ChessGUI by Matthias Gemuh, Ponder off, 5-men EGTB, 128MB hash, random openings with switched sides. Time control: Equivalent to 40 moves in 4 minutes on Athlon 64 X2 4600+ (2.4 GHz), about 1.5 minutes on a modern Intel CPU.

Hierarchy | Tasks | Systems | Methods | #Results
--------- | ----- | ------- | ------- | --------
H | X | Y | Z | R


...

## :woman: Human

...

## :hear_no_evil: Animal (non-human)

...



# :hammer: Usage

### Database population

A easy way to to populate the database with data from new case studies...

### SQL queries

* ...
*
*
*
# 💾 Code (R)

* ...
*
*
*


# TODOs 

- [x] ...
- [ ] ...



# :orange_book: References

* Sankalp Bhatnagar, Anna Alexandrova, Shahar Avin, Stephen Cave, Lucy Cheke, Matthew Crosby, Jan Feyereis, Marta Halina, Bao Sheng Loe, Seán Ó hÉigeartaigh, Fernando Martínez-Plumed, Huw Price, Henry Shevlin, Adrian Weller, Alan Wineld, and José Hernández-Orallo, [*Mapping Intelligence: Requirements and Possibilities*](https://doi.org/10.1007/978-3-319-96448-5_13), In: Müller, Vincent C. (ed.), [Philosophy and Theory of Artificial Intelligence 2017](https://www.springer.com/gb/book/9783319964478), Studies in Applied Philosophy, Epistemology and Rational Ethics (SAPERE), Vol 44, ISBN 978-3-319-96447-8, Springer, 2018.

* Sankalp Bhatnagar, Anna Alexandrova, Shahar Avin, Stephen Cave, Lucy Cheke, Matthew Crosby, Jan Feyereis, Marta Halina, Bao Sheng Loe, Seán Ó hÉigeartaigh, Fernando Martínez-Plumed, Huw Price, Henry Shevlin, Adrian Weller, Alan Wineld, and José Hernández-Orallo, [*A First Survey on an Atlas of Intelligence*](http://users.dsic.upv.es/~flip/papers/Bhatnagar18_SurveyAtlas.pdf), Technical Report, 2018.




# :muscle: Credits

[A]I Collaboratory is created and maintained by [Fernando Martínez-Plumed](https://nandomp.github.io/) and [José Hernández-Orallo](http://josephorallo.webs.upv.es/).

*We're open to suggestions, feel free to message us or open an issue. Pull requests are also welcome!*

[A]I Collaboratory is powered by <a href="https://www.r-project.org">
    <img src="https://www.r-project.org/Rlogo.png"
      alt="R" width = "30"/>
  </a> &  <a href="https://www.mysql.com">
    <img src="https://www.mysql.com/common/logos/logo-mysql-170x115.png"
      alt="MySQL" width = "35"/>
  </a>


# :heart: Aknowledgements

European Commission's [HUMAINT](https://ec.europa.eu/jrc/communities/en/community/humaint) project within the [JRC's Centre for Advanced Studies](https://ec.europa.eu/jrc/en/research/centre-advanced-studies)

<div align="center">
<a href="https://ec.europa.eu/jrc/communities/en/community/humaint"><img src="https://ec.europa.eu/jrc/communities/sites/jrccties/themes/jrccities_subtheme/logo.png?sanitize=true&raw=true" alt="Example" width="100" />  <img src="https://ec.europa.eu/jrc/communities/sites/jrccties/files/styles/community_banner/public/banner_0.jpg?itok=Q15FvEkx?sanitize=true&raw=true" alt="Example" width="400" /></a>
</div>
