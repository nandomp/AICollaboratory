# AICollaboratory

This project is conceived as a pioneering initiative for the development of a collaboratory for the analysis, evaluation, comparison and classification of  AI paradigms and systems. It will start by incorporating approaches, data, knowledge, measurements and evaluations, within the machine learning, (deep) reinforcement learning and interactive learning paradigms in the field of A(G)I, due to the priorities and particular needs in these areas. The framework will allow the study, analysis and evaluation, in a complete and unified way, of a representative selection of these sort of A(G)I systems, covering, in the longer term, the current and future panorama of the A(G)I. 

**Table of contents**
 
* [Infraestructure](#infraestructure)
* [DataBase](#database)
	* [ERR diagram](#mysql-err-diagram)
	* [SQL Create script](#mysql-sql-create-script)
* [Data](#data)
	* [AI](#AI)
		* [Deep Learning Architectures](#deep-learning-architectures)
		* [Machine Learning algorithms](#machine-learning-algorithms)
		* [Computer Chess Systems](#computer-chess-systems)
	* [Human](#human)
	* [Animal](#animal-non-human)



# Infraestructure

This repository comprise an:

* **Inventory of intelligent systems**,  which incorporates information on current, past and future AI systems.

* **Repository of experimentation**, recording the results thereof for various tests and benchmarks.

# DataBase

* **Task**:
* **Agents**:
* **Method**:
* **Results**:


## MySQL ERR diagram

![ERR](https://github.com/nandomp/AICollaboratory/blob/master/MySQL/Atlas_ERR_v1.png)

## MySQL SQL Create script

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







# TODOs 

- [x] Definition of repository requirements
- [ ] Inventory of A(G)I systems








# Aknowledgements

European Commission's [HUMAINT](https://ec.europa.eu/jrc/communities/en/community/humaint) project within the [JRC's Centre for Advanced Studies](https://ec.europa.eu/jrc/en/research/centre-advanced-studies)

<a href="https://ec.europa.eu/jrc/communities/en/community/humaint"><img src="https://ec.europa.eu/jrc/communities/sites/jrccties/themes/jrccities_subtheme/logo.png?sanitize=true&raw=true" alt="Example" width="100" /><img src="https://ec.europa.eu/jrc/communities/sites/jrccties/files/styles/community_banner/public/banner_0.jpg?itok=Q15FvEkx?sanitize=true&raw=true" alt="Example" width="400" /></a>