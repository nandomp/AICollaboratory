# -----------------------------------------------------------------------------------------------------------------------
#
# This is R code for the following paper/project:
#
#  - [A]I Collaboratory (https://github.com/nandomp/AICollaboratory) 
#
# This code implements: 
#
#  - Data extraction from OpenML (given a specific study) 
#
# This code has been developed by
#   FERNANDO MARTINEZ-PLUMED, UNIVERSITAT POLITECNICA DE VALENCIA, SPAIN
#   fmartinez@dsic.upv.es
#
# LICENCE:
#   GPL
#
# VERSION HISTORY:
#  - V.1.0    10 Jan 2019. 
#
# FUTURE FEATURES:
#
# -----------------------------------------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# Packages
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------

options("scipen"=1000000)
options( java.parameters = "-Xmx8g")

source("AICollab_DB_funcs.R")

.lib<- c("dplyr","reshape2", "OpenML")
.inst <- .lib %in% installed.packages()
if (length(.lib[!.inst])>0) install.packages(.lib[!.inst], repos=c("http://rstudio.org/_packages", "http://cran.rstudio.com")) 
lapply(.lib, require, character.only=TRUE)

setOMLConfig(apikey = "c1994bdb7ecb3c6f3c8f3b35f4b47f1f")
path = "Data/AI/openML/"

# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# Functions 
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------

mySave <- function(x,file, path = "Data/AI/openML/"){
  saveRDS(x,paste0(path,file,".rds"))
  #write.csv(x, paste0(path,file,".csv"), row.names = F)
}

mymax <- function(x){
  y <- max(x, na.rm = T)
  if (is.infinite(y)){
    y <- NA
  }
  return(y)
}
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# Download Data
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------

# Get "high quality" data sets from OpenML
tasks = listOMLTasks(tag = "study_14") #Supervised Classification, 92 datasets
length(unique(tasks$data.id))
mySave(tasks, "_other_study14_openML")
# -----------------------------------------------------------------------------------------------------------------------

# Get ALL Datasets (tasks) data from OpenML
datasets <- listOMLDataSets()
colnames(datasets)[1] <- "OML.data.id"
colnames(datasets)[2] <- "task"
datasets$task_is <- "dataset"
datasets$weight <- 1
datasets$hierarchy_belongs <- "OML datasets"
datasets$source <- paste("openML_d",datasets$OML.data.id,sep ="_")
datasets <- select(datasets, -tags)
mySave(datasets, "_other_datasets_all_openML")
# -----------------------------------------------------------------------------------------------------------------------

# Get all RunsEvaluations from the task in the "study_14". Very long processing time. Results stored in a .rds
mylistOMLRunEvaluations <- function(task.id, lim){
  
  moreRuns = TRUE
  i = 1
  listRuns<-listOMLRunEvaluations(task.id, limit = lim)
  
  while(moreRuns){
    
    print(paste("iter: ",i, " - rows: ", nrow(listRuns)))
    os = (lim * i) + 1
    listRuns.temp<-listOMLRunEvaluations(task.id, limit = lim, offset = os)
    if(nrow(listRuns.temp)>0){
      listRuns <- bind_rows(listRuns, listRuns.temp)
      i = i + 1
    }else{
      moreRuns = FALSE
    }
  }
  listRuns.uniq <- distinct(listRuns, run.id, .keep_all = TRUE)
  # nrow(listRuns.uniq)
  return(listRuns.uniq)
}

# listRunEvaluation <- list()
# t = tasks$task.id
# for (i in 66:length(t)){
#   print(paste("Task: ", t[i], "---"))
#   listRunEvaluation[[t[i]]] <-  mylistOMLRunEvaluations(t[i],10000)
# }

# saveRDS(listRunEvaluation,  file = "listAllRunEvaluation.rds")
# -----------------------------------------------------------------------------------------------------------------------

# Get RunEvaluations from file .rds
listRunEvaluation <- readRDS("listAllRunEvaluation.rds")

# Filter listRunEvaluation to keep best runs per flow
onlyDbestRuns <- function(runs){
  runs.agg <- runs %>% group_by(flow.id) %>% slice(which.max(predictive.accuracy))
  return(runs.agg)
}

which.median <- function(x){
  which.min(abs(x - median(x)))
}

onlyDmedianRuns <- function(runs){
  
  runs.agg <- runs %>% group_by(flow.id) %>% slice(which.min(predictive.accuracy))
  return(runs.agg)
}


# t2.agg.median <-onlyDmedianRuns(listRunEvaluation[[2]])
# t2.agg.max <-onlyDbestRuns(listRunEvaluation[[2]])

# t2.agg <- onlyDbestRuns(runs[[2]])
# -----------------------------------------------------------------------------------------------------------------------

# Get data from individual tasks, methods and flows-setups
insert_dataOML <- function(task_id, toDB = FALSE){
  
  task_temp <- getOMLTask(task.id = task_id)
  dataset_id <- task_temp$input$data.set$desc$id
  dataset_name <- task_temp$input$data.set$desc$name
  
  ### Insert [SOURCE] Dataset
  sourceTable_tasks <- data.frame(name = paste("openML_d",dataset_id,sep ="_"),
                              link= paste("https://www.openml.org/d/", dataset_id, sep =""),
                              description = paste("openML Dataset: ", dataset_name , sep = ""))
  mySave(sourceTable_tasks, paste0("source_d_",dataset_id,"_openML"))
  if(toDB){insert_source(sourceTable_tasks)}
  
  
  
  ### Insert [TASK] Dataset (openML data)
  print(paste("Inserting dataset: ", task_id, sep = ""))
  taskTable <- filter(datasets, OML.data.id == dataset_id)
  mySave(taskTable, paste0("task_d_",dataset_id,"_openML"))
  if(toDB){ids_task <- insert_task(taskTable)}
  

  
  ### Insert [SOURCE] Method (openML task)
  method_name = paste(task_temp$input$estimation.procedure$type,taskTable$task,sep="_")
  sourceTable_method <- data.frame(name = paste("openML_t",task_id,sep ="_"),
                                  link= paste("https://www.openml.org/t/", task_id, sep =""),
                                  description = paste("openML Task: ", method_name , sep = ""))
  mySave(sourceTable_method, paste0("source_t_",task_id,"_openML"))
  if(toDB){insert_source(sourceTable_tasks)}
  
  
  
  ### Insert [METHOD] Method (openML task (e.g., supervised Class & cross-validation)
  print(paste("Inserting method: ",method_name, sep = ""))
  parameters <- task_temp$input$estimation.procedure$parameters
  parameters <- unlist(parameters)
  parameters <- data.frame(lapply(parameters, type.convert), stringsAsFactors=FALSE)
  methodTable <- data.frame(method = method_name, #run$setup.string, 
                            source = "openML", 
                            task.type = task_temp$task.type,
                            estimation.procedure = task_temp$input$estimation.procedure$type,
                            data.splits.url = task_temp$input$estimation.procedure$data.splits.url,
                            openML_task.id = task_id
                            )
  methodTable <- cbind(methodTable, parameters) 
  mySave(methodTable, paste0("method_t_",task_id,"_openML"))
  if(toDB){ids_method <- insert_method(methodTable)}
  
  
  
  ### Lets download Agent data (runs/flows performed for this taks)
  print(paste("Downloading results (openML) for task...", task_id))
  #temp = listOMLRunEvaluations(task.id = task_id)
  temp = onlyDmedianRuns(listRunEvaluation[[task_id]])
  temp <- data.frame(temp)
  # temp$setup.id <- as.factor(temp$setup.id)
  # temp2 = as.data.frame(summarise_if(group_by(temp, setup.id, flow.id, flow.name, task.id, learner.name, data.name, flow.source),is.numeric, mymax))
  # 
  # cols2remove <- c("build.cpu.time","build.memory","usercpu.time.millis","usercpu.time.millis.testing", "usercpu.time.millis.training","scimark.benchmark")
  # temp3 <- select(temp2, -cols2remove)
  # mySave(temp3, paste0("_other_allAgentsResults_t_",task_id,"_openML"))
  # 
  # temp4 <- filter(temp3, flow.source %in% c("weka", "mlr", "openml", NA))
  # mySave(temp4, paste0("_other_allAgentsResults_filter_t_",task_id,"_openML"))
  temp4 <- temp

  
  
  #### Lets analyse those N Agents performing the task
  listAgents <- list() # list of flows
  listSources <- list() # list of sources/webs of flows
  listResults <- list() # list of evaluations by flow
  
  for(i in 1:nrow(temp4)){

    print(paste(".. Inserting run/flow: ", i, sep = ""))

    ### Specific flow/agent  information
    flow_temp <- getOMLFlow(flow.id = temp4$flow.id[i])
    #run_temp <- getOMLRun(temp4$run.id[i])



    ### Source Info (web) of the flow/agent
    sourceTable_i <- data.frame(name = paste("openML_f",temp4$flow.id[i],sep ="_"),
                                link= paste("https://www.openml.org/f/", flow_temp$flow.id, sep =""),
                                description = paste("openML flow: ",  temp4$flow.name[i], sep = ""))
    listSources[[i]] <- sourceTable_i
    if(toDB){insert_source(sourceTable_i)}



    ### Parameters characterising the flow/agent
    ERROR <- tryCatch(
      setup_temp <- listOMLSetup(setup.id = as.integer(as.character(temp4[i,"setup.id"])), flow.id = as.integer(as.character(temp4[i,"flow.id"]))),
      error = function(e) {return(TRUE)})

    if (!is.logical(ERROR)){
      setup_temp <- filter(setup_temp, setup.id == as.integer(as.character(temp4[i,"setup.id"])), flow.id  == as.integer(as.character(temp4[i,"flow.id"])))
    }else{
      setup_temp <- data.frame()
    }
    
    agent_name = paste(temp4$flow.name[i], temp4$setup.id[i], sep = "_" )
    agentTable_i <- data.frame(agent = agent_name,
                               agent_is = temp4$learner.name[i],
                               weight = 1,
                               source = paste("openML_f",temp4$flow.id[i],sep ="_"),
                               hierarchy_belongs = temp4$flow.source[i],
                               openML_run.id = temp4$run.id[i],
                               openML_flow.id = temp4$flow.id[i],
                               # openML_flow.version = temp4$flow.version[i],
                               openML_setup.id = as.integer(as.character(temp4$setup.id[i])),
                               openML_flow.version = flow_temp$external.version)

    if (nrow(setup_temp)>0){#hay setup
      setup_temp <- select(setup_temp, setup.id, flow.id, parameter.name,value)
      setup_temp.cast <- dcast(setup_temp,  setup.id + flow.id ~ parameter.name)
      setup_temp.cast <- select(setup_temp.cast, -setup.id, -flow.id)
      agentTable_i <- cbind(agentTable_i, setup_temp.cast)
    }
    listAgents[[i]] <- agentTable_i
    if(toDB){ids_agent <- insert_agent(agentTable_i)}



    ### Evaluation of the run/agent
    metrics <- !(colnames(temp4) %in% c("run.id", "task.id", "setup.id", "flow.id", "flow.name", "flow.version", "flow.source", "learner.name",
                                        "data.name", "upload.time"))
    metrics <-  colnames(temp4)[metrics]
    listlistResults <- list(); j = 1
    for (r in metrics){
      #print(paste("Metric: ", r))

      if(!is.na(temp4[i,r])){
        resultsTable <- data.frame(agent = agent_name,
                                   task = dataset_name,
                                   method = method_name,
                                   result = temp4[i,r],
                                   metric = r)
        listlistResults[[j]] <- resultsTable
        if(toDB){insert_resuts(resultsTable, ids_agent, ids_task, ids_method)}
      }

      j =j + 1
    }
    listResults[[i]] <- listlistResults
  }
  mySave(listSources, paste0("sources_t_",task_id,"_openML"))
  mySave(listAgents, paste0("agents_t_",task_id,"_openML"))
  mySave(listResults, paste0("results_t_",task_id,"_openML"))
  
}


alltasks <- tasks$task.id
 for(task_id in 20:length(alltasks)){
     insert_dataOML(alltasks[task_id])
 }



  

  





