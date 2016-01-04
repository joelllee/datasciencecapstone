## Install RWeka for tokenisation
install.packages("RWeka")
install.packages("tm")
library(RWeka)
library(tm)
sample = c('There is "something" going on right now, like right. now. He's there.', 
           'There is "something" going on right now, like right... now. He\'s there.')
corpus = VCorpus(VectorSource(sample), readerControl = list(reader = readPlain))

# RWeka's Tokenizer

WekaBigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))

dtm_weka = DocumentTermMatrix(corpus, control = list(tokenize = WekaBigramTokenizer))
inspect(dtm_weka)
dtm_weka_mat = as.data.frame(colSums(as.matrix(dtm_weka)))
dtm_weka_mat