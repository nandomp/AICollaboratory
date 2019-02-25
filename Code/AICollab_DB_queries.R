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
source("AICollab_preProFuncs.R")
options("scipen"=1000000)
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# Queries
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------

db <- connectAtlasDB()


# -----------------------------------------------------------------------------------------------------------------------
# Get Agents/Task by hierarchy
# -----------------------------------------------------------------------------------------------------------------------

# agent_h = "Default"
# task_h = "%" 

get_AgentTask_hierarchy  <- function(agent_h, task_h){

  db <- connectAtlasDB()
  
  query <-paste0("SELECT
                r.value AS value,
                r.metric AS metric,
                a.name AS agent,
                t.name AS task,
                m.name AS method,
                ah.name AS hierarchy_agent,
                th.name AS hierarchy_task
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
                GROUP by r.value, a.name, t.name, m.name")
  
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



# -----------------------------------------------------------------------------------------------------------------------
# Plot complete results to plot if Agent/Task selected
# -----------------------------------------------------------------------------------------------------------------------

plot_Results <- function(results, agent = TRUE, metric = "", method, howMany = 100){
  # Result:  value metric agent task method
  
  require(ggplot2)
  if(metric == ""){metric <- results$metric[1]}
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
    theme_minimal() +
    theme(legend.text = element_text(size=9),
          legend.title = element_text(size=10),
          legend.key.size =  unit(0.2, "in"),
          legend.direction = "horizontal",
          legend.key = element_rect(fill = "white"),
          legend.position = "top", #c(0.8, 0.1),
          legend.justification = "left",
          # legend.spacing.x = unit(-0.005, "in"),
          # legend.text.align	=0.5,
          legend.background =  element_blank(),
          # axis.title = element_text(size = 16),
          # axis.text=element_text(size=12),
          # axis.text.x = element_text(size = 12,angle = 0, hjust = 1),
          # axis.text.y = element_text(size = 12, hjust = 1),
          # panel.grid.minor = element_blank(),
          panel.border = element_blank())
  
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




