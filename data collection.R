library(rcrossref)
library(roadoi)
library(dplyr)
library(purrr)
library(stringr)
library(tidyr)
library(jsonlite)
source("D:\\the moslim scientist's folder\\algorithms project after some new updates\\Dates.R")


Sys.setenv(crossref_email = "sohaila.kandil@ejust.edu.eg")
data_file <- "D:\\the moslim scientist's folder\\algorithms project after some new updates\\final data collection in shaa alah\\papers_data_from_rcrossref_Sudan.csv"
total_papers <- 0



for (x in seq_len(length(dates) - 1)) {
  tryCatch({
    papers_data <- cr_works( works = TRUE , filter = c(has_affiliation = "TRUE" , has_references = "TRUE" , from_pub_date = dates[x] , until_pub_date = dates[x+1]) , flq = c(query.affiliation = "Sudan" ), limit = 1000) %>%
      purrr::pluck("data") #%>%
    #dplyr::select(title, doi, volume, issue, issued, publisher, author, reference, references.count)
    
    total_papers <- total_papers + length(papers_data)
    
    if (length(papers_data) == 0) {
      next
    }
    print("*********************************************")
    print(papers_data)
    print(papers_data$author)
    
    #convert all the lists columns in the dataframe to dataframes
    papers_data$author <- map(papers_data$author, toJSON)
    papers_data$reference <- map(papers_data$reference, toJSON)
    papers_data <- papers_data %>%
      mutate(across(where(is.list), ~map_chr(., toString)))
    
    
    #convert the papers_data to a dataframe to write it in a csv file
    papers_data <- as.data.frame(papers_data)
    
    #writing the data in the csv file
    if(file.exists(data_file)){
      existing_data <- read.csv(data_file)
      
      common_cols <- intersect(names(existing_data), names(papers_data))
      existing_data <- existing_data[, common_cols]
      papers_data <- papers_data[, common_cols]
      
      combined_data <- rbind(existing_data , papers_data)
      write.csv(combined_data, data_file , row.names = TRUE)
    }else{
      write.csv(papers_data, data_file , row.names = TRUE )
    }
    
    
    print ('CSV file written Successfully :)')
    print("total papers: ")
    print(total_papers)
    
  }, error = function(err) {
    next
  })
}