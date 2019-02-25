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
#  - V.1.0    1 Jan 2019. 
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
options( java.parameters = "-Xmx6g" )

.lib<- c("tidyverse", "readxl", "data.table", "RMariaDB", "plyr", "dplyr")

.inst <- .lib %in% installed.packages()
if (length(.lib[!.inst])>0) install.packages(.lib[!.inst], repos=c("http://rstudio.org/_packages", "http://cran.rstudio.com")) 
lapply(.lib, require, character.only=TRUE)

set.seed(288)

# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------


# -----------------------------------------------------------------------------------------------------------------------
# MySQL general functions
# -----------------------------------------------------------------------------------------------------------------------

# Clean string to be inserted
cleanSQLstring <- function(s){
  s2 <- gsub("\"", "", s, fixed = T)
  s3 <- gsub("\'", "", s2, fixed = T)
  return(s3)
}

# Connection to the DB
connectAtlasDB <- function(){
  #db <- dbConnect(RMariaDB::MariaDB(), user='atlas_admin', password="Atlas@2018.admin", dbname='atlasofintelligence', host='localhost')
  rmariadb.settingsfile<-"MySQL/atlasofintelligenceDB.cnf"
  rmariadb.db<-"atlasofintelligence"
  db<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db) 
  #print(dbListTables(db))
  return(db)
}

# Return all data from table
select_all <- function(tab_name){
  db <- connectAtlasDB()
  out <- dbReadTable(db,tab_name)
  #print(out)
  #dbClearResult(out)
  dbDisconnect(db)
  return(out)
}

# Delete all data from table
delete_all <- function(tab_name){
  db <- connectAtlasDB()
  q<- paste0("DELETE FROM ", tab_name)
  rs = dbSendQuery(db,q)
  print(dbFetch(rs))
  dbClearResult(rs)
  dbDisconnect(db)
  
}

# Insert data from DF to table-
insert_df_table <- function(data, atts, table, cols){
  db <- connectAtlasDB()
  data2 <- as.data.frame(data[, atts]) #need dplyr
  values <- paste0(apply(data2, 1, function(x) paste0("('", paste0(x, collapse = "', '"), "')")), collapse = ", ")
  colsSQL <- paste0(cols,collapse = ", ")
  query <- paste0("INSERT INTO ",table," (",colsSQL,") VALUES ", values, ";")
  # Execute the query on the storiesDb that we connected to above.
  rsInsert <- dbSendQuery(db, query)
  # Clear the result.
  dbClearResult(rsInsert)
  # Disconnect to clean up the connection to the database.
  print("Insertion Succesful!")
  dbDisconnect(db)
  select_all(table)
  
}

# Insert data from DF to table and return generated (last) ID
insert_df_table_id <- function(data, atts, table, cols){
  db <- connectAtlasDB()
  data2 <- select(data, atts) #need dplyr
  values <- paste0(apply(data2, 1, function(x) paste0("('", paste0(x, collapse = "', '"), "')")), collapse = ", ")
  colsSQL <- paste0(cols,collapse = ", ")
  query <- paste0("INSERT INTO ",table," (",colsSQL,") VALUES ", values, ";")
  # Execute the query on the storiesDb that we connected to above.
  rsInsert <- dbSendQuery(db, query)
  # Clear the result.
  dbClearResult(rsInsert)
  print("Insertion Succesful!")
  
  query <- paste0("SELECT LAST_INSERT_ID();")
  # Execute the query on the storiesDb that we connected to above.
  rsSelect <- dbSendQuery(db, query)
  id <- dbFetch(rsSelect)
  dbClearResult(rsSelect)
  
  # Disconnect to clean up the connection to the database.
  
  dbDisconnect(db)
  select_all(table)
  
  return(as.numeric(id[1,1]))
  
}


# rowData = data.frame(name = at, description = at); attsData =  c("name","description"); tableMySQL = "agent_attribute"; colsMySQL = c("name","description")
# rowData = data.frame(agent_is_id,hierarchy_id); attsData =  c("agent_is_id","hierarchy_id"); tableMySQL = "agent_belongs_to_hierarchy"; colsMySQL = c("is_id","hierarchy_id")
# rowData = t4[63,]; attsData =  c("result", "metric", "agent_is", "task_is", "method.y"); tableMySQL =  "results"; colsMySQL =  c("value", "metric", "agent_is_id", "task_is_id", "method_id")
# rowData = taskTable[1,]; attsData =  c("task"); tableMySQL =  "task"; colsMySQL =  c("name")
# rowData = t4[a,]; attsData =  c("result", "metric", "agent_is", "task_is", "method.y"); tableMySQL ="results"; colsMySQL =  c("value", "metric", "agent_is_id", "task_is_id", "method_id")
#rowData = cleanTable[a,]; attsData =  "method"; tableMySQL =  "method";  colsMySQL = "name"

# Data insertion by row
insert_row_table_id <- function(db, rowData, attsData, tableMySQL, colsMySQL, verbose = FALSE){
  
  # db <- connectAtlasDB()
  row2 <- select(rowData, attsData) #need dplyr  
  lettersID <- letters[1:ncol(row2)]
  #values <- paste0(apply(row2, 1, function(x) paste0("'", paste0(x, collapse = "', '"), "'")), collapse = ", ")
  values <- paste0(apply(row2, 1, function(x) paste0("'", paste0(x, "' ",lettersID, collapse = ", '"), "'")), collapse = ", ")
  values <- substr(values,1,nchar(values)-1)
  
  colsSQL <- paste0(colsMySQL,collapse = ", ")

  queryCHECK <- paste0("SELECT * FROM ", tableMySQL," WHERE ", collapse = "")
  for(i in 1:length(colsMySQL)){
    queryCHECK <- paste0(queryCHECK, paste0(colsMySQL[i]," = '",as.character(row2[,attsData[i]]),"' AND ", collapse = "") )
  }
  queryCHECK <- gsub('.{4}$', '', queryCHECK)
  query <- paste0("INSERT INTO ",tableMySQL," (",colsSQL,") SELECT * FROM (SELECT ", values, ") AS tmp WHERE NOT EXISTS (",queryCHECK,") LIMIT 1")
  if(verbose){print(query)}
  
  # Execute the query on the storiesDb that we connected to above.
  rsInsert <- dbSendQuery(db, query)
# Clear the result.
  #if(verbose){print(rsInsert)}
  dbClearResult(rsInsert)
  
  query <- queryCHECK
  # Execute the query on the storiesDb that we connected to above.
  rsSelect <- dbSendQuery(db, query)
  if(verbose){print(rsSelect)}
  id <- dbFetch(rsSelect)
  dbClearResult(rsSelect)
  
  # Disconnect to clean up the connection to the database.
  
  #dbDisconnect(db)
  if(verbose){  print(dbReadTable(db,tableMySQL))}
  
  return(as.numeric(id[1,1]))
}

# Delete DB
delete_Atlas <- function(){
  
  
  delete_all("results")
  delete_all("agent_has")
  delete_all("agent_attribute_value")
  delete_all("agent_attribute")
  delete_all("agent_belongs_to_hierarchy")
  delete_all("agent_hierarchy")
  delete_all("agent_is")
  delete_all("agent")
  
  delete_all("task_has")
  delete_all("task_attribute_value")
  delete_all("task_attribute")
  delete_all("task_belongs_to_hierarchy")
  delete_all("task_hierarchy")
  delete_all("task_is")
  delete_all("task")
  
  delete_all("method_has")
  delete_all("method_attribute_value")
  delete_all("method_attribute")
  delete_all("method")
  
  delete_all("source")
}

# Send SQL
send_SQL <- function(db, query){
  rs <- dbSendQuery(db, query)
  res <- dbFetch(rs)
  # Clear the result.
  dbClearResult(rs)
  # Disconnect to clean up the connection to the database.
  return(res)
}

# -----------------------------------------------------------------------------------------------------------------------
# MySQL insert [A]I Collaboratory data functions
# -----------------------------------------------------------------------------------------------------------------------

checkTable <- function(table, dimension){
  table <- as.data.frame(table)
  table <- as.data.frame(lapply(table, as.character), stringsAsFactors=FALSE)
  if (dimension == "source"){
    if (sum(is.na(table$name))>0 | length(table[table$name == "", "name"]) > 0){
      print("Table source: name is missing")
      return(NULL)
    }
    table[is.na(table$link), "link"] <- "No link"
    table[is.na(table$description), "description"] <- "No description"
    
    table[table$link == "", "link"] <- "No link"
    table[table$description == "", "description"] <- "No description"
    
    table2 = colwise(type.convert)(table)
    return(table2)
    }
  else{
    if (dimension == "agent"){
      if (sum(is.na(table$agent))>0 | length(table[table$agent == "", "agent"]) > 0){
        print("Table agent: AGENT is missing")
        return(NULL)
      } 
      table[is.na(table$agent_is), "agent_is"] <- "Default"
      table[is.na(table$source), "source"] <- "Default"
      table[is.na(table$hierarchy_belongs), "hierarchy_belongs"] <- "Default"
      
      table[table$agent_is == "", "agent_is"] <- "Default"
      table[table$source == "", "source"] <- "Default"
      table[table$hierarchy_belongs == "", "hierarchy_belongs"] <- "Default"
      
      
      table2 = colwise(type.convert)(table)
      return(table2)
    }
    else{
      if(dimension == "task"){
        if (sum(is.na(table$task))>0 | length(table[table$task == "", "task"]) > 0){
          print("Table task: TASK is missing")
          return(NULL)
        } 
        table[is.na(table$task_is), "task_is"] <- "Default"
        table[is.na(table$source), "source"] <- "Default"
        table[is.na(table$hierarchy_belongs), "hierarchy_belongs"] <- "Default"
        
        table[table$task_is == "", "task_is"] <- "Default"
        table[table$source == "", "source"] <- "Default"
        table[table$hierarchy_belongs == "", "hierarchy_belongs"] <- "Default"
        
        table2 = colwise(type.convert)(table)
        return(table2)
      }
      else{
        if(dimension == "method"){
          if (sum(is.na(table$method))>0 | length(table[table$method == "", "method"]) > 0){
            print("Table method: METHOD is missing")
            return(NULL)
          } 
          
          table2 = colwise(type.convert)(table)
          return(table2)
        }
        else{
          if(dimension == "result"){
            if (sum(is.na(table))>0 | nrow(table[table == "", ]) > 0){
              print("Table Result: RESULT is missing")
              print(table)
              return(NULL)
            } 
            table2 = colwise(type.convert)(table)
            return(table2)
          }
        }
        
      }
      
    }
  }
}

# Source
# -----------------------------------------------------------------------------------------------------------------------

insert_source <- function(sourceTable){
  
  cleanTable <- checkTable(sourceTable,"source")
  
  if (!is.null(cleanTable)){
    db <- connectAtlasDB()
    atts <- c("name","link","description")
    for(s in 1:nrow(cleanTable)){ 
      print(paste0("Inserting SOURCE: ", paste0(cleanTable[s,1])))
      insert_row_table_id(db, cleanTable[s,], atts, "source", atts)
      
    }
    # insert_df_table(cleanTable, atts, "source", atts)
  }
}
#insert_source(sourceTable)

# Agents
# -----------------------------------------------------------------------------------------------------------------------

# agentTable <- agent
insert_agent <- function(agentTable){
  
  cleanTable <- checkTable(agentTable,"agent")
  output <- data.frame(agent_name = NA, agent = NA, agent_is = NA)
  
  if (!is.null(cleanTable)){
    
    atts <- c("agent")
    cols <- c("name") 
    
    db <- connectAtlasDB()
    for(a in 1:nrow(cleanTable)){
      
      print(paste0("Inserting AGENT: ", paste0(cleanTable[a,atts])))
      
      # AGENT
      agent_name = as.character(cleanTable[a,"agent"])
      agent_id = insert_row_table_id(db, cleanTable[a,], "agent", "agent", "name")
      agent_id_in = insert_row_table_id(db, cleanTable[a,], "agent_is", "agent", "name")
      
      
      # AGENT_IS
      querySource <- paste0("SELECT * FROM source WHERE name = '", cleanTable[a,"source"],"'", collapse ="")
      rsSelect <- dbSendQuery(db, querySource)
      id <- dbFetch(rsSelect)
      dbClearResult(rsSelect)
      source_id = id[1,1]
      agent_is_id = insert_row_table_id(db, data.frame(agent_id,agent_id_in,source_id,weight = cleanTable[a,"weight"]), c("agent_id","agent_id_in","source_id","weight"), "agent_is", c("agent_id","agent_id_in","source_id","weight"))

      #AGENT_BELONGS_TO HIERARCHY
      hierarchy_id = insert_row_table_id(db, cleanTable[a,], "hierarchy_belongs", "agent_hierarchy", "name")
      belongs_to_hierarchy_id = insert_row_table_id(db, data.frame(agent_is_id,hierarchy_id), c("agent_is_id","hierarchy_id"), "agent_belongs_to_hierarchy", c("is_id","hierarchy_id"))
      
      # AGENT_HAS
      attributes <- colnames(cleanTable)[!(colnames(cleanTable) %in% c("agent","agent_is","hierarchy_belongs","source", "weight"))]
      for (at in attributes){
        attribute_id = insert_row_table_id(db, data.frame(name = at, description = paste0(at,"_description",collapse = "")), c("name","description"), "agent_attribute", c("name","description"))

        #val = as.character(cleanTable[a,at])
        #val = gsub("\"", "\\\\\'", as.character(cleanTable[a,at]), fixed = T)
        #val = gsub("\\'", "\\\\'", as.character(cleanTable[a,at]))
        val = cleanSQLstring(cleanTable[a,at])
        attribute_value_id = insert_row_table_id(db, data.frame(value = val, attribute_id), c("value","attribute_id"), "agent_attribute_value", c("value","attribute_id"))
        agent_has_id = insert_row_table_id(db, data.frame(agent_id, attribute_value_id), c("agent_id","attribute_value_id"), "agent_has", c("agent_id","attribute_value_id"))
      }
      
      output <- rbind(output,c(agent_name, agent_id,agent_is_id))
      
    }
    dbDisconnect(db)
    
    
  }
  output <- output[-1,]
  return(output)
  
}

# Tasks
# -----------------------------------------------------------------------------------------------------------------------

# taskTable <- task
insert_task <- function(taskTable){
  
  cleanTable <- checkTable(taskTable,"task")
  output <- data.frame(task_name = NA, task = NA, task_is = NA)
  
  if (!is.null(cleanTable)){
    
    db <- connectAtlasDB()
    for(a in 1:nrow(cleanTable)){
      
      print(paste0("Inserting TASK: ", paste0(cleanTable[a,1], collapse =" ")))
      
      # TASK
      task_name = as.character(cleanTable[a,"task"])
      task_id = insert_row_table_id(db, cleanTable[a,], "task", "task", "name")
      task_id_in = insert_row_table_id(db, cleanTable[a,], "task_is", "task", "name")
      
      # TASK_IS
      querySource <- paste0("SELECT * FROM source WHERE name = '", cleanTable[a,"source"],"'", collapse ="")
      rsSelect <- dbSendQuery(db, querySource)
      id <- dbFetch(rsSelect)
      dbClearResult(rsSelect)
      source_id = id[1,1]
      task_is_id = insert_row_table_id(db, data.frame(task_id,task_id_in,source_id, weight = cleanTable[a,"weight"]), c("task_id","task_id_in","source_id","weight"), "task_is", c("task_id","task_id_in","source_id","weight"))
      
      #TASK_BELONGS_TO HIERARCHY
      hierarchy_id = insert_row_table_id(db, cleanTable[a,], "hierarchy_belongs", "task_hierarchy", "name")
      belongs_to_hierarchy_id = insert_row_table_id(db, data.frame(task_is_id,hierarchy_id), c("task_is_id","hierarchy_id"), "task_belongs_to_hierarchy", c("is_id","hierarchy_id"))
      
      # TASK_HAS
      attributes <- colnames(cleanTable)[!(colnames(cleanTable) %in% c("task","task_is","hierarchy_belongs","source","weight"))]
      for (at in attributes){
        attribute_id = insert_row_table_id(db, data.frame(name = at, description = paste0(at,"_description",collapse = "")), c("name","description"), "task_attribute", c("name","description"))
        attribute_value_id = insert_row_table_id(db, data.frame(value = cleanTable[a,at], attribute_id), c("value","attribute_id"), "task_attribute_value", c("value","attribute_id"))
        task_has_id = insert_row_table_id(db, data.frame(task_id, attribute_value_id), c("task_id","attribute_value_id"), "task_has", c("task_id","attribute_value_id"))
      }
      output <- rbind(output,c(task_name,task_id,task_is_id))
      
    }
    dbDisconnect(db)
    
  }
  output <- output[-1,]
  
  return(output)
  
  
}

# Methods
# -----------------------------------------------------------------------------------------------------------------------

# methodTable <- method
insert_method <- function(methodTable){
  
  cleanTable <- checkTable(methodTable,"method")
  output <- data.frame(method_name = NA, method = NA)
  
  
  if (!is.null(cleanTable)){
    
    db <- connectAtlasDB()
    for(a in 1:nrow(cleanTable)){
      
      print(paste0("Inserting METHOD: ", paste0(cleanTable[a,1], collapse =" ")))
      
      # METHOD
      method_name = as.character(cleanTable[a,"method"])
      method_id = insert_row_table_id(db, cleanTable[a,], "method", "method", "name")
      
      querySource <- paste0("SELECT * FROM source WHERE name = '", cleanTable[a,"source"],"'", collapse ="")
      rsSelect <- dbSendQuery(db, querySource)
      id <- dbFetch(rsSelect)
      dbClearResult(rsSelect)
      source_id = id[1,1]
      
      # METHOD_HAS
      attributes <- colnames(cleanTable)[!(colnames(cleanTable) %in% c("method", "source"))]
      for (at in attributes){
        attribute_id = insert_row_table_id(db, data.frame(name = at, description = paste0(at,"_description",collapse = "")), c("name","description"), "method_attribute", c("name","description"))
        attribute_value_id = insert_row_table_id(db, data.frame(value = cleanTable[a,at], attribute_id), c("value","attribute_id"), "method_attribute_value", c("value","attribute_id"))
        method_has_id = insert_row_table_id(db, data.frame(method_id, attribute_value_id, source_id), c("method_id","attribute_value_id", "source_id"), "method_has", c("method_id","attribute_value_id", "source_id"))
      }
      output <- rbind(output,c(method_name,method_id))
      
    }
    dbDisconnect(db)
    
  }
  output <- output[-1,]
  
  return(output)
  
  
}

# Results
# -----------------------------------------------------------------------------------------------------------------------

#resultsTable <- results
insert_resuts <- function(resultsTable, ids_agent, ids_task, ids_method){
  
  cleanTable <- checkTable(resultsTable,"result")

  if (!is.null(cleanTable)){
    
    t2 <- merge(cleanTable, unique(ids_agent), by.x = "agent", by.y = "agent_name", all.x = T)
    t3 <- merge(t2, ids_task, by.x = "task", by.y = "task_name")
    t4 <- merge(t3, ids_method, by.x = "method", by.y = "method_name")
    #t5 <- select(t4, result, metric, agent_is, task_is, method.y)
    db <- connectAtlasDB()
    for(a in 1:nrow(t4)){
      
      #print(paste0("Inserting RESULTS: ", paste0(t4[a,"agent"], " -- ", t4[a,"task"], collapse =" ")))
      # RESULT
      insert_row_table_id(db, t4[a,], c("result", "metric", "agent_is", "task_is", "method.y"), 
                                      "results", c("value", "metric", "agent_is_id", "task_is_id", "method_id"), verbose = F)
    }
    dbDisconnect(db)
    
  }

}
#insert_resuts(resultsTable, ids_agent, ids_task, ids_method)
