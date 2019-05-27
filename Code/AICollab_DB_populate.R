# -----------------------------------------------------------------------------------------------------------------------
#
# This is R code for the following paper/project:
#
#  - [A]I Collaboratory (https://github.com/nandomp/AICollaboratory) 
#
# This code implements: 
#
#  - Data straction from OpenML (given a specific study) 
#
# This code has been developed by
#   FERNANDO MARTINEZ-PLUMED, UNIVERSITAT POLITECNICA DE VALENCIA, SPAIN
#   fmartinez@dsic.upv.es
#
# LICENCE:
#   GPL
#
# VERSION HISTORY:
#  - V.1.0    11 Jan 2019. 
#
# FUTURE FEATURES:
#
# -----------------------------------------------------------------------------------------------------------------------

# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# Packages
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------

source("AICollab_DB_funcs.R")
# db <- connectAtlasDB()
# db
# dbDisconnect(db)

# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------

# insert data Atlas
insert_Atlas <- function(sourceTable, agentTable, methodTable, taskTable, resultsTable){
  insert_source(sourceTable)
  ids_agent <- insert_agent(agentTable)
  ids_method <- insert_method(methodTable)
  ids_task <- insert_task(taskTable)
  insert_resuts(resultsTable, ids_agent, ids_task, ids_method)
}


# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# Script to insert data
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------

# DELETE ALL DATA
# -----------------------------------------------------------------------------------------------------------------------

delete_Atlas()

# ALE DATA 
# -----------------------------------------------------------------------------------------------------------------------

path = "Data/AI/ALE/"
files = list.files(path, pattern = "*.csv")

# Sources ALE
sourceTable <- fread(file = paste0(path,"sources_ALE.csv"))
insert_source(sourceTable)
# AI agents
agentTable <- fread(file = paste0(path,"agents_AI.csv"))
ids_agent <- insert_agent(agentTable)

### DQN DATA ---------------------------------------------------------------

agentTable <- fread(file = paste0(path,"agents_DQN_ALE.csv"))
methodTable <- fread(file = paste0(path,"methods_DQN_ALE.csv"))
taskTable <- fread(file = paste0(path,"tasks_ALE.csv"))
resultsTable <- fread(file = paste0(path,"results_DQN_ALE.csv"))

insert_Atlas(sourceTable, agentTable, methodTable, taskTable, resultsTable)

### Random DATA ---------------------------------------------------------------

agentTable = fread(file = "Data/AI/ALE/agents_random_ALE.csv")
taskTable = fread(file = "Data/AI/ALE/tasks_ALE.csv")
methodTable = fread(file = "Data/AI/ALE/methods_random_ALE.csv")
resultsTable = fread(file = "Data/AI/ALE/results_random_ALE.csv")
insert_Atlas(sourceTable, agentTable, methodTable, taskTable, resultsTable)

### Human DATA ---------------------------------------------------------------

sourceTableLinnean = data.frame(name = "Linnaean taxonomy", link= "https://en.wikipedia.org/wiki/Ape", description = "Linnaeus, 1758", date = "01/01/1758")
insert_source(sourceTableLinnean)

agentTable = fread(file = "Data/AI/ALE/agents_human_ALE.csv")
taskTable = fread(file = "Data/AI/ALE/tasks_human_ALE.csv")
methodTable = fread(file = "Data/AI/ALE/methods_human_ALE.csv")
resultsTable = fread(file = "Data/AI/ALE/results_human_ALE.csv")

insert_source(sourceTable)
ids_agent <- insert_agent(agentTable)
ids_method <- insert_method(methodTable)
ids_task <- insert_task(taskTable)
insert_resuts(resultsTable, ids_agent, ids_task, ids_method)

# insert_Atlas(sourceTable, agentTable, methodTable, taskTable, resultsTable)




# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------


# PapersWithCode DATA 
# -----------------------------------------------------------------------------------------------------------------------
# setwd("F:/OneDrive - UPV/Rworks/AtlasAI")

path = "Data/AI/papersWithCode/"
files = list.files(path, pattern = "*.csv")

sourceTable <- fread(file = paste0(path,"sources_PwC.csv"))
agentTable <- fread(file = paste0(path,"agents_PwC.csv"))
methodTable <- fread(file = paste0(path,"methods_PwC.csv"))
taskTable <- fread(file = paste0(path,"tasks_PwC.csv"))
resultsTable <- fread(file = paste0(path,"results_PwC.csv"))

#Some problems with white spaces and MySQL
sourceTable<- data.frame(lapply(sourceTable, trimws), stringsAsFactors = FALSE)
agentTable<- data.frame(lapply(agentTable, trimws), stringsAsFactors = FALSE)
methodTable<- data.frame(lapply(methodTable, trimws), stringsAsFactors = FALSE)
taskTable<- data.frame(lapply(taskTable, trimws), stringsAsFactors = FALSE)
resultsTable<- data.frame(lapply(resultsTable, trimws), stringsAsFactors = FALSE)

insert_source(sourceTable)
ids_agent <- insert_agent(agentTable)
ids_method <- insert_method(methodTable)
ids_task <- insert_task(taskTable)
insert_resuts(resultsTable, ids_agent, ids_task, ids_method)

# insert_Atlas(sourceTable, agentTable, methodTable, taskTable, resultsTable)




# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------

# OpenML DATA (after sourcing "AICollab_Data_openML.R")
# ------------------------------------------------------------------------------------------------------------

# Read tasks study_14
study14 <- readRDS("Data/AI/openML/_other_study14_openML.rds")
allTasks <- study14$task.id

# Generic Source (openML)
source_generic = data.frame(name = "openML", link= "https://www.openml.org", description = "The openML machine learning repository")
insert_source(source_generic)

for (i  in 1:length(allTasks)){
  
  t = allTasks[i]

  # For each task in OpenML (it includes a dataset and a wide variety of runs/evaluaions of a number of flows (algorithms) with different setups)
  require(OpenML)
  task_temp <- getOMLTask(task.id = t)
  d <- task_temp$input$data.set$desc$id

  source_dataset <- readRDS(paste0("Data/AI/openML/source_d_",d,"_openML.rds"))
  insert_source(source_dataset)
  
  tasK_dataset <- readRDS(paste0("Data/AI/openML/task_d_",d,"_openML.rds"))
  ids_task <- insert_task(tasK_dataset)
  
  
  
  source_method <- readRDS(paste0("Data/AI/openML/source_t_",t,"_openML.rds"))
  insert_source(source_method)
  
  method_task <- readRDS(paste0("Data/AI/openML/method_t_",t,"_openML.rds"))
  ids_method <- insert_method(method_task)
  
  
  
  sources_ <- readRDS(paste0("Data/AI/openML/sources_t_",t,"_openML.rds"))
  agents_ <- readRDS(paste0("Data/AI/openML/agents_t_",t,"_openML.rds"))
  results_ <- readRDS(paste0("Data/AI/openML/results_t_",t,"_openML.rds"))
  
  for(i in 1:length(agents_)){
    
    insert_source(sources_[[i]])
    ids_agent = insert_agent(agents_[[i]])
    
    print("Inserting Results...")
    for (j in 1:length(results_[[i]])){
      if (!is.null(results_[[i]][j][[1]])){
        insert_resuts(results_[[i]][j], ids_agent, ids_task, ids_method)
      }
    }
    
  }
  
}
