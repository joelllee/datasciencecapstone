library(shiny)

predict <- function(splitbigrammatrix, splittrigrammatrix, split4grammatrix, firstthreecol, firsttwocol, input_String){
  phrase_len<-length(unlist(strsplit(input_String, " ")))
  last_word <- ""
  predicted_word <- ""
  word <- vector('character')
  flag <- FALSE
  if (phrase_len > 0){ # does the necessary data processing
    for (i in 1:phrase_len){
      last_word <-tail(strsplit(input_String, split = " ")[[1]],phrase_len)[i]
      last_word <- tolower(last_word) # make it all lower case
      last_word <- str_replace_all(last_word, "[[:punct:]]", "")  # remove all punctuation
      last_word <- str_replace_all(last_word, "[0-9]", "") # remove all numbers
      last_word <- unlist(last_word)[!(unlist(last_word) %in% stopwords("english"))] # remove stop words
      last_word <- stemDocument(last_word)
      word <- c(word, last_word)
    }
  }
  word <- str_trim(word) # removes the empty space in the word
  len_word <- length(unlist(strsplit(word, " ")))
  if(len_word>=3)
  {
    #outputword4gram <- split4grammatrix[grep(paste0("\\b",word[(len_word-2):len_word],"\\b"), paste(split4grammatrix[,1],split4grammatrix[,2],split4grammatrix[,3])),]
    outputword4gram <- split4grammatrix[grep(paste(word[(len_word-2)],word[len_word-1],word[len_word]), firstthreecol),]
    outputword4gram <- matrix(outputword4gram, ncol=4)
    if (nrow(outputword4gram)!=0)
    {
      predicted_word <- outputword4gram[1,4]
      flag=TRUE
    }
  }
  if(len_word>=2 && flag==FALSE)
  {
    #outputwordtrigram <- splittrigrammatrix[grep(paste0("\\b",word[(len_word-1):len_word],"\\b"), paste(splittrigrammatrix[,1],splittrigrammatrix[,2])),]
    outputwordtrigram <- splittrigrammatrix[grep(paste(word[(len_word-1)],word[len_word]), firsttwocol),]
    outputwordtrigram <- matrix(outputwordtrigram, ncol=3)
    if (nrow(outputwordtrigram)!=0)
    {  
      predicted_word <- outputwordtrigram[1,3]
      flag=TRUE
    }
  }  
  if(len_word>=1 && flag==FALSE)
  {
   # outputwordbigram <- splitbigrammatrix[grep(paste0("\\b",word[len_word],"\\b"), splitbigrammatrix[,1]),]
    outputwordbigram <- splitbigrammatrix[grep(paste(word[len_word]), splitbigrammatrix[,1]),]
    outputwordbigram <- matrix(outputwordbigram, ncol=2)
    if (nrow(outputwordbigram)!=0)
    {  
      predicted_word <- outputwordbigram[1,2]
      flag=TRUE
    }  
  }
  return(predicted_word)
}    

shinyServer(
  function(input, output) {
    setwd("/srv/connect/apps/capstoneproject/")

    ## Bigram
    output$status <- renderPrint({"0%"})
    splitbigrammatrix <- readRDS("bigram.rds")
    output$status <- renderPrint({"10%"})
    ## Trigram

    splittrigrammatrix <- readRDS("trigram.rds")
    firsttwocol <- readRDS("firsttwocol.rds")
    #firsttwocol <- paste(splittrigrammatrix[,1],splittrigrammatrix[,2])
    output$status <- renderPrint({"40%"})
    ## 4gram

    split4grammatrix <- readRDS("4gram.rds")
    firstthreecol <- readRDS("firstthreecol.rds")
    #firstthreecol <- paste(split4grammatrix[,1],split4grammatrix[,2],split4grammatrix[,3])
    
    output$status <- renderPrint({"Data Loaded"})
    
    output$prediction <- reactive({
      output$text <- renderPrint(input$text)
      output$prediction <- renderPrint({predict(splitbigrammatrix, splittrigrammatrix, split4grammatrix, firstthreecol, firsttwocol, input$text)})   
    })
  }
)