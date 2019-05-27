library(readODS)
library(xlsx)

rnd.data <- readODS::read.ods(file="Data/AI/ALE/Papers ALE/[REACTOR] - hs&noop.ods", sheet = 1)
colnames(rnd.data) <- rnd.data[1,]
rnd.data <- rnd.data[-1,]


## generate CSV with data for ALE

rnd.data2 <- select(rnd.data, Game, RANDOM.noop, RANDOM.hs)

agent <- data.frame(agent = "random", agent_is= "Random Atari 2600 agent", hierarchy_belongs = "AI", source = "REACTOR", weight = 1, Aproach = "Random agent")
write.csv(agent, file = "agent_random_ALE.csv", row.names = F)

method <- data.frame(method = c("random hs", "random noop"), Procedure = c("hs", "noop"))
method$source <- c("REACTOR")
write.csv(method, file = "method_random_ALE.csv", row.names = F)

task <- data.frame(agent = select_all("task")$name, agent_is= "Atari 2600 game", hierarchy_belongs = "Playing Games", source = "Best Linear")
#task <- write.csv(task, file = "tasks_ALE.csv", row.names = F)
#task <- read.csv("ALEgames.csv")

results1 <- data.frame(agent= "random", task = rnd.data2$Game, method = "random hs", result = rnd.data2$RANDOM.hs)
results2 <- data.frame(agent= "random", task = rnd.data2$Game, method = "random noop", result = rnd.data2$RANDOM.noop)
results <- rbind(results1, results2)
results$metric <- "Score"
# write.csv(results, file = "results_random_ALE.csv", row.names = FALSE)

# ALE.games
# ALE.tech
# ALE.results


# ALE data

ALE.results <-read.csv("Data/AI/ALE/RAW Data/ALE_results.csv")
# ALE.tech <-readRDS("Data/AI/ALE/RAW Data/ALE_tech.rds")
ALE.tech <-read.xlsx("Data/AI/ALE/RAW Data/ALE_techniques.xlsx", sheetIndex = 1)
# ALE.games <- readRDS("Data/AI/ALE/RAW Data/ALE_games.rds")
ALE.games <- read.csv("Data/AI/ALE/tasks_ALE.csv")

ALE.tech$Approach_short


t <- select_all("agent")$name

sourceData <- read.csv("Data/AI/ALE/sources_ALE.csv")

agentDataALE <- data.frame(agent = ALE.tech$Approach_short, 
                        agent_is = "Deep Reinforcement Learning",
                        weight = 1,
                        hierarchy_belongs = "AI",
                        source = ALE.tech$Approach_short,
                        Date_Start = as.character(ALE.tech$Date_Start),
                        Date_End = as.character(ALE.tech$Date_End),
                        Authors = ALE.tech$Authors,
                        Approach = ALE.tech$Aproach,
                        Human_Data = ALE.tech$Human_Data,
                        #Replicability = as.character(as.logical(ALE.tech$Replicability)),
                        Replicability = ALE.tech$Replicability,
                        #Training_Time = ALE.tech$Training_time,
                        #Training_Time_Type = ALE.tech$Training_time_type,
                        HW = ALE.tech$HW,
                        # Parallelism = factor(ALE.tech$Parallelism, levels = c("No","Yes"), labels = c("FALSE", "TRUE")),
                        Parallelism = ALE.tech$Parallelism,
                        Workers = ALE.tech$Workers,
                        Hyperparameters = ALE.tech$Hyperparameters,
                        #Games_train_params = ALE.tech$Games_train_params,
                        Rewards = ALE.tech$Rewards)

agentDataALE <- unique(agentDataALE) 


# agentDataAI <- data.frame(agent = c('Deep Reinforcement Learning', 'Reinforcement Learning', 'Machine Learning', 'Artificial Intelligence'), 
#                           agent_is = c('Reinforcement Learning', 'Machine Learning', 'Artificial Intelligence', 'Default'),
#                           weight = 1,
#                           hierarchy_belongs = "Default",
#                           source = "Default")
                          



methodData <- data.frame(method = ALE.tech$EFFTech,
                         source = ALE.tech$Approach_short,
                         Procedure = ALE.tech$Procedure,
                         Games_Train_Params = ALE.tech$Games_train_params,
                         Frames_Train = ALE.tech$Frames_train,
                         Frames_Train_Type = ALE.tech$Frames_train_type,
                         Games_Test = ALE.tech$Games_test)
                        


taskData <- read.csv("tasks_ALE.csv")


nrow(ALE.results)
tech_select <-  select(ALE.tech, "EFFTech", "Approach_short")
levels(ALE.results$label)
levels(tech_select$EFFTech)


levels(ALE.results$label)[!(levels(ALE.results$label) %in% levels(tech_select$EFFTech))]
#  [1] "DDQN-PC" "MP-EB" 


tmp <- merge(ALE.results, tech_select, by.x = "label", by.y = "EFFTech")
results <- select(tmp, label, Approach_short, Game, value) ## what about "max_value"?
colnames(results) <- c("method", "agent", "task", "result")
results$metric <- "score"
resultData <- select(results, agent, task, method, result, metric)
nrow(resultData)


# write.csv(sourceData, file = "sources_ALE.csv", row.names = F)
write.csv(agentDataALE, file = "Data/AI/ALE/agents_DQN_ALE.csv", row.names = F)
# write.csv(agentDataAI, file = "agents_AI.csv", row.names = F)
write.csv(methodData, file = "Data/AI/ALE/methods_DQN_ALE.csv", row.names = F)
write.csv(resultData, file = "Data/AI/ALE/results_DQN_ALE.csv", row.names = F)




