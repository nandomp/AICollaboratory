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


This project is conceived as a pioneering initiative for the development of a collaboratory for the analysis, evaluation, comparison and classification of [A]I systems. This project will create a unifying setting that incorporates data, knowledge and measurements to characterise all kinds of intelligence, including humans, non-human animals, AI systems, hybrids and collectives thereof. The first prototype of the collaboratory will make it possible to study, analysis and evaluation, in a complete and unified way, of a representative selection of these sort of [A]I systems, covering, in the longer term, the current and future intelligence landscape. 


:triangular_flag_on_post: **Table of contents**


* [Infraestructure](#page_with_curl-infraestructure) 
* [Design](#pencil2-design)
	* [Database](#books-database)
		* [Multidemensional Schema](#multidimensional-schema)
		* [Implementation](#implementation)
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
	* [Data population](#data-population)
	* [Data querying](#data-querying)
* [Code](#-code-r)
	* [Database manipulation](#database-manipulation)
	* [Data scraping](#data-scraping)
* [References](#orange_book-references)
* [TODOs](#todos)
* [Credits](#muscle-credits)
* [Acknowledgements](#heart-aknowledgements)

# :page_with_curl: Infraestructure

The collaboratory will integrate open data and knowledge in four domains:


* **Inventory of intelligent systems**,  which incorporates information about current, past and future systems, including hybrid and collectives, natural or artificial, from human professions to AI desiderata. They will be aggregated from individuals to species, groups or organisations, with populations and distributions over them.

* **Behavioural Test Catalogue**, which will integrate a series of behavioural tests, the dimensions they measure and for which kinds of systems, the possible interfaces and testing apparatus. The catalogue, largely automated and accessible online, will help researchers apply or reproduce the tests.

* **Repository of experimentation**, which will record the results (measurements) of a wide range of systems (natural, artificial, hybrid or collective) for several tests and benchmarks, as the main data source of the repository. Data will be contributed from scientific papers, experiments, psychometric repositories, AI/robotic competitions, etc. 

* **Constructs of Intelligence Corpus**, which will integrate latent and hierarchical models, taxonomical criteria, ontologies, mappings from low to high-level cognition, as well as theories of intelligence.

On top of the infrastructure there will be a series of exploitation tools where actual data science will take place, following state-of-the-art data exploitation tools but customised to the potential users of the repository:

* **Querying tools**: query languages and interfaces for powerful (dis)aggregation and cross-comparisons, reuse of predefined multidimensional filters, trend analysis along time, heuristic search, etc.

* **Data analysis tools**: a set of modelling tools from statistics and machine learning, integrating off-the-shelf analytical packages and specific analytical tools.

* **Visualisation tools**: a set of interactive interfaces to perform projections, topological representations, depicting trajectories, visual categorisations, iconic representations, conceptual maps, ...

* **Collaborative tools**: a platform such that new hypotheses, projects, educational material and research papers can evolve from the repository.


# :pencil2: Design

## :books: Database

### Multidimensional Schema

Multidimensional perspective (over a relational database):

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


#### WHAT dimension (Behavioural Test Catalogue)

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

#### WHO dimension (Cognitive System Inventory)

* **Agent**: Systems, architectures, algorithms, etc.

Entity tables: 

* **AGENT**: system, algorithm, approach, entity, etc.
* **SOURCE**: description, author, year, etc.
* **HIERARCHY**: agent hierarchy.
* **ATTRIBUTES**: parallelism, hiperparameters, approach, batch, fit, etc.

Many-tomany relationships: 

* **_IS**: AGENT belongs to FAMILY in SOURCE (PK: Ag x F x S)
* **_HAS**: AGENT possess ATTRIBUTES (PK: Ag x A)
* **_BELONGS_TO**: AGENT belongs to HIERARCHY (PK: Ag x H)

Examples of rows:

```
AGENT "RAINBOW" _IS a "Deep Learning architecture" according to SOURCE "Hessel et al., 2013"
AGENT "weka.PART(1)_65" _IS "PART" technique according to SOURCE "OpenML".
AGENT "Human Atari gamer" IS " Homo sapiens" according to SOURCE "Bellamare et al., 2013" and _BELONGS_TO the HIERARCHY "Hominoidea"
```

#### HOW dimension (Experimentation Repository)

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

#### Fact table

Measures:

* **Results**: score, accuracy, kappa, f.measure, recall, RMSE, etc.

Examples of rows:

```
"DDQN-v3.4 AGENT", using a "Dual DQN" approah, "human data" augmentation, "no" parallelism, and the hyperparameters of "Mnih et al. 2015", 
is evaluated over the TASK "Moctezuma" game which belongs to the benchmark "ALE 1.0",  
using as evaluation METHOD "100,000" episodes, "57" test games and "200M" training frames,
obtains a measured score of "23.3"
```

### Implementation

We use a free, lightweight, open source [MySQL](https://www.mysql.com/) database.

#### MySQL ERR diagram

![ERR](https://github.com/nandomp/AICollaboratory/blob/master/MySQL/Atlas_ERR_v1.png)

#### MySQL SQL Create script

[SQL script](https://github.com/nandomp/AICollaboratory/blob/master/MySQL/Atlas_schema_v1.sql)







# :file_folder: Data 

## :computer: AI

### Deep Learning Architectures

#### Case Study: Arcade Learning Environment (Atari 2600 games)

The Arcade Learning Environment (ALE) was introduced by [Mnih et al, 2015](https://www.cs.toronto.edu/~vmnih/docs/dqn.pdf), after compiling a good number of games for Atari 2600, a popular console of the late 1970s and most of the 1980s. The simplicity of the games from today’s perspective and the use of a visual input of 210 × 160 RGB pixels at 60Hz makes the benchmark sufficiently rich (but still simple) for the AI algorithms of today. After [Mnih et al, 2015](https://www.cs.toronto.edu/~vmnih/docs/dqn.pdf) achieved superhuman performance for many of the ALE games, the benchmark became very popular in AI. There are so many platforms, techniques and papers using ALE today that the results on this benchmark are usually analysed when talking about breakthroughs and progress in AI.

Data: 

We have performed a bibliographical search to find all the papers that include experiments with a wide range of ALE games:


* [Investigating Contingency Awareness Using Atari 2600 Games](https://www.aaai.org/ocs/index.php/AAAI/AAAI12/paper/view/5162/5493)
* [The Arcade Learning Environment: An Evaluation Platform for General Agents](https://arxiv.org/abs/1207.4708v1)
* [Playing Atari with Deep Reinforcement Learning](https://arxiv.org/abs/1312.5602)
* [Human-level control through deep reinforcement learning](https://web.stanford.edu/class/psych209/Readings/MnihEtAlHassibis15NatureControlDeepRL.pdf)
* [Massively Parallel Methods for Deep Reinforcement Learning](https://arxiv.org/abs/1507.04296)
* [Deep Reinforcement Learning with Double Q-learning v.1](https://arxiv.org/abs/1509.06461v1)
* [Deep Reinforcement Learning with Double Q-learning v.3](https://arxiv.org/abs/1509.06461v3)
* [Prioritized Experience Replay](https://arxiv.org/abs/1511.05952)
* [Dueling Network Architectures for Deep Reinforcement Learning v.1](https://arxiv.org/abs/1511.06581v1)
* [Dueling Network Architectures for Deep Reinforcement Learning v.3](https://arxiv.org/abs/1511.06581v3)
* [Asynchronous Methods for Deep Reinforcement Learning](https://arxiv.org/abs/1602.01783)
* [Learning functions across many orders of magnitudes](https://arxiv.org/abs/1602.07714v1)
* [Unifying Count-Based Exploration and Intrinsic Motivation](https://arxiv.org/abs/1606.01868)
* [#Exploration: A Study of Count-Based Exploration for Deep Reinforcement Learning](https://arxiv.org/abs/1611.04717)
* [Count-Based Exploration with Neural Density Models](https://arxiv.org/abs/1703.01310v1)
* [Evolution Strategies as a Scalable Alternative to Reinforcement Learning](https://arxiv.org/abs/1703.03864v1)
* [The Reactor: A fast and sample-efficient Actor-Critic agent for Reinforcement Learning](https://openreview.net/pdf?id=rkHVZWZAZ)
* [Count-Based Exploration in Feature Space for Reinforcement Learning](https://arxiv.org/abs/1706.08090)
* [A Distributional Perspective on Reinforcement Learning](https://arxiv.org/abs/1707.06887)
* [Rainbow: Combining Improvements in Deep Reinforcement Learning](https://arxiv.org/abs/1710.02298)

Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
Default | 27 | 57 | 41 | 1878 

Visualisation examples:

<div align="center">
<img src="https://github.com/nandomp/AICollaboratory/blob/master/Figures/ALE_SCOREvsTIME.png" alt="median SCORE vs TIME" width="700" />  
</div>


#### Case Study: The General Video Game AI Competition

The [General Video Game AI](http://www.gvgai.net/) (GVGAI) competition is a benchmark which comprises a large number of real-time 2D grid games such as puzzles, shooters, classic arcades and many more. The games can also differ in the way players are able to interact with the environment (actions), the scoring systems, the objects that are part of a game or the conditions to end the game. Unlike ALE, GVGAI was created to avoid participants tailoring their submissions to a few well-known games. Instead, participants are pitted against a number of unseen games. Another difference is that controllers are able to access an abstract representation of the game state (so complex perception is not needed) as well
as a simulator so that (look-ahead) tree search algorithms and other planning approaches can be used. This environment is usually addressed by non-deterministic learning algorithms such as Monte-Carlo Tree Search (MCTS) and Evolutionary Algorithms (EA). Still as of yet, there has not been an approach able to consistently be successful on all games, showing that all the techniques used have their strengths and weaknesses.

Data: 

We have gathered the scores of 49 games and the 23 controllers (agents) that were submitted to the 2015 GVGAI competition [31]. Each game has 5 levels,
and each level was attempted 5 times. This makes a total of 23×49×5×5 = 28175 trials. For each trial the data includes the win/loss achieved by the controller.

Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
H | X | Y | Z | R



#### Case Study: Alpha* systems

Alpha* refers to a series of papers and associated techniques by DeepMind to play board games. We analyzed the whole series, from *AlphaGo* [33] (including the Fan and Lee versions, used against Fan Hui and Lee Sedol, respectively, and its latest version, *AlphaGo Master*, which won 60 straight online games against professional Go players), *AlphaGo Zero* [35] (a version created without using data from human games) and *AlphaZero* [34] (which uses an approach similar to AlphaGo Zero to master not just Go, but also chess and shogi).

Data: 

We have performed a bibliographical search to find all the papers that include experiments performed by Alpha* systems:


Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
H | X | Y | Z | R



#### Case Study: ImageNet

This case study aims to analyse state-of-the-art DNN architectures submitted for the ImageNet challenge over the last years, in terms of computational requirements (memory, parameters, operations count, inference time, power consumption, size, etc.) and performance (accuracy), as well as, if reported, data, knowledge, software, human attention, and calendar time. The purpose of this analysis is to stress the importance of these figures, which are essential to the measurement of AI progress.

Data: 

We have performed a bibliographical search to find all the papers that include experiments performed DNN systems/architectures which have addressed (and won!) the ImageNet challenge:

Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
H | X | Y | Z | R





### Machine Learning algorithms

#### Case Study: OpenML 

[OpenML](https://www.openml.org/)  is an online machine learning platform where researchers can access open data, download and upload data sets, share their machine learning tasks and experiments and organize them online to work and collaborate with other researchers. It is designed to create a frictionless, networked ecosystem, that you can readily integrate into your existing processes/code/environments, allowing people all over the world to collaborate and build directly on each other’s latest ideas, data and results, irrespective of the tools and infrastructure they happen to use.

Data: 

Data has been gathered from the [OpenML Study 14](https://www.openml.org/s/14), a collaborative, reproducible benchmark. This study collects experiments from multiple researchers, run with different tools (mlr, scikit-learn, WEKA,...) and compares them all on a benchmark set of 100 public datasets (the OpenML-100). All algorithms were run with optimized (hyper)parameters using 200 random search iterations.

We have used the [R interface to OpenML](https://github.com/openml/openml-r) which allows the downloading and uploading of data sets, tasks, flows and runs.

Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
Weka algorithms | 1315 | 90 | 90 | 424235
mlr algorithms | 1597 | 92 | 92 | 118190
Sklearn algorithms | 3326 | 92 | 92 | 68667
openML algorithms | 31 | 90 | 90 | 1132
RM algorithms | 12 | 3 | 3 | 169

Visualisation examples:

<div align="center">
<img src="https://github.com/nandomp/AICollaboratory/blob/master/Figures/openML_AUCvsACC.png" alt="ACC vs AUC" width="700" />  <img src="https://github.com/nandomp/AICollaboratory/blob/master/Figures/openML_pareto_ACCvsTIME.png" alt="Pareto Frontier (ACC vs Training TIME)" width="700" /></a>
</div>



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

### Case Study: CHC related data

### ...




## :hear_no_evil: Animal (non-human)

### Case Study: Animal-AI Olympics

### ...





# 💾 Code (R)

### Database manipulation
* <code>AICollab_DB_funcs.R</code>
* <code>AICollab_DB_populate.R</code>

### Data scraping
* <code>AICollab_Data_openML.R</code>






# :hammer: Usage

## Database population

A easy way to to populate the database with data from new case studies is to generate four flat tables (.csv) containing info about sources, agents, methods and results and then use:


<code>insert_Atlas(sourceTable, agentTable, methodTable, taskTable, resultsTable)</code>

**Sources**

Description:

*name* can be found in *link* and is described as follows (*description*).

Required fields:

* *name*: identifier
* *link*: url, DOI, etc.
* *description*: further information

Example: 

name | link | description 
---- | ---- | -----------
Best Linear	| https://arxiv.org/abs/1207.4708v1	| The Arcade Learning Environment: An Evaluation Platform for General Agents
DQN	| https://arxiv.org/abs/1312.5602 | Playing Atari with Deep Reinforcement Learning
Gorilla | https://arxiv.org/abs/1507.04296 | Massively Parallel Methods for Deep Reinforcement Learning
... | ... | ...


**Tasks**

Description:

A *task* is (*weight*) *taks_is* according to *source*, belongs to *hierarchy_belongs*, and has *att_1* ... *att_n* attributes.

Required fields:

* *task*: TAKS identifier
* *task_is*:  X (*task*) is/belongs to Y (*task_is*) according to Z (*source*)
* *weight*: X (*task*) is Y (*task_is*) to some extent (weight between 0 and 1)
* *hierarchy_belongs*: HIERARCHY the task belongs to (if not in the database, it will be created)
* *source*: name of the SOURCE.
* *att_1* ... *att_n*: descriptive attributes (as many as necessary)

task | task_is | weight | hierarchy_belongs | source | Year | Genre | Notes
---- | ------- | ------ | ----------------- | ------ | ---- | ----- | ----- 
Alien | Atari 2600 game | 1 | Default | Best Linear | 1982 | Action | 
Amidar | Atari 2600 game | 1 | Default | Best Linear | 1982 | Action | licensed by Konami
...


**Agents**

Description:

An *agent* is (*weight*) *agent_is* according to *source*, belongs to *hierarchy_belongs*, and has *att_1* ... *att_n* attributes.

Required fields:

* *agent*: AGENT identifier
* *agent_is*:  X (*agent*) is/belongs to Y (*agent_is*) according to Z (*source*)
* *weight*: X (*agent*) is Y (*agent_is*) to some extent (weight between 0 and 1)
* *hierarchy_belongs*: HIERARCHY the agent belongs to (if not in the database, it will be created)
* *source*: name of the SOURCE.
* *att_1* ... *att_n*: descriptive attributes (as many as necessary)

agent | agent_is | weight | hierarchy_belongs | source | Date_Start | Date_End | Authors | Approach | Human_Data | Replicability | HW | Parallelism | Workers | Hyperparameters | Rewards
----- | -------- | ------ | ----------------- | ------ | ---------- | -------- | ------- | -------- | ---------- | ------------- | -- | ----------- | ------- | --------------- | -------
DQN | Deep Reinforcement Learning | 1 | Default | DQN | 2013-12-19 | 2013-12-19 | 7 | DQN | Yes | 1 | GPU | No | 1 | Learned | Normalised
Gorilla | Deep Reinforcement Learning | 1 | Default | Gorilla | 2015-07-15 | 2015-07-15 | 14 | DQN | Reused | 1 | GPU | Yes | 100 | Learned | Normalised
...

**Methods**

Description:

A testing procedure *method* is described in *source* having the following *att_1* ... *att_n* attributes.

Required fields:

* *method*: METHOD identifier
* *source*: name of the SOURCE.
* *att_1* ... *att_n*: descriptive attributes (as many as necessary)

method | source | Procedure | Games_Train_Params | Frames_Train | Frames_Train_Type | Games_Test
------ | ------ | --------- | ------------------ | ------------ | ----------------- | ---------- 
DQN best | DQN | Other | 7 | 50 | M | 7
Gorila | Gorilla | hs | 5 | 200 | M | 49
...


**Results**

Description:

An *agent* obtains *result* (*metric*) in *task* using the testing procedure *method*

Required fields:

* *agent*: AGENT identifier
* *task*: name of the SOURCE.
* *method* ... *att_n*: descriptive attributes (as many as necessary)

agent | task | method | result | metric
----- | ---- | ------ | ------ | ------
DQN | Beam Rider | DQN best | 5184 | score
DQN | Breakout | DQN best | 225 | score
DQN | Enduro | DQN best | 661 | score
DQN | Pong | DQN best | 21 | score
Gorilla | Alien | Gorila | 813.5 | score
Gorilla | Amidar | Gorila | 189.2 | score
Gorilla | Assault | Gorila | 1195.8 | score
Gorilla | Asterix | Gorila | 3324.7 | score
...






## Data querying

Some examples...





# :orange_book: References

* Sankalp Bhatnagar, Anna Alexandrova, Shahar Avin, Stephen Cave, Lucy Cheke, Matthew Crosby, Jan Feyereis, Marta Halina, Bao Sheng Loe, Seán Ó hÉigeartaigh, Fernando Martínez-Plumed, Huw Price, Henry Shevlin, Adrian Weller, Alan Wineld, and José Hernández-Orallo, [*Mapping Intelligence: Requirements and Possibilities*](https://doi.org/10.1007/978-3-319-96448-5_13), In: Müller, Vincent C. (ed.), [Philosophy and Theory of Artificial Intelligence 2017](https://www.springer.com/gb/book/9783319964478), Studies in Applied Philosophy, Epistemology and Rational Ethics (SAPERE), Vol 44, ISBN 978-3-319-96447-8, Springer, 2018.

* Sankalp Bhatnagar, Anna Alexandrova, Shahar Avin, Stephen Cave, Lucy Cheke, Matthew Crosby, Jan Feyereis, Marta Halina, Bao Sheng Loe, Seán Ó hÉigeartaigh, Fernando Martínez-Plumed, Huw Price, Henry Shevlin, Adrian Weller, Alan Wineld, and José Hernández-Orallo, [*A First Survey on an Atlas of Intelligence*](http://users.dsic.upv.es/~flip/papers/Bhatnagar18_SurveyAtlas.pdf), Technical Report, 2018.




# :muscle: Credits

[A]I Collaboratory is created and maintained by [Fernando Martínez-Plumed](https://nandomp.github.io/) and [José Hernández-Orallo](http://josephorallo.webs.upv.es/).

[A]I Collaboratory is aligned with the [Kinds of Intelligence](http://lcfi.ac.uk/projects/kinds-of-intelligence/) programme and their atlas of intelligence initiative (see references above).

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
<a href="https://ec.europa.eu/jrc/communities/en/community/humaint"><img src="https://ec.europa.eu/jrc/communities/sites/jrccties/themes/jrccities_subtheme/logo.png?sanitize=true&raw=true" alt="CE" width="100" />  <img src="https://ec.europa.eu/jrc/communities/sites/jrccties/files/styles/community_banner/public/banner_0.jpg?itok=Q15FvEkx?sanitize=true&raw=true" alt="Humaint" width="400" /></a>
</div>

[Vicerrectorado de lnvestigación, lnnovación y Transferencia](http://www.upv.es/entidades/VIIT/), [Universitat Politècnica de València](http://www.upv.es) (PAID-06-18)

<div align="center">
<a href="https://ec.europa.eu/jrc/communities/en/community/humaint"><img src="https://www.upv.es/perfiles/pas-pdi/imagenes/MarcaUPV50a_color.jpg" alt="UPV" width="300" /></a>
</div>
