library(shiny)



shinyUI(pageWithSidebar(
    headerPanel("Probability of a dice roll"),    
    sidebarPanel(
        p("This application will compute the probabilities of the total value of a roll of a given number of arbitrary sided dices. Please adjust the inputs below to choose the number of dices and number of sides.The dices are fair (each side is equally likely). Both number of dices and sides are integers between 1 and 1000 although only some of those combinations are physically realizable."), 
        p("The plot on the right presents the probabilities for every possible outcome as well as the most likely value, standard deviation of outcomes an an example roll for given parameters."), 
        numericInput('dicesCount', 'Number of dices:', 2, min = 1, max = 1000, step = 1),
        numericInput('sidesOnDice', 'Number of sides on each dice:', 6, min = 1, max = 1000, step = 1)   
    ),
    mainPanel(        
        h3('Probability mass function of total:'),         
        plotOutput('resultDistribution'),
        h4('The most probable total value in this dice roll is:'),         
        verbatimTextOutput('max_value'),
        h4('With the standard deviation of:'),         
        verbatimTextOutput('sd_value'),
        h4('Its probability is:'),         
        verbatimTextOutput('max_prob'),
        h4('Example roll (total):'),         
        verbatimTextOutput('example_roll')
    )
))