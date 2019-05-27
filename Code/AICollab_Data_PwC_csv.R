source("AICollab_DB_funcs.R")

PwCdata <- readRDS("Data/AI/papersWithCode/PwC_data_clean.rds")

tasks <- select(PwCdata, category.1, task.1, task.2, task.3)
tasks.u <- unique(tasks)
nrow(PwCdata)
PwCdata <- filter(PwCdata, category.1 != "Playing Games")

PwCdata$sota.model <- sapply(PwCdata$sota.model, cleanSQLstring)
PwCdata$sota.title <- sapply(PwCdata$sota.title, cleanSQLstring)
PwCdata$sota.metric <- sapply(PwCdata$sota.metric, cleanSQLstring)
PwCdata$dataset.description <- sapply(PwCdata$dataset.description, cleanSQLstring)
PwCdata$dataset.name <- sapply(PwCdata$dataset.name, cleanSQLstring)
PwCdata$category.1 <- sapply(PwCdata$category.1, cleanSQLstring)

PwCdata$task.1 <- sapply(PwCdata$task.1, cleanSQLstring)
PwCdata$task.2 <- sapply(PwCdata$task.2, cleanSQLstring)
PwCdata$task.3 <- sapply(PwCdata$task.3, cleanSQLstring)

PwCdata$description.1 <- sapply(PwCdata$description.1, cleanSQLstring)
PwCdata$description.2 <- sapply(PwCdata$description.2, cleanSQLstring)
PwCdata$description.3 <- sapply(PwCdata$description.3, cleanSQLstring)

PwCdata$description.1 <- substr(PwCdata$description.1, 1, 512)
PwCdata$description.2 <- substr(PwCdata$description.2, 1, 512)
PwCdata$description.3 <- substr(PwCdata$description.3, 1, 512)

# sources --------------------------------------------------------------------------------------------------------------------------------------------------

sourcesPwC <- data.frame(name = PwCdata$sota.model,
                         link = PwCdata$sota.url,
                         description =  PwCdata$sota.title, 
                         date = PwCdata$sota.date)

sourcesPwC <- rbind(c("paperswithcode", "https://paperswithcode.com", "Papers with code", "01/12/2018"), sourcesPwC)
sourcesPwC <- unique(sourcesPwC)
sourcesPwC <- filter(sourcesPwC, name != "")
write.csv(sourcesPwC, "Data/AI/papersWithCode/sources_PwC.csv", row.names = F)

# agents ---------------------------------------------------------------------------------------------------------------------------------------------------

agentPwC <- data.frame(agent = PwCdata$sota.model, 
                           agent_is = "DeepNN",
                           weight = 1,
                           hierarchy_belongs = "AI",
                           source = PwCdata$sota.model)
agentPwC <- rbind(agentPwC, c("DeepNN", "Machine Learning", 1, "AI", "Default"))
tail(agentPwC)
nrow(agentPwC)
agentPwC <- unique(agentPwC)
nrow(agentPwC)
agentPwC <- filter(agentPwC, agent != "")
nrow(agentPwC)
write.csv(agentPwC, "Data/AI/papersWithCode/agents_PwC.csv", row.names = F)


# tasks ----------------------------------------------------------------------------------------------------------------------------------------------------

tasks <- select(PwCdata, category.1, task.1, task.2, task.3, description.1, description.2, description.3)
tasks.u <- unique(tasks)

temp <- data.frame()
for(i in 1:nrow(tasks.u)){
  if (!is.na(tasks.u$task.3[i])){
    temp <- rbind(temp, c(task = tasks.u$task.3[i], 
                           task_is = tasks.u$task.2[i],
                           weight = 1,
                           hierarchy_belongs = tasks.u$category.1[i],
                           source = "paperswithcode",
                           decription = tasks.u$description.3[i]))    
    
  }
  
}
for(i in 1:nrow(tasks.u)){
  if (!is.na(tasks.u$task.2[i])){
    temp <- rbind(temp, c(task = tasks.u$task.2[i], 
                          task_is = tasks.u$task.1[i],
                          weight = 1,
                          hierarchy_belongs = tasks.u$category.1[i],
                          source = "paperswithcode",
                          decription = tasks.u$description.2[i]))       
  }
}

for(i in 1:nrow(tasks.u)){
  if (!is.na(tasks.u$task.1[i])){
    temp <- rbind(temp, c(task = tasks.u$task.1[i], 
                          task_is = "AI task",
                          weight = 1,
                          hierarchy_belongs = tasks.u$category.1[i],
                          source = "paperswithcode",
                          decription = tasks.u$description.1[i]))       
  }
}
colnames(temp) <- c("task","task_is", "weight", "hierarchy_belongs", "source", "Description")
nrow(temp)
temp <- unique(temp)
nrow(temp)

temp2 <- data.frame() 
for (i in 1:nrow(PwCdata)){
  if (!is.na(PwCdata$dataset.name[i])){
    ifelse(!is.na(PwCdata$task.3[i]), getTask <- c(PwCdata$task.3[i],PwCdata$description.3[i]), 
                      ifelse(!is.na(PwCdata$task.2[i]), getTask <- c(PwCdata$task.2[i],PwCdata$description.2[i]), 
                             getTask <- c(PwCdata$task.1[i],PwCdata$description.1[i])))

    temp2 <- rbind(temp2, c(task = PwCdata$dataset.name[i], 
                          task_is = getTask[1],
                          weight = 1,
                          hierarchy_belongs = PwCdata$category.1[i],
                          source = "paperswithcode",
                          decription = getTask[2])
                   )  
  }
}

colnames(temp2) <- c("task","task_is", "weight", "hierarchy_belongs", "source", "Description")
nrow(temp2)
temp2 <- unique(temp2)
nrow(temp2)

taskPwC <- rbind(temp, temp2)
nrow(taskPwC)

write.csv(taskPwC, "Data/AI/papersWithCode/tasks_PwC.csv", row.names = F)


# methods ----------------------------------------------------------------------------------------------------------------------------------------------------

methodPwC <- data.frame(method = PwCdata$sota.model,
                         source = PwCdata$sota.model,
                        description = PwCdata$sota.title)



nrow(methodPwC)
methodPwC <- unique(methodPwC)
nrow(methodPwC)
methodPwC <- filter(methodPwC, method != "")
nrow(agentPwC)

write.csv(methodPwC, "Data/AI/papersWithCode/methods_PwC.csv", row.names = F)


# results ----------------------------------------------------------------------------------------------------------------------------------------------------

resultPwC <- data.frame(agent = PwCdata$sota.model, 
                        task = PwCdata$dataset.name, 
                        method = PwCdata$sota.model, 
                        result = PwCdata$sota.values,
                        metric = PwCdata$sota.metric)


nrow(resultPwC)
resultPwC <- unique(resultPwC)
nrow(resultPwC)
resultPwC <- filter(resultPwC, agent != "")
nrow(resultPwC)

write.csv(resultPwC, "Data/AI/papersWithCode/results_PwC.csv", row.names = F)


