# -----------------------------------------------------------------------------------------------------------------------
#
# This is R code for the following paper/project:
#
#  - [A]I Collaboratory (https://github.com/nandomp/AICollaboratory) 
#
# This code implements: 
#
#  - SQL queries
#
# This code has been developed by
#   FERNANDO MARTINEZ-PLUMED, UNIVERSITAT POLITECNICA DE VALENCIA, SPAIN
#   fmartinez@dsic.upv.es
#
# LICENCE:
#   GPL
#
# VERSION HISTORY:
#  - V.1.0    22 Feb 2019. 
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
options("scipen"=1000000)
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# Queries
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------

db <- connectAtlasDB() 


# -----------------------------------------------------------------------------------------------------------------------
# Get Agents/Task current hierarchies
# -----------------------------------------------------------------------------------------------------------------------

get_Agent_hierarchy  <- function(){
  
  db <- connectAtlasDB()
  query <-paste0("SELECT * FROM atlasofintelligence.agent_hierarchy")
  datos <- send_SQL(db,query)
  dbDisconnect(db)
  return(datos)
  
}

get_Task_hierarchy  <- function(){
  
  db <- connectAtlasDB()
  query <-paste0("SELECT * FROM atlasofintelligence.task_hierarchy")
  datos <- send_SQL(db,query)
  dbDisconnect(db)
  return(datos)
  
}


# -----------------------------------------------------------------------------------------------------------------------
# Get Unique hierarhies, Agent_is and Task_is 
# -----------------------------------------------------------------------------------------------------------------------

get_unique_h_ai_ti_v0 <- function(verbose = FALSE){
  db <- connectAtlasDB()
  query <- paste0("SELECT                 
                a2.name AS agent_is,
                t2.name AS task_is,
                ah.name AS hierarchy_agent,
                th.name AS hierarchy_task
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a1 ON ai.agent_id = a1.agent_id
                LEFT JOIN agent AS a2 ON ai.agent_id_in = a2.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t1 ON ti.task_id = t1.task_id
                LEFT JOIN task AS t2 ON ti.task_id_in = t2.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh ON tbh.is_id = ti.is_id
                LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id
                WHERE ah.name LIKE '%' AND th.name LIKE '%'
                GROUP by a2.name, t2.name, ah.name, th.name")
  
  if(verbose){print(query)}
  
  datos <- send_SQL(db,query)
  dbDisconnect(db)
  
  return(datos)
  
}

get_unique_h_ai_ti<- function(verbose = FALSE){
  db <- connectAtlasDB()
  query <- paste0("SELECT                 
                a2.name AS agent_is,
                ANY_VALUE(a3.name) AS agent_is_2,
                ANY_VALUE(a4.name) AS agent_is_3,
                ANY_VALUE(a5.name) AS agent_is_4,
                t2.name AS task_is,
                ANY_VALUE(t3.name) AS task_is_2,
                ANY_VALUE(t4.name) AS task_is_3,
                ANY_VALUE(t5.name) AS task_is_4,
                ah.name AS hierarchy_agent,
				        ANY_VALUE(ah2.name) AS hierarchy_agent_2,
                ANY_VALUE(ah3.name) AS hierarchy_agent_3,
                ANY_VALUE(ah4.name) AS hierarchy_agent_4,
                th.name AS hierarchy_task,
                ANY_VALUE(th2.name) AS hierarchy_task_2,
                ANY_VALUE(th3.name) AS hierarchy_task_3,
                ANY_VALUE(th4.name) AS hierarchy_task_4
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a1 ON ai.agent_id = a1.agent_id
                LEFT JOIN agent AS a2 ON ai.agent_id_in = a2.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id
                LEFT JOIN agent_is AS ai2 ON a2.agent_id = ai2.agent_id
                LEFT JOIN agent AS a3 ON ai2.agent_id_in = a3.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh2 ON abh2.is_id = ai2.is_id
                LEFT JOIN agent_hierarchy AS ah2 ON ah2.hierarchy_id = abh2.hierarchy_id
                LEFT JOIN agent_is AS ai3 ON a3.agent_id = ai3.agent_id
                LEFT JOIN agent AS a4 ON ai3.agent_id_in = a4.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh3 ON abh3.is_id = ai3.is_id
                LEFT JOIN agent_hierarchy AS ah3 ON ah3.hierarchy_id = abh3.hierarchy_id
			        	LEFT JOIN agent_is AS ai4 ON a4.agent_id = ai4.agent_id
                LEFT JOIN agent AS a5 ON ai4.agent_id_in = a5.agent_id
				        LEFT JOIN agent_belongs_to_hierarchy AS abh4 ON abh4.is_id = ai4.is_id
                LEFT JOIN agent_hierarchy AS ah4 ON ah4.hierarchy_id = abh4.hierarchy_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t1 ON ti.task_id = t1.task_id
                LEFT JOIN task AS t2 ON ti.task_id_in = t2.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh ON tbh.is_id = ti.is_id
                LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id
                LEFT JOIN task_is AS ti2 ON t2.task_id = ti2.task_id 
                LEFT JOIN task AS t3 ON ti2.task_id_in = t3.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh2 ON tbh2.is_id = ti2.is_id
                LEFT JOIN task_hierarchy AS th2 ON th2.hierarchy_id = tbh2.hierarchy_id  
                LEFT JOIN task_is AS ti3 ON t3.task_id = ti3.task_id 
                LEFT JOIN task AS t4 ON ti3.task_id_in = t4.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh3 ON tbh3.is_id = ti3.is_id
                LEFT JOIN task_hierarchy AS th3 ON th3.hierarchy_id = tbh3.hierarchy_id  
                LEFT JOIN task_is AS ti4 ON t4.task_id = ti4.task_id 
                LEFT JOIN task AS t5 ON ti4.task_id_in = t5.task_id
				        LEFT JOIN task_belongs_to_hierarchy AS tbh4 ON tbh4.is_id = ti4.is_id
                LEFT JOIN task_hierarchy AS th4 ON th4.hierarchy_id = tbh4.hierarchy_id  
                WHERE ah.name LIKE '%' AND th.name LIKE '%'
                GROUP by a2.name, t2.name, ah.name, th.name")
  
  if(verbose){print(query)}
  
  datos <- send_SQL(db,query)
  
  for(j in 1:4){
    for (i in 1:nrow(datos)){
      if(is.na(datos$task_is_4[i])){
        datos$task_is_4[i] <- datos$task_is_3[i]
        datos$task_is_3[i] <- NA
      }
      if(is.na(datos$task_is_3[i])){
        datos$task_is_3[i] <- datos$task_is_2[i]
        datos$task_is_2[i] <- NA
      }
      if(is.na(datos$task_is_2[i])){
        datos$task_is_2[i] <- datos$task_is[i]
        datos$task_is[i] <- NA
      }
    }
  }
  
  
  for(j in 1:4){
    for (i in 1:nrow(datos)){
      if(is.na(datos$agent_is_4[i])){
        datos$agent_is_4[i] <- datos$agent_is_3[i]
        datos$agent_is_3[i] <- NA
      }
      if(is.na(datos$agent_is_3[i])){
        datos$agent_is_3[i] <- datos$agent_is_2[i]
        datos$agent_is_2[i] <- NA
      }
      if(is.na(datos$agent_is_2[i])){
        datos$agent_is_2[i] <- datos$agent_is[i]
        datos$agent_is[i] <- NA
      }
    }
  }
  
  dbDisconnect(db)
  
  return(datos)
  
}


# -----------------------------------------------------------------------------------------------------------------------
# Get InfoBoxes
# -----------------------------------------------------------------------------------------------------------------------

get_infoBoxes <- function(verbose = FALSE){
  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                a1.name AS agent,
                ANY_VALUE(a2.name) AS agent_is,
                ANY_VALUE(a3.name) AS agent_is_2,
                ANY_VALUE(a4.name) AS agent_is_3,
                ANY_VALUE(a5.name) AS agent_is_4,
                t1.name AS task,
                ANY_VALUE(t2.name) AS task_is,
                ANY_VALUE(t3.name) AS task_is_2,
                ANY_VALUE(t4.name) AS task_is_3,
                ANY_VALUE(t5.name) AS task_is_4,
                m.name AS method,
                r.metric AS metric,
                ANY_VALUE(r.value) AS value,
                ANY_VALUE(ah.name) AS hierarchy_agent,
                ANY_VALUE(ah2.name) AS hierarchy_agent_2,
                ANY_VALUE(ah3.name) AS hierarchy_agent_3,
                ANY_VALUE(ah4.name) AS hierarchy_agent_4,
                ANY_VALUE(th.name) AS hierarchy_task,
                ANY_VALUE(th2.name) AS hierarchy_task_2,
                ANY_VALUE(th3.name) AS hierarchy_task_3,
                ANY_VALUE(th4.name) AS hierarchy_task_4,
                ANY_VALUE(s.date) AS date,
                ANY_VALUE(s.description) AS paper,
                ANY_VALUE(s.link) AS link
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a1 ON ai.agent_id = a1.agent_id
                LEFT JOIN agent AS a2 ON ai.agent_id_in = a2.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id
                LEFT JOIN source AS s ON ai.source_id = s.source_id
                LEFT JOIN agent_is AS ai2 ON a2.agent_id = ai2.agent_id
                LEFT JOIN agent AS a3 ON ai2.agent_id_in = a3.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh2 ON abh2.is_id = ai2.is_id
                LEFT JOIN agent_hierarchy AS ah2 ON ah2.hierarchy_id = abh2.hierarchy_id
                LEFT JOIN agent_is AS ai3 ON a3.agent_id = ai3.agent_id
                LEFT JOIN agent AS a4 ON ai3.agent_id_in = a4.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh3 ON abh3.is_id = ai3.is_id
                LEFT JOIN agent_hierarchy AS ah3 ON ah3.hierarchy_id = abh3.hierarchy_id
				        LEFT JOIN agent_is AS ai4 ON a4.agent_id = ai4.agent_id
                LEFT JOIN agent AS a5 ON ai4.agent_id_in = a5.agent_id
				        LEFT JOIN agent_belongs_to_hierarchy AS abh4 ON abh4.is_id = ai4.is_id
                LEFT JOIN agent_hierarchy AS ah4 ON ah4.hierarchy_id = abh4.hierarchy_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t1 ON ti.task_id = t1.task_id                
                LEFT JOIN task AS t2 ON ti.task_id_in = t2.task_id    
				        LEFT JOIN task_belongs_to_hierarchy AS tbh ON tbh.is_id = ti.is_id
                LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id        
                LEFT JOIN task_is AS ti2 ON t2.task_id = ti2.task_id 
                LEFT JOIN task AS t3 ON ti2.task_id_in = t3.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh2 ON tbh2.is_id = ti2.is_id
                LEFT JOIN task_hierarchy AS th2 ON th2.hierarchy_id = tbh2.hierarchy_id  
                LEFT JOIN task_is AS ti3 ON t3.task_id = ti3.task_id 
                LEFT JOIN task AS t4 ON ti3.task_id_in = t4.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh3 ON tbh3.is_id = ti3.is_id
                LEFT JOIN task_hierarchy AS th3 ON th3.hierarchy_id = tbh3.hierarchy_id  
                LEFT JOIN task_is AS ti4 ON t4.task_id = ti4.task_id 
                LEFT JOIN task AS t5 ON ti4.task_id_in = t5.task_id
				        LEFT JOIN task_belongs_to_hierarchy AS tbh4 ON tbh4.is_id = ti4.is_id
                LEFT JOIN task_hierarchy AS th4 ON th4.hierarchy_id = tbh4.hierarchy_id  
                LEFT JOIN method AS m ON r.method_id = m.method_id
                LEFT JOIN method_has AS mh ON mh.method_id = m.method_id
                LEFT JOIN method_attribute_value AS mav ON mav.attribute_value_id = mh.attribute_value_id
                LEFT JOIN method_attribute AS ma ON ma.attribute_id = mav.attribute_id
                WHERE ah.name LIKE '%' AND th.name LIKE '%'                
                GROUP by a1.name, t1.name, m.name, r.metric")
  
  if(verbose){print(query)}
  
  datos <- send_SQL(db,query)
  
  #View(t)
  #print(paste("Agents:", length(unique(t$agent))))
  #print(paste("Tasks:",length(unique(t$task))))
  #print(paste("Methods:",length(unique(t$method))))
  #print(paste("Results:", nrow(t)))
  
  dbDisconnect(db)
  
  out <- list(
    Agents = length(unique(datos$agent)),
    Agents.AI = length(unique(filter(datos, hierarchy_agent == "AI")$agent)),
    Agents.Human = length(unique(filter(datos, hierarchy_agent == "Hominoidea")$agent)),
    Agents.Animal = length(unique(filter(datos, hierarchy_agent == "Animal")$agent)),
    
    
    Tasks = length(unique(datos$task)),
    Tasks.AI = length(unique(filter(datos, (task_is_4 == "AI Task" | task_is_3 == "AI Task" | task_is_2 == "AI Task" | task_is == "AI Task"))$task)),
    Tasks.Human = length(unique(filter(datos, (task_is_4 == "Human Task" | task_is_3 == "Human Task" | task_is_2 == "Human Task" | task_is == "Human Task"))$task)),
    Tasks.Animal = length(unique(filter(datos, (task_is_4 == "Animal Task" | task_is_3 == "Animal Task" | task_is_2 == "Animal Task" | task_is == "Animal Task"))$task)),
    
    Results = nrow(datos),
    Results.AI = length(filter(datos, hierarchy_agent == "AI")$agent),
    Results.Human = length(filter(datos, hierarchy_agent == "Hominoidea")$agent),
    Results.Animal = length(filter(datos, hierarchy_agent == "Animal")$agent)
  )

  return(out)
}


# -----------------------------------------------------------------------------------------------------------------------
# Get Agents/Task by hierarchy
# -----------------------------------------------------------------------------------------------------------------------

# agent_h = "AI"
# task_h = "%" 

get_AgentTask_hierarchy  <- function(agent_h, task_h, verbose = FALSE){

  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                ANY_VALUE(r.value) AS value,
                r.metric AS metric,
                a.name AS agent,
                t.name AS task,
                m.name AS method,
                ANY_VALUE(ah.name) AS hierarchy_agent,
                ANY_VALUE(th.name) AS hierarchy_task
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a ON ai.agent_id = a.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t ON ti.task_id = t.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh ON tbh.is_id = ti.is_id
                LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id
                LEFT JOIN method AS m ON r.method_id = m.method_id
                LEFT JOIN method_has AS mh ON mh.method_id = m.method_id
                LEFT JOIN method_attribute_value AS mav ON mav.attribute_value_id = mh.attribute_value_id
                LEFT JOIN method_attribute AS ma ON ma.attribute_id = mav.attribute_id
                WHERE ah.name LIKE '",agent_h,"' AND th.name LIKE '",task_h,"'
                GROUP by a.name, t.name, m.name, r.metric")
  
  if(verbose){print(query)}
  
  datos <- send_SQL(db,query)
  
  #View(t)
  #print(paste("Agents:", length(unique(t$agent))))
  #print(paste("Tasks:",length(unique(t$task))))
  #print(paste("Methods:",length(unique(t$method))))
  #print(paste("Results:", nrow(t)))
  
  dbDisconnect(db)
  
  return(datos)
  
}

get_AgentTask_hierarchy_2  <- function(agent_h, task_h, verbose = FALSE){
  
  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                a1.name AS agent,
                ANY_VALUE(a2.name) AS agent_is,
                t.name AS task,
                m.name AS method,
                r.metric AS metric,
                ANY_VALUE(r.value) AS value,
                ANY_VALUE(ah.name) AS hierarchy_agent,
                ANY_VALUE(th.name) AS hierarchy_task
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a1 ON ai.agent_id = a1.agent_id
                LEFT JOIN agent AS a2 ON ai.agent_id_in = a2.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t ON ti.task_id = t.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh ON tbh.is_id = ti.is_id
                LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id
                LEFT JOIN method AS m ON r.method_id = m.method_id
                LEFT JOIN method_has AS mh ON mh.method_id = m.method_id
                LEFT JOIN method_attribute_value AS mav ON mav.attribute_value_id = mh.attribute_value_id
                LEFT JOIN method_attribute AS ma ON ma.attribute_id = mav.attribute_id
                WHERE ah.name LIKE '",agent_h,"' AND th.name LIKE '",task_h,"'
                GROUP by a1.name, t.name, m.name, r.metric")
  
  if(verbose){print(query)}
  
  datos <- send_SQL(db,query)
  dbDisconnect(db)
 
  return(datos)
  
}

get_AgentTask_hierarchy_3  <- function(agent_h, task_h, verbose = FALSE){
  
  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                a1.name AS agent,
                ANY_VALUE(a2.name) AS agent_is,
                t1.name AS task,
                ANY_VALUE(t2.name) AS task_is,
                m.name AS method,
                r.metric AS metric,
                ANY_VALUE(r.value) AS value,
                ANY_VALUE(ah.name) AS hierarchy_agent,
                ANY_VALUE(th.name) AS hierarchy_task,
                ANY_VALUE(s.date) AS date,
                ANY_VALUE(s.description) AS paper,
                ANY_VALUE(s.link) AS link
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a1 ON ai.agent_id = a1.agent_id
                LEFT JOIN agent AS a2 ON ai.agent_id_in = a2.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id
                LEFT JOIN source AS s ON ai.source_id = s.source_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t1 ON ti.task_id = t1.task_id
                LEFT JOIN task AS t2 ON ti.task_id_in = t2.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh ON tbh.is_id = ti.is_id
                LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id
                LEFT JOIN method AS m ON r.method_id = m.method_id
                LEFT JOIN method_has AS mh ON mh.method_id = m.method_id
                LEFT JOIN method_attribute_value AS mav ON mav.attribute_value_id = mh.attribute_value_id
                LEFT JOIN method_attribute AS ma ON ma.attribute_id = mav.attribute_id
                WHERE ah.name LIKE '",agent_h,"' AND th.name LIKE '",task_h,"'
                GROUP by a1.name, t1.name, m.name, r.metric")
  
  if(verbose){print(query)}
  
  datos <- send_SQL(db,query)
  dbDisconnect(db)
  
  return(datos)
  
}

get_AgentTask_hierarchy_4  <- function(agent_h, task_h, agentIs, taskIs, verbose = FALSE){
  
  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                a1.name AS agent,
                ANY_VALUE(a2.name) AS agent_is,
                t1.name AS task,
                ANY_VALUE(t2.name) AS task_is,
                m.name AS method,
                r.metric AS metric,
                ANY_VALUE(r.value) AS value,
                ANY_VALUE(ah.name) AS hierarchy_agent,
                ANY_VALUE(th.name) AS hierarchy_task,
                ANY_VALUE(s.date) AS date,
                ANY_VALUE(s.description) AS paper,
                ANY_VALUE(s.link) AS link
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a1 ON ai.agent_id = a1.agent_id
                LEFT JOIN agent AS a2 ON ai.agent_id_in = a2.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id
                LEFT JOIN source AS s ON ai.source_id = s.source_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t1 ON ti.task_id = t1.task_id
                LEFT JOIN task AS t2 ON ti.task_id_in = t2.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh ON tbh.is_id = ti.is_id
                LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id
                LEFT JOIN method AS m ON r.method_id = m.method_id
                LEFT JOIN method_has AS mh ON mh.method_id = m.method_id
                LEFT JOIN method_attribute_value AS mav ON mav.attribute_value_id = mh.attribute_value_id
                LEFT JOIN method_attribute AS ma ON ma.attribute_id = mav.attribute_id
                WHERE ah.name LIKE '",agent_h,"' AND th.name LIKE '",task_h,"' AND a2.name LIKE '",agentIs,"' AND t2.name LIKE '",taskIs,"'
                GROUP by a1.name, t1.name, m.name, r.metric")
  
  if(verbose){print(query)}
  
  datos <- send_SQL(db,query)
  dbDisconnect(db)
  
  return(datos)
  
}


# agent_h = "AI"
# task_h = "%" 
# agentIs = "DQN/DNN"
# taskIs = "Image Classification"
get_AgentTask_hierarchy_5  <- function(agent_h, task_h, agentIs, taskIs, verbose = FALSE){
  
  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                a1.name AS agent,
                ANY_VALUE(a2.name) AS agent_is,
                ANY_VALUE(a3.name) AS agent_is_2,
                ANY_VALUE(a4.name) AS agent_is_3,
                ANY_VALUE(a5.name) AS agent_is_4,
                t1.name AS task,
                ANY_VALUE(t2.name) AS task_is,
                ANY_VALUE(t3.name) AS task_is_2,
                ANY_VALUE(t4.name) AS task_is_3,
                ANY_VALUE(t5.name) AS task_is_4,
                m.name AS method,
                r.metric AS metric,
                ANY_VALUE(r.value) AS value,
                ANY_VALUE(ah.name) AS hierarchy_agent,
                ANY_VALUE(ah2.name) AS hierarchy_agent_2,
                ANY_VALUE(ah3.name) AS hierarchy_agent_3,
                ANY_VALUE(ah4.name) AS hierarchy_agent_4,
                ANY_VALUE(th.name) AS hierarchy_task,
                ANY_VALUE(th2.name) AS hierarchy_task_2,
                ANY_VALUE(th3.name) AS hierarchy_task_3,
                ANY_VALUE(th4.name) AS hierarchy_task_4,
                ANY_VALUE(s.date) AS date,
                ANY_VALUE(s.description) AS paper,
                ANY_VALUE(s.link) AS link
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a1 ON ai.agent_id = a1.agent_id
                LEFT JOIN agent AS a2 ON ai.agent_id_in = a2.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id
                LEFT JOIN source AS s ON ai.source_id = s.source_id
                LEFT JOIN agent_is AS ai2 ON a2.agent_id = ai2.agent_id
                LEFT JOIN agent AS a3 ON ai2.agent_id_in = a3.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh2 ON abh2.is_id = ai2.is_id
                LEFT JOIN agent_hierarchy AS ah2 ON ah2.hierarchy_id = abh2.hierarchy_id
                LEFT JOIN agent_is AS ai3 ON a3.agent_id = ai3.agent_id
                LEFT JOIN agent AS a4 ON ai3.agent_id_in = a4.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh3 ON abh3.is_id = ai3.is_id
                LEFT JOIN agent_hierarchy AS ah3 ON ah3.hierarchy_id = abh3.hierarchy_id
				        LEFT JOIN agent_is AS ai4 ON a4.agent_id = ai4.agent_id
                LEFT JOIN agent AS a5 ON ai4.agent_id_in = a5.agent_id
				        LEFT JOIN agent_belongs_to_hierarchy AS abh4 ON abh4.is_id = ai4.is_id
                LEFT JOIN agent_hierarchy AS ah4 ON ah4.hierarchy_id = abh4.hierarchy_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t1 ON ti.task_id = t1.task_id                
                LEFT JOIN task AS t2 ON ti.task_id_in = t2.task_id    
				        LEFT JOIN task_belongs_to_hierarchy AS tbh ON tbh.is_id = ti.is_id
                LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id        
                LEFT JOIN task_is AS ti2 ON t2.task_id = ti2.task_id 
                LEFT JOIN task AS t3 ON ti2.task_id_in = t3.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh2 ON tbh2.is_id = ti2.is_id
                LEFT JOIN task_hierarchy AS th2 ON th2.hierarchy_id = tbh2.hierarchy_id  
                LEFT JOIN task_is AS ti3 ON t3.task_id = ti3.task_id 
                LEFT JOIN task AS t4 ON ti3.task_id_in = t4.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh3 ON tbh3.is_id = ti3.is_id
                LEFT JOIN task_hierarchy AS th3 ON th3.hierarchy_id = tbh3.hierarchy_id  
                LEFT JOIN task_is AS ti4 ON t4.task_id = ti4.task_id 
                LEFT JOIN task AS t5 ON ti4.task_id_in = t5.task_id
				        LEFT JOIN task_belongs_to_hierarchy AS tbh4 ON tbh4.is_id = ti4.is_id
                LEFT JOIN task_hierarchy AS th4 ON th4.hierarchy_id = tbh4.hierarchy_id  
                LEFT JOIN method AS m ON r.method_id = m.method_id
                LEFT JOIN method_has AS mh ON mh.method_id = m.method_id
                LEFT JOIN method_attribute_value AS mav ON mav.attribute_value_id = mh.attribute_value_id
                LEFT JOIN method_attribute AS ma ON ma.attribute_id = mav.attribute_id
                WHERE ah.name LIKE '",agent_h,"' AND th.name LIKE '",task_h,"' AND (a2.name LIKE '",agentIs,"' OR a3.name LIKE '",agentIs,"' OR a4.name LIKE '",agentIs,"' OR  a5.name LIKE '",agentIs,"') AND 
                (t2.name LIKE '",taskIs,"' OR t3.name LIKE '",taskIs,"' OR t4.name LIKE '",taskIs,"' OR t5.name LIKE '",taskIs,"')               
                GROUP by a1.name, t1.name, m.name, r.metric")
  
  if(verbose){print(query)}
  
  datos <- send_SQL(db,query)
  dbDisconnect(db)
  
  return(datos)
  
}


# get_AgentTask_hierarchy_2(agent_h, task_h)

# -----------------------------------------------------------------------------------------------------------------------
# Get Agent attributes
# -----------------------------------------------------------------------------------------------------------------------

# agent = "SARSA"
# agent_h = "Default"

get_Attributes_Agent  <- function(agent, agent_h = "%"){
  
  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                a1.name AS agent,
                a2.name AS agentIS,
                ah.name AS hierarchy_agent,
                aa.name AS attribute,
                aav.value AS val
                FROM
                agent_is as ai
                LEFT JOIN agent AS a1 ON ai.agent_id = a1.agent_id
                LEFT JOIN agent AS a2 ON ai.agent_id_in = a2.agent_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id
                LEFT JOIN agent_has AS ahas ON ahas.agent_id = a1.agent_id
                LEFT JOIN agent_attribute_value AS aav ON aav.attribute_value_id = ahas.attribute_value_id
				        LEFT JOIN agent_attribute AS aa ON aa.attribute_id = aav.attribute_id
                WHERE a1.name LIKE '", agent,"' and ah.name LIKE '", agent_h,"'")
  
  datos <- send_SQL(db,query)
  
  #View(t)
  #print(paste("Agents:", length(unique(t$agent))))
  #print(paste("Tasks:",length(unique(t$task))))
  #print(paste("Methods:",length(unique(t$method))))
  #print(paste("Results:", nrow(t)))
  
  dbDisconnect(db)
  
  return(datos)
  
}
#get_Attributes_Agent('__main__.Wrapper(1)_157636')

# -----------------------------------------------------------------------------------------------------------------------
# Get Task attributes
# -----------------------------------------------------------------------------------------------------------------------

# task = "Gravitar"
# task_h = "Default"

get_Attributes_Task <- function(task, task_h = "%"){
  
  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                t1.name AS task,
                t2.name AS taskIS,
                th.name AS hierarchy_task,
                ta.name AS attribute,
                tav.value AS val
                FROM
                task_is as ti
                LEFT JOIN task AS t1 ON ti.task_id = t1.task_id
                LEFT JOIN task AS t2 ON ti.task_id_in = t2.task_id
                LEFT JOIN task_belongs_to_hierarchy AS tbh ON tbh.is_id = ti.is_id
                LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id
                LEFT JOIN task_has AS thas ON thas.task_id = t1.task_id
                LEFT JOIN task_attribute_value AS tav ON tav.attribute_value_id = thas.attribute_value_id
				        LEFT JOIN task_attribute AS ta ON ta.attribute_id = tav.attribute_id
                WHERE t1.name LIKE '", task,"' and th.name LIKE '", task_h,"'")
  
  datos <- send_SQL(db,query)
  
  #View(t)
  #print(paste("Agents:", length(unique(t$agent))))
  #print(paste("Tasks:",length(unique(t$task))))
  #print(paste("Methods:",length(unique(t$method))))
  #print(paste("Results:", nrow(t)))
  
  dbDisconnect(db)
  
  return(datos)
  
}


# -----------------------------------------------------------------------------------------------------------------------
# Get Method attributes
# -----------------------------------------------------------------------------------------------------------------------

# method = "SARSA"

get_Attributes_Method <- function(method){
  
  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                m.name AS method,
                ma.name AS attribute,
                mav.value AS val
                FROM
                method AS m
                LEFT JOIN method_has AS mhas ON mhas.method_id = m.method_id
                LEFT JOIN method_attribute_value AS mav ON mav.attribute_value_id = mhas.attribute_value_id
				        LEFT JOIN method_attribute AS ma ON ma.attribute_id = mav.attribute_id
                WHERE m.name LIKE '", method,"'")
  
  datos <- send_SQL(db,query)
  
  #View(t)
  #print(paste("Agents:", length(unique(t$agent))))
  #print(paste("Tasks:",length(unique(t$task))))
  #print(paste("Methods:",length(unique(t$method))))
  #print(paste("Results:", nrow(t)))
  
  dbDisconnect(db)
  
  return(datos)
  
}


# -----------------------------------------------------------------------------------------------------------------------
# Get Results to plot if Agent selected
# -----------------------------------------------------------------------------------------------------------------------

# agent = "SARSA"

get_Results_Agent  <- function(agent){
  
  db <- connectAtlasDB()
  
  query <- paste0("SELECT 
                r.value AS value,
                r.metric AS metric,
                a.name AS agent,
                t.name AS task,
                m.name AS method
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a ON ai.agent_id = a.agent_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t ON ti.task_id = t.task_id
                LEFT JOIN method AS m ON r.method_id = m.method_id
                WHERE
                a.name LIKE '",agent,"'")
  
  datos <- send_SQL(db,query)
  dbDisconnect(db)

return(datos)

}
# get_Results_Agent("SARSA")


# -----------------------------------------------------------------------------------------------------------------------
# Get Results to plot if Agent selected
# -----------------------------------------------------------------------------------------------------------------------

# task = "Frostbite"

get_Results_Task  <- function(task){
  
  db <- connectAtlasDB()
  
  query <- paste0("SELECT 
                r.value AS value,
                r.metric AS metric,
                a.name AS agent,
                t.name AS task,
                m.name AS method
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a ON ai.agent_id = a.agent_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t ON ti.task_id = t.task_id
                LEFT JOIN method AS m ON r.method_id = m.method_id
                WHERE
                t.name LIKE '",task,"'")
  
  datos <- send_SQL(db,query)
  dbDisconnect(db)
  
  return(datos)


}



#-----------------------------------------------------------------------------------------------------------------------
# Get Results from AGENT_IS to plot if Agent selected
# -----------------------------------------------------------------------------------------------------------------------

# agent_is = "Deep Reinforcement Learning"
# task = "Frostbite"

get_Results_Agent_is  <- function(agent_is, task){
  
  db <- connectAtlasDB()
  
  query <- paste0("SELECT 
                a1.name AS agent,
                a2. name AS agent_is, 
                r.value AS value,
                r.metric AS metric,
                t.name AS task,
                m.name AS method
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a1 ON ai.agent_id = a1.agent_id
                LEFT JOIN agent AS a2 ON ai.agent_id_in = a2.agent_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t ON ti.task_id = t.task_id
                LEFT JOIN method AS m ON r.method_id = m.method_id
                WHERE
                a2.name LIKE '",agent_is,"' AND t.name LIKE'",task,"'")
  
  datos <- send_SQL(db,query)
  dbDisconnect(db)
  
  return(datos)
  
}



# results <- get_Results_Agent_is("IBk", "soybean")
# plot_Results(results, agent = F)


# -----------------------------------------------------------------------------------------------------------------------
# Plot complete results to plot if Agent/Task selected
# -----------------------------------------------------------------------------------------------------------------------

plot_Results <- function(results, agent = TRUE, metric = "", method, howMany = 100){
  # Result:  value metric agent task method
  
  require(ggplot2)
  # print("PLOT RESULTS")
  # print(metric)
  if(length(metric) == 0 | metric == "" | is.null(metric)){metric <- results$metric[1]}
  results <- results[results$metric == metric,]
  
  results$task.T <- strtrim(results$task, 30)
  results$agent.T <- strtrim(results$agent, 30)
  
  results$value <- as.numeric(as.character(results$value))
  results.sort <-  results[order(-results$value),]
  if (howMany < nrow(results.sort)){
    results.sort <- results.sort[1:howMany,]
  }
  
  results.sort$metric <- factor(results.sort$metric, unique(results.sort$metric))
  results.sort$agent <- factor(results.sort$agent, unique(results.sort$agent))
  results.sort$task <- factor(results.sort$task, unique(results.sort$task))
  results.sort$method <- factor(results.sort$method, unique(results.sort$method))
  
  
  if (agent){
    plot <- ggplot(results.sort, aes(reorder(task, value), value, colour = method, label = agent))
  } else{
    plot <- ggplot(results.sort, aes(reorder(agent, value), value, colour = method, label = agent))
  }
    plot <- plot + 
    geom_point(size = 3) +
    labs(x = "", y = metric) +
    scale_x_discrete(labels = function(x) abbreviate(x, minlength=50)) +
    coord_flip() +
    scale_color_discrete(labels = levels(results.sort$method), breaks = levels(results.sort$method)) +
    theme_minimal() 
    # theme(legend.text = element_text(size=9),
    #       legend.title = element_text(size=10),
    #       legend.key.size =  unit(0.2, "in"),
    #       legend.direction = "horizontal",
    #       legend.key = element_rect(fill = "white"),
    #       legend.position = "top", #c(0.8, 0.1),
    #       legend.justification = "left",
    #       # legend.spacing.x = unit(-0.005, "in"),
    #       # legend.text.align	=0.5,
    #       legend.background =  element_blank(),
    #       # axis.title = element_text(size = 16),
    #       # axis.text=element_text(size=12),
    #       # axis.text.x = element_text(size = 12,angle = 0, hjust = 1),
    #       # axis.text.y = element_text(size = 12, hjust = 1),
    #       # panel.grid.minor = element_blank(),
    #       panel.border = element_blank())
  
  plot(plot)
}

# require(plotly)
# results <- get_Results_Agent('decisionStump(1)_267410')
# # plot_Results_agent(results, metric = "")
# p <- plot_Results(results, metric = "", agent = T)
# ggplotly(p)
# 
# results <- get_Results_Agent("Double DQN")
# # plot_Results_agent(results)
# p <- plot_Results(results, metric = "", agent = T)
# ggplotly(p)
# 
# 
# results <- get_Results_Task("credit-g")
# p <- plot_Results(results, agent = F)
# ggplotly(p)
# 
# results <- get_Results_Task("Frostbite")
# p <- plot_Results(results, agent = F)
# ggplotly(p)


# -----------------------------------------------------------------------------------------------------------------------
# Plot Pareto with restrictions 
# -----------------------------------------------------------------------------------------------------------------------

plotPareto <- function(datos.f, max = NA, min = NA, opt = NA, met = NA, preds = 12){
  
  print(paste(max, "-", min,"-", opt,"-", met))
  
  max = ifelse(is.na(max) | is.null(max), max(datos.f$value, na.rm = T), max)
  min = ifelse(is.na(min) | is.null(min), min(datos.f$value, na.rm = T), min)
  opt = ifelse(is.na(opt) | is.null(opt), max(datos.f$value, na.rm = T), opt)
  # met = ifelse(is.na(met), as.character(datos.f$metric[1]), met)
  
  print(paste(max, "-", min,"-", opt,"-", met))

  require(rPref)
  
  datos.f <- data.frame(datos.f)
  # datos.f <- filter(datos.f, metric == met)
  datos.f$value <- as.numeric(datos.f$value)
  datos.f <- datos.f[complete.cases(datos.f$date),]
  datos.f.top <- filter(datos.f, value > opt )
  datos.f.bottom <- filter(datos.f, value <= opt )
  
  datos.f.top <- group_by(datos.f.top, metric)
  sky.top <- psel(datos.f.top, low(as.numeric(datos.f.top$date)) * low(value)) 
  datos.f.bottom <- group_by(datos.f.bottom, metric)
  sky.bottom <- psel(datos.f.bottom, low(as.numeric(datos.f.bottom$date)) * high(value)) 
  
  
  cutoff.Hist <- data.frame( x1 = as.Date(min(datos.f$date)), x2 = as.Date(max(datos.f$date)), y1 = -Inf, y2 = Inf)
  cutoff.Pred <- data.frame( x1 = as.Date(max(datos.f$date)), x2= as.Date(today() %m+% months(preds)), y1 = -Inf, y2 = Inf)

  plot <- ggplot(datos.f) +
    
    # geom_rect(data = cutoff.Hist, aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2), fill= "white", alpha=0.15) + 
    # geom_rect(data = cutoff.Pred, aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2), fill= "red", alpha=0.15) + 
    
    geom_smooth(data = datos.f, aes(date, value, colour="lm"), method = "lm",  linetype ="dashed", alpha = 0.5, se = FALSE, fullrange = T, alpha = 0.6, size = 0.6) +
    geom_smooth(data = datos.f,aes(date, value, colour="Poisson poly 1"), method = "glm", formula = y~poly(x,1), method.args=list(family="poisson"),  fullrange = T,  linetype ="dashed", se = FALSE, alpha = 0.6, size = 0.6) +
    geom_smooth(data = datos.f,aes(date, value, colour="Poisson poly 2"), method = "glm", formula = y~poly(x,2), method.args=list(family="poisson"),  fullrange = T, linetype ="dashed", se = FALSE, alpha = 0.6, size = 0.6) +
    geom_smooth(data = datos.f,aes(date, value, colour="Gaussian poly 2"), method = "glm", formula = y~poly(x,2), method.args=list(family="gaussian"),  fullrange = T, linetype ="dashed", se = FALSE, alpha = 0.6, size = 0.6) +
    
    geom_point(data = datos.f,aes(date, value, label = agent, shape = metric), size = 3, alpha = 0.7) +
    
    geom_hline(yintercept = opt, alpha = 0.6, colour = "lightgray") +
    annotate("text", x = min(datos.f$date), y = opt*1.02, label = "Opt. value", angle = 90, hjust = 1.2, vjust = 1.4, colour = "darkgrey")  +
  
    geom_vline(xintercept = today(), alpha = 0.6, colour = "red", size = 2) +
    annotate("text", x = (max(datos.f$date) %m+% months(6)) , y = min*1.02, label = "Prediction", angle = 90, hjust = 1.2, vjust = 1.4, colour = "darkgrey")  +
    
    xlim(min(datos.f$date),today() %m+% months(preds))
    
  
  if(nrow(sky.top)>0){
    plot <- plot + geom_point(data = sky.top, aes(date, value, label = agent, shape = metric), size = 4, alpha = 0.9, colour = "#26A6BD") 
    if(nrow(sky.top)>1){
      plot <- plot + geom_line(data = sky.top, aes(date, value, shape = metric ), alpha = 0.7, colour = "#26A6BD", size = 1.1) 
    }
  }
  
  if(nrow(sky.bottom)>0){
    
    plot <- plot +geom_point(data = sky.bottom, aes(date, value, label = agent, shape = metric), size = 4, alpha = 0.7, colour = "#26A6BD") 
    if(nrow(sky.bottom)>1){
      plot <- plot + geom_line(data = sky.bottom, aes(date, value, shape = metric), alpha = 0.7, colour = "#26A6BD", size = 1.1) 
    }
  }
  
  plot <- plot + labs(y = "") + theme_minimal()
  
  
  return(plot)
  
}
