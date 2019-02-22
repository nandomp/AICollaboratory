source("AICollab_DB_funcs.R")


db <- connectAtlasDB()
query <- paste0("SELECT  agent.name AS agent, method.name AS method, COUNT(task.task_id), AVG(results.value)
                FROM results, agent_is, task_is, agent, task, method
                WHERE results.agent_is_id = agent_is.is_id AND agent_is.agent_id = agent.agent_id AND 
                results.task_is_id = task_is.is_id AND task_is.task_id = task.task_id AND
                results.method_id = method.method_id
                GROUP BY method.method_id
                ")
send_SQL(db,query)


query <- paste0("SELECT * 
                FROM 
                (SELECT
                r.value AS score,
                a.name AS agent,
                t.name AS task,
                m.name AS method,
                SUM(CASE WHEN ma.name = 'Frames_train' THEN mav.value END) AS frames_training,
                MAX(CASE WHEN ma.name = 'Procedure' THEN mav.value END) AS train_procedure
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a ON ai.agent_id = a.agent_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t ON ti.task_id = t.task_id
                LEFT JOIN method AS m ON r.method_id = m.method_id
                LEFT JOIN method_has AS mh ON mh.method_id = m.method_id
                LEFT JOIN method_attribute_value AS mav ON mav.attribute_value_id = mh.attribute_value_id
                LEFT JOIN method_attribute AS ma ON ma.attribute_id = mav.attribute_id
                GROUP by r.value, a.name, t.name, m.name) AS r1
                WHERE
                r1.frames_training = '200'
                AND (r1.train_procedure = 'hs' OR r1.train_procedure = 'noop') AND r1.task = 'Beam Rider'               
                ")

send_SQL(db,query)


query <- paste0("SELECT a1.name as agent, a2.name AS agent_is
		FROM agent_is ai 
			LEFT JOIN agent a1 ON ai.agent_id = a1.agent_id 
            LEFT JOIN agent a2 ON ai.agent_id_in = a2.agent_id
		WHERE a2.name = 'Deep Reinforcement Learning'             
                ")

send_SQL(db,query)


queryPareto <- paste0("SELECT
                a.name AS agent,
                t.name AS task,
                m.name AS method,
                ah.name AS hierarchy,
                MAX(CASE WHEN r.metric = 'area.under.roc.curve' THEN r.value END) AS AUC,
                MAX(CASE WHEN r.metric = 'usercpu.time.millis.training' THEN r.value END) AS TIME_TRAIN
                FROM
                results AS r
                LEFT JOIN agent_is AS ai ON r.agent_is_id = ai.is_id
                LEFT JOIN agent AS a ON ai.agent_id = a.agent_id
                LEFT JOIN task_is AS ti ON r.task_is_id = ti.is_id
                LEFT JOIN task AS t ON ti.task_id = t.task_id
                LEFT JOIN method AS m ON r.method_id = m.method_id
                LEFT JOIN agent_belongs_to_hierarchy AS abh ON  abh.is_id = ai.is_id
                LEFT JOIN agent_hierarchy AS ah ON ah.hierarchy_id = abh.hierarchy_id				
                WHERE  
					(r.metric = 'area.under.roc.curve' OR r.metric = 'usercpu.time.millis.training') AND
					ah.name IN ('weka', 'ml', 'sklearn', 'rm')
                GROUP by  a.name, t.name, m.name, ah.name")

t <- send_SQL(db,queryPareto)
unique(t$task)


t.anneal <- filter(t, task == "anneal")











queryTasks <- paste0("SELECT
t.name AS task, th.name AS th
FROM
task_belongs_to_hierarchy AS tbh 
LEFT JOIN task_hierarchy AS th ON th.hierarchy_id = tbh.hierarchy_id
LEFT JOIN task_is AS ti ON tbh.is_id = ti.is_id 
LEFT JOIN task AS t ON ti.task_id = t.task_id")

t <- send_SQL(db,queryTasks)



### ALL data counts

agent_h = "Default"
task_h = "Default"

getTotals <- function(agent_h, task_h){
  source("AICollab_DB_funcs.R")
  queryALL <-paste0("SELECT
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
                WHERE ah.name = '",agent_h,"' AND th.name = '",task_h,"'
                GROUP by r.value, a.name, t.name, m.name")
  
  t <- send_SQL(db,queryALL)
  
  View(t)
  print(paste("Agents:", length(unique(t$agent))))
  print(paste("Tasks:",length(unique(t$task))))
  print(paste("Methods:",length(unique(t$method))))
  print(paste("Results:", nrow(t)))
}

# ALE results
getTotals(agent_h = "Default", task_h = "Default")
getTotals(agent_h = "Hominoidea", task_h = "Default")

# OpenML
getTotals(agent_h = "weka", task_h = "OML datasets")
getTotals(agent_h = "mlr", task_h = "OML datasets")
getTotals(agent_h = "sklearn", task_h = "OML datasets")
getTotals(agent_h = "openml", task_h = "OML datasets")
getTotals(agent_h = "rm", task_h = "OML datasets")



###??? Get all sources

q <- paste0("SELECT * FROM atlasofintelligence.source")
sources <- send_SQL(db,q)
library("knitr")
kable(unique(sources[2:26,c(4,3)]), format = "markdown", padding = 0, row.names = F)
      
       