library(shiny)
library(tm)
library(RWeka)
library(stringr)
library(stringi)
library(SnowballC)
library(abind)

shinyUI(bootstrapPage(   
  mainPanel(
    # Application title
    headerPanel("Coursera Data Science Capstone"),
    h4('This application is able to predict the next word by entering in text into the text input and clicking on Submit'),
  
      textInput("text", label = h3("Text input"), value = ""), 
      submitButton('Submit'),
 
    br(''),
    

    h4('Please wait until the message "data loaded" appears below'),
    verbatimTextOutput("status"),
    br(''),
    
    h4('What you have entered is:'),
    verbatimTextOutput("text"),
    br(''),
    h4('The predicted next word is:'),
    tags$style(type='text/css', '#prediction {background-color: rgba(255,255,0,0.40); color: black;}'),
    verbatimTextOutput("prediction")


  
    )
  )
)
