library(rjson)
library(dplyr)
library(stringr)
require(dplyr)

options(stringsAsFactors=FALSE)
options(scipen=999999)

# ----------------------------------------------------------------------------------------------------------------------------------------------
# Reading --------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------


json_file <- "Data/AI/papersWithCode/evaluation-tables.json"
json_data <- fromJSON(paste(readLines(json_file), collapse=""))

View(json_data)

# 
# jsonTask = json_data[[7]]


myprint <- function(text, file = "temp.txt"){
  write(text, file, append = T)
  }
# 

myrbind <- function(a,b){
  l = list(a,b)
  t <-  do.call(rbind, lapply(l, function(x) x[match(names(l[[1]]), names(x))]))
  return(t)
}

# 
# task = json_data[[6]]
# task = json_data[[7]]
# task = json_data[[115]]
# task = json_data[[55]]
# task = json_data[[96]]

# datos <- data.frame()
# get_task_pwc(task, row = NULL, 1)
# datos



datos <- data.frame()
colnames(datos) <- c("category.1", "task.1", "description.1",
                     "category.2", "task.2", "description.2",
                     "category.3", "task.3", "description.3",
                     "category.4", "task.4", "description.4",
                     "category.5", "task.5", "description.5",
                     )
  
for(i in 1:length(json_data)){
  
  get_task_pwc(json_data[[i]], row = NULL, 1)
  
}

View(datos)
saveRDS(datos, file = "pwc.allData_08042019.rds")


# ----------------------------------------------------------------------------------------------------------------------------------------------
# Cleansing ---------------------------------------------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------

# sota.values


datos <-readRDS("pwc.allData_08042019.rds")
datos.f <- filter(datos, !is.na(dataset.name) & !is.na(sota.model))


replaceRubish <- function(datos.f, column, regex, by){
  datos.df <- data.frame(datos.f)
  col = which(colnames(datos.f) == column)
  
  t <- datos.f %>% filter(str_detect(datos.df[,col], regex)) # ,
  temp <- str_replace_all(datos.df[,col], regex, by) #
  now <- temp %>% str_detect(regex) %>% sum   #"%"
  past <- datos.df[,col] %>% str_detect(regex) %>% sum   
  datos.df[,col] <- temp
  print(paste("There were",past,"rows with",regex,"in column",column,"(now: ", now, ")" ))
  return(datos.df)
  
}

datos.f.bak <- datos.f
datos.f <- datos.f.bak

# weird data in values
table(unlist(str_extract_all((datos.f$sota.values), "\\D+")))

# -----------------------------------------------------------------------
datos.f <- datos.f %>% filter(!str_detect(datos.f$sota.values, "^-[:punct:]+")) # "--"  "---" "--*" "--*" "--*" "--*"
datos.f %>% filter(str_detect(datos.f$sota.values, "^-[:punct:]+"))
# -----------------------------------------------------------------------
datos.f <- datos.f %>% filter(!str_detect(datos.f$sota.values, "^[-]$")) #"-"
datos.f %>% filter(str_detect(datos.f$sota.values, "^[-]$")) #"-"
# -----------------------------------------------------------------------
datos.f <- datos.f %>% filter(!str_detect(datos.f$sota.values, "-")) #"-"
datos.f %>% filter(str_detect(datos.f$sota.values, "-")) #"-"
# -----------------------------------------------------------------------
datos.f <- filter(datos.f, !sota.values == "") #""
datos.f %>% filter(sota.values == "") #""
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
datos.f %>% filter(str_detect(datos.f$sota.values, "-")) # "-" longer than "minus" "-"
datos.f <- as_tibble(replaceRubish(datos.f, "sota.values", "-", ""))
datos.f %>% filter(str_detect(datos.f$sota.values, ",")) # ,
# -----------------------------------------------------------------------
datos.f %>% filter(str_detect(datos.f$sota.values, "[*]")) # "%"
datos.f <- as_tibble(replaceRubish(datos.f, "sota.values", "[*]", ""))
datos.f %>% filter(str_detect(datos.f$sota.values, "[*]")) # "%"
# -----------------------------------------------------------------------
datos.f %>% filter(str_detect(datos.f$sota.values, "%")) # "%"
datos.f <- as_tibble(replaceRubish(datos.f, "sota.values", "%", ""))
datos.f %>% filter(str_detect(datos.f$sota.values, "%")) # "%"
# -----------------------------------------------------------------------
datos.f %>% filter(str_detect(datos.f$sota.values, "measured ")) # "measured by..."
datos.f <- as_tibble(replaceRubish(datos.f, "sota.values", "(measured by Ge et al., 2018)", ""))
datos.f %>% filter(str_detect(datos.f$sota.values, "measured ")) # "measured by..."
# -----------------------------------------------------------------------
datos.f %>% filter(str_detect(datos.f$sota.values, "±[:digit:]")) # "±"
datos.f <- as_tibble(replaceRubish(datos.f, "sota.values", "±[:digit:]", ""))
datos.f %>% filter(str_detect(datos.f$sota.values, "±[:digit:]")) # "±"
# -----------------------------------------------------------------------
datos.f %>% filter(str_detect(datos.f$sota.values, "[\\(|\\)]")) # ()
datos.f <- as_tibble(replaceRubish(datos.f, "sota.values", "[\\(|\\)]", ""))
datos.f %>% filter(str_detect(datos.f$sota.values, "[\\(|\\)]")) # ()
# -----------------------------------------------------------------------
datos.f %>% filter(str_detect(datos.f$sota.values, ",")) # ,
datos.f <- as_tibble(replaceRubish(datos.f, "sota.values", ",", ""))
datos.f %>% filter(str_detect(datos.f$sota.values, ",")) # ,
# -----------------------------------------------------------------------
datos.f %>% filter(str_detect(datos.f$sota.values, "\\+")) # +
datos.f <- as_tibble(replaceRubish(datos.f, "sota.values", "\\+", ""))
datos.f %>% filter(str_detect(datos.f$sota.values, ",")) # ,
# -----------------------------------------------------------------------
datos.f %>% filter(str_detect(datos.f$sota.values, " ")) # "  "
datos.f <- as_tibble(replaceRubish(datos.f, "sota.values", " ", ""))
datos.f %>% filter(str_detect(datos.f$sota.values, ",")) # ,
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
t <- datos.f %>% filter(str_detect(datos.f$sota.values, "/")) # "/"
t2 <- NULL

for (i in 1:nrow(t)){
    if (t$sota.metric[i] == "MRPC"){
      t1temp <- t[i,]
      t1temp$sota.metric <- "MRPC Accuracy"
      t1temp$sota.values <- strsplit(t1temp$sota.values, "/")[[1]][1]
      t2temp <- t[i,]
      t2temp$sota.metric <- "MRPC F1"
      t2temp$sota.values <- strsplit(t2temp$sota.values, "/")[[1]][2]      
      t2 <- rbind(t2, t1temp, t2temp)
    }else{
      if (t$sota.metric[i] == "STS"){
        t1temp <- t[i,]
        t1temp$sota.metric <- "STS Accuracy"
        t1temp$sota.values <- strsplit(t1temp$sota.values, "/")[[1]][1]
        t2temp <- t[i,]
        t2temp$sota.metric <- "STS Spearman"
        t2temp$sota.values <- strsplit(t2temp$sota.values, "/")[[1]][2]      
        t2 <- rbind(t2, t1temp, t2temp)
      }else{
          t1temp <- t[i,]
          t1temp$sota.values <- strsplit(t1temp$sota.values, "/")[[1]][1]
          t2 <- rbind(t2, t1temp)
      }
    }
    
}
datos.f <- datos.f %>% filter(!str_detect(datos.f$sota.values, "/")) # "/"
datos.f <- rbind(datos.f, t2)
# -----------------------------------------------------------------------
datos.f$sota.values <- str_trim(datos.f$sota.values)
table(unlist(str_extract_all(datos.f$sota.values, "\\D+")))
datos.f[str_detect(datos.f$sota.values, "[B|k|m|M]"),"sota.metric"]<- "Parameters" # "B" (Billions of params) "k" "m" "M"-> must be AGENT attribute ("Params", "Number of params", "Parameters") 157 rows


# Dulicate entries -----------------------------------------------------------------------

filter3 <- unique(datos.f$task.3)[-1]
filter2 <- unique(datos.f$task.2)[-1]


datos.f2 <- datos.f
datos.f2 <- data.frame(datos.f2)
nrow(datos.f2)


for (i in 1:length(filter3)){
  if(filter3[i] %in% filter2){
    ind <- which(datos.f2$task.2 %in% filter3[i])
    print(length(ind))
    datos.f2 <- datos.f2[-ind,]
  }
  if(filter3[i] %in% filter1){
     ind <- which(datos.f2$task.1 %in% filter3[i])
     print(length(ind))
     datos.f2 <- datos.f2[-ind,]
     
   }
}

nrow(datos.f2)
filter2 <- unique(datos.f2$task.2)[-1]
filter1 <- unique(datos.f2$task.1)

for (i in 1:length(filter2)){
  if(filter2[i] %in% filter1){
    ind <- which(datos.f2$task.1 %in% filter2[i])
    print(i)
    print(filter2[i])
    print(length(ind))
    datos.f2 <- datos.f2[-ind,]
    print(nrow(datos.f2))
  }
}

nrow(datos.f2)
colnames(datos.f2)
datos.f2 <- select(datos.f2, category.1,task.1,description.1,task.2, description.2,task.3,description.3,task.4,description.4,
       dataset.name,dataset.description,dataset.link,sota.model,sota.title,sota.url,sota.date,sota.metric,sota.values)


saveRDS(datos.f2, "PwC_data_clean.rds")









# ----------------------------------------------------------------------------------------------------------------------------------------------
# Get data from json recursively ---------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------------------------------
get_task_pwc <- function(task, row = NULL, id = 1){
  
  temp = data.frame()


  if (length(task$subtasks) == 0){
    if(!is.null(row)){
      t1 <- as.character(c(row, 
            ifelse(length(task$categories)!=0, task$categories, ""),
            task$task,
            task$description))
      names(t1) <- c(names(row), paste0("category.",id), paste0("task.",id), paste0("description.",id))
      
    }else{
      t1 <- as.character(c(ifelse(length(task$categories)!=0, task$categories, ""),
                           task$task,
                           task$description))
      names(t1) <- c(paste0("category.",id), paste0("task.",id), paste0("description.",id))
      
    }
    
    if(length(task$datasets) != 0 ){
      t2 <- get_datasets_pwc(task$datasets,t1)
      datos <<- bind_rows(t2, datos)
    }else{
      datos <<- bind_rows(t1, datos)
    }
  
  
  }else{
    
    if(!is.null(row)){
      t1 <- as.character(c(row, 
                           ifelse(length(task$categories)!=0, task$categories, ""),
                           task$task,
                           task$description))
      names(t1) <- c(names(row), paste0("category.",id), paste0("task.",id), paste0("description.",id))
    }else{
      t1 <- as.character(c(ifelse(length(task$categories)!=0, task$categories, ""),
                           task$task,
                           task$description))
      names(t1) <- c(names(row), paste0("category.",id), paste0("task.",id), paste0("description.",id))
    }
    
    t2 <- get_datasets_pwc(task$datasets,t1)
    datos <<- bind_rows(t2,datos)
    
    for(i in 1:length(task$subtasks)){
      
      get_task_pwc(task$subtasks[[i]], t1, id+1) 
      
    }
    
  }
  
  
}


# datasets = json_data[[96]]$subtasks[[1]]$datasets
# datasets = json_data[[55]]$datasets
# get_datasets_pwc(datasets,row)
# datasets = task$datasets
# row = t1

get_datasets_pwc <- function(datasets, row){
  

  temp = data.frame()
  if(length(datasets)==0){
    return(row)
  }else{
    for(i in 1:length(datasets)){
      
      link <- ifelse(length(datasets[[i]]$dataset_links)!=0, datasets[[i]]$dataset_links[[1]]$url, "")
      t1 <- c(row, 
              dataset.name = datasets[[i]]$dataset,
              dataset.description = datasets[[i]]$description,
              dataset.link = link)
      
      if(length(datasets[[i]]$sota)!=0){
        t1 <- get_sota_pwc(datasets[[i]]$sota$sota_rows, t1)
      }
      temp <- bind_rows(temp, t1) 
      # temp <- myrbind(temp, t1)
      # colnames(temp) <- names(t1)
    }
    return(temp)
  }
}

# sota_rows = json_data[[96]]$subtasks[[1]]$datasets[[1]]$sota$sota_rows

# sota_rows = json_data[[55]]$datasets[[1]]$sota$sota_rows
# get_sota_pwc(sota_rows,row)
# sota_rows = datasets[[i]]$sota$sota_rows
# row = t1

get_sota_pwc <- function(sota_rows, row){
  # print(sota_rows)
  # print(row)
  require(lubridate)
  temp = data.frame()
  if(length(sota_rows)==0){
    return(row)
  }else{
  
      for(i in 1:length(sota_rows)){
      t1 <- c(row, 
              sota.model = sota_rows[[i]]$model_name,
              sota.title = sota_rows[[i]]$paper_title,
              sota.url = sota_rows[[i]]$paper_url,
              sota.date = ifelse(!is.null(sota_rows[[i]]$paper_date), as.character(as_date(ymd(sota_rows[[i]]$paper_date))), "")
              )
      t2 <- get_metrics_pwc(sota_rows[[i]]$metrics, t1)
      temp <- rbind(temp, t2)    
      colnames(temp) <- names(t2)
      
    }
    return(temp)
  }
  
  
}


# metrics = json_data[[55]]$datasets[[1]]$sota$sota_rows[[2]]$metrics
# get_metrics_pwc(metrics, row)


get_metrics_pwc <- function (metrics, row){
  temp = data.frame(stringsAsFactors = F)
  if(length(metrics)==0){
    return(row)
  }else{
    for(i in 1:length(metrics)){
      temp <- rbind(temp, c(row, c(sota.metric = names(metrics)[i], sota.value = unlist(metrics[[i]]))))
      
    }
    # print(temp)
    # print(names(row))
    # print(row)
    # print(names(row))
    # print(colnames(temp))
    
    colnames(temp) <- c(names(row), "sota.metric", "sota.values")
    return(temp)
  }
  
}






