install.packages("tm")
install.packages("RWeka")
install.packages("SnowballC")
install.packages("slam")
library(tm)
library(RWeka)
library(stringr)
library(stringi)
library(SnowballC)
library(slam)

setwd("D:\\coursera")
con <- file("en_US.twitter.txt", "r") 
twitter <- readLines(con, -1) 
close(con)
con <- file("en_US.blogs.txt", "r") 
blogs <- readLines(con, -1) 
close(con)

con <- file("en_US.news.txt", "r") 
news <- readLines(con, -1) 
close(con)

set.seed(100)
sample_twitter <- sample (twitter, size=100000) # sampling of 100000 rows of twitter data
sample_blogs <- sample (blogs, size=100000) # sampling of 100000 rows of blogs data
sample_news <- sample (news, size=100000) # sampling of 100000 rows of news data

combined = c(sample_blogs, sample_twitter, sample_news)
df = as.data.frame(combined)
corpus <- Corpus(VectorSource(df$combined))

## Create Corpus

corpus <- tm_map(corpus, content_transformer(stringi::stri_trans_tolower))
corpus <- tm_map(corpus, removeNumbers) # remove numbers as it's not important for text analysis
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace) # call strip white space later rather than earlier as there would be blank spaces after you remove the numbers and punctuation
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stemDocument) # There are differentations of the word so stemming reduces them by grouping them back to the root word; the stemming document is not perfect

#Generate bigram and create termdocument matrix
bigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
tdm <- TermDocumentMatrix(corpus, control = list(tokenize = bigramTokenizer))
#tdm.matrix <- as.matrix(tdm)

wordcount <- row_sums(tdm, na.rm = FALSE)

sorted_topwords <- (sort(wordcount, decreasing = TRUE))

DF <- as.data.frame(sorted_topwords, stringsAsFactors = FALSE)
write.table(DF, "bigram.csv")

#Generate trigram and create termdocument matrix
trigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
tdm <- TermDocumentMatrix(corpus, control = list(tokenize = trigramTokenizer))

wordcount <- row_sums(tdm, na.rm = FALSE)

sorted_topwords <- (sort(wordcount, decreasing = TRUE))

DF <- as.data.frame(sorted_topwords, stringsAsFactors = FALSE)
write.table(DF, "trigram.csv")

#Generate 4-gram and create termdocument matrix
fourgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
tdm <- TermDocumentMatrix(corpus, control = list(tokenize = fourgramTokenizer))

wordcount <- row_sums(tdm, na.rm = FALSE)

sorted_topwords <- (sort(wordcount, decreasing = TRUE))

DF <- as.data.frame(sorted_topwords, stringsAsFactors = FALSE)
write.table(DF, "4gram.csv")