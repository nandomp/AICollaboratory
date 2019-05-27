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



:triangular_flag_on_post: **Table of contents**

* [Data](#file_folder-data)
	* [AI](#computer-ai)
		* [Games](#games)
			* [Arcade Learning Environment](#case-study-arcade-learning-environment-atari-2600-games)
			* [The General Video Game AI Competition](#case-study-arcade-learning-environment-atari-2600-games)
			* [Alpha* systems](#case-study-arcade-learning-environment-atari-2600-games)


			
# :file_folder: Data 

## :computer: AI

#### Games

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
* [Scalable trust-region method for deep reinforcement learning using Kronecker-factored approximation](https://arxiv.org/pdf/1708.05144.pdf)
* [IMPALA: Scalable Distributed Deep-RL with Importance Weighted Actor-Learner Architectures](https://arxiv.org/pdf/1802.01561.pdf)
* [Distributed Prioritized Experience Replay](https://arxiv.org/pdf/1803.00933.pdf)
* [Recurrrent Experience Replay in Distributed Reinforcement Learning](https://openreview.net/pdf?id=r1lyTjAqYX)


Figures: 

Hierarchy | Agents | Tasks | Methods | #Results
--------- | ------ | ----- | ------- | --------
Default | 27 | 57 | 41 | 1878 

Visualisation examples:

<div align="center">
<img src="https://github.com/nandomp/AICollaboratory/blob/master/Figures/AI_GAMES_ALE_progress.png" alt="AI Games (ALE) Progress"/>  
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

