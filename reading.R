library(devtools)
install.packages("digest")
library(digest)
devtools::install_github('rstudio/rsconnect')
library(rsconnect)

#install.packages("shiny")
library(shiny)


library(tm)
library(RWeka)
library(stringr)
library(stringi)
library(SnowballC)
library(abind)

#install.packages("abind")


## Pre-processing
## Bigram
tdm <-read.table("bigram.csv")
tdm.matrix <- as.matrix(tdm)
topwords <- rowSums(tdm.matrix)

sorted_topwords <- (sort(topwords, decreasing=TRUE))
names_sorted_bigram <- names(sorted_topwords)

splitbigram <- strsplit(names_sorted_bigram, split= " ")
splitbigrammatrix <- matrix(unlist(splitbigram), ncol=2, byrow=TRUE)
saveRDS(splitbigrammatrix, file="bigram.rds")


#outputwordbigram <- splitbigrammatrix[grep(paste0("\\b","love","\\b"), splitbigrammatrix[,1]),]
#if (nrow(outputwordbigram)!=0)
 # outputwordbigram[1,2]

## Trigram
tgm <-read.table("trigram.csv")
tgm.matrix <- as.matrix(tgm)
topwords <- rowSums(tgm.matrix)

sorted_topwords <- (sort(topwords, decreasing=TRUE))
names_sorted_trigram <- names(sorted_topwords)

splittrigram <- strsplit(names_sorted_trigram, split= " ")
splittrigrammatrix <- matrix(unlist(splittrigram), ncol=3, byrow=TRUE)
saveRDS(splittrigrammatrix, file="trigram.rds")


firsttwocol <- paste(splittrigrammatrix[,1],splittrigrammatrix[,2])
saveRDS(firsttwocol, file="firsttwocol.rds")
#outputwordtrigram <- splittrigrammatrix[grep(paste0("\\b","version tree","\\b"), firsttwocol),]
#if (nrow(outputwordtrigram)!=0)
#  outputwordtrigram[1,3]

## 4gram
fourgm <-read.table("4gram.csv")
fourgm.matrix <- as.matrix(fourgm)
topwords <- rowSums(fourgm.matrix)

sorted_topwords <- (sort(topwords, decreasing=TRUE))
names_sorted_4gram <- names(sorted_topwords)

split4gram <- strsplit(names_sorted_4gram, split=" ")
split4grammatrix <- matrix(unlist(split4gram), ncol=4, byrow=TRUE)
saveRDS(split4grammatrix, file="4gram.rds")

firstthreecol <- paste(split4grammatrix[,1],split4grammatrix[,2],split4grammatrix[,3])
saveRDS(firstthreecol, file="firstthreecol.rds")
#outputword4gram <- split4grammatrix[grep(paste("brother","andrew","enter"), firstthreecol),]
outputword4gram <- split4grammatrix[grep(paste("brother","andrew","enter"), paste(split4grammatrix[,1],split4grammatrix[,2],split4grammatrix[,3])),]


outputword4gram
#outputword4gram <- split4grammatrix[grep(paste0("\\b","just dont want","\\b"), firstthreecol),]
#if (nrow(outputword4gram)!=0)
 # outputword4gram[1,4]

#creating the app to get the words

stopwords("english")

unlist(word)[!(unlist(word) %in% stopwords("english"))]
word[!(word %in% stopwords("english"))]


?stopwords
#word <- tm_map(word, removeWords, stopwords("english"))
word <- str_replace_all(word, stopwords("english"), "")


predict <- function(input_String){
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

  word <- str_trim(word) # removes the empty space in the word
  len_word <- length(unlist(strsplit(word, " ")))
  if(len_word>=3)
  {
    outputword4gram <- split4grammatrix[grep(paste(word[(len_word-2)],word[len_word-1],word[len_word]), firstthreecol),]
    outputword4gram <- matrix(outputword4gram, ncol=4)
    
#    outputword4gram <- split4grammatrix[grep(paste("bright","earli","asd"), firstthreecol),]

   #word
   print(paste(word[(len_word-2)],word[len_word-1],word[len_word]))
    print(word[3:5])
  #  print(word[(len_word-2):len_word])
   # split4grammatrix[grep(paste0("\\b","damag buy thing","\\b"), firstthreecol),]
    
    if (nrow(outputword4gram)!=0)
    {
      predicted_word <- outputword4gram[1,4]
      flag=TRUE
    }
  }
  if(len_word>=2 && flag==FALSE)
  {
    outputwordtrigram <- splittrigrammatrix[grep(paste0("\\b",paste(word[(len_word-1)],word[len_word]),"\\b"), firsttwocol),]
    outputwordtrigram <- matrix(outputwordtrigram, ncol=3)
    if (nrow(outputwordtrigram)!=0)
    {  
      predicted_word <- outputwordtrigram[1,3]
      flag=TRUE
    }
  }  
  if(len_word>=1 && flag==FALSE)
  {
    outputwordbigram <- splitbigrammatrix[grep(paste0("\\b",word[len_word],"\\b"), splitbigrammatrix[,1]),]
    outputwordbigram <- matrix(outputwordbigram, ncol=2)
    if (nrow(outputwordbigram)!=0)
    {  
      predicted_word <- outputwordbigram[1,2]
      flag=TRUE
    }  
  }
}
  return(predicted_word)
    
}
  
predict("the sun is shining brightly on this beautiful day")


word <- ("very good food")
word <- c("very","good")
word <- c(word, "food")
word[1:2]
phrase_len<-length(unlist(strsplit(word, " ")))
word
phrase_len
phrase_len <- 0
tail(strsplit(word, split = " ")[[1]],3)[1]

for (i in 1:phrase_len)
{
  last_word <-tail(strsplit(word, split = " ")[[1]],phrase_len)[i]
  print(last_word)
}

?factor
test_factor <- factor(unlist(names_sorted_bigram))
head(test_factor)


test_string <- "accused of"
test_split <- strsplit(test_string, split = " " )
test_factor <- factor(unlist(test_split))
test_df <- data.frame(X1 = test_factor[1], X2 = test_factor[2])
predict(get(names_sorted_bigram), test_df)
