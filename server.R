library(shiny) 

pdice <- function(p, n, s) {
    # Returns the probability that a throw n s-sided dices will result in a sum of p.
    # Derivation based on mathworld.wolfram.com/Dice.html
  
    kmax <- floor((p - n) / s)
    cval <- .0 
    for(k in 0:kmax) {
        cval <- cval + (-1)^k * choose(n, k) * choose(p - s*k - 1, n - 1)
    }    
    #cval is the number of different combinations that lead to the result with sum=p
    cval * 1/s^n    
}

diceProbabilities <- function(n, s) {
    # Computes the probability mass function of the result of throwing n identical dices.

    # the range of the result (sum of dices' values) is known
    min_result <- 1*n
    max_result <- s*n
    result_range <- min_result:max_result
    
    # use sapply to produce result probabilities over the whole possible result range
    pdice_p <- function(p) {pdice(p, n, s)}
    sapply(result_range, pdice_p)    
}

getExampleRoll <- function(n, s) {
	# produces an example outcome of n s-sided dices roll
	sample(1:n, s, replace=T)
}

renderNumber <- function(t) {
	cat(format(t, digits=2, nsmall=2))
}

shinyServer(
    function(input, output) {
    	
    	# get the number of dices and number of sides in a dice
    	n <- reactive({as.numeric(input$dicesCount)})
    	s <- reactive({as.numeric(input$sidesOnDice)})
    	
    	# get the range of possible sum and compute probabilities
    	range <- reactive({n():(s()*n())})
        probs <- reactive({diceProbabilities(n(), s())})
        max_prob <- reactive({max(probs())})
        sd_value <- reactive({sd(probs())})
        # [1] is to take the first value if there are multiple max (in case of one dice)
        max_value <- reactive({range()[probs() == max_prob()][1]})
        example_roll <- reactive({getExampleRoll(s(), n())})

        # compute the distribution and its statistics
        output$resultDistribution <- renderPlot({barplot(probs(), names.arg = range(), xlab="Total value of a roll", ylab="Probability", col="salmon")})                
        output$max_value <- renderPrint({renderNumber(max_value())})
        output$max_prob <- renderPrint({renderNumber(max_prob())})        
        output$sd_value <- renderPrint({renderNumber(sd_value())})        
        output$example_roll <- renderPrint({cat(renderNumber(example_roll()), ' (', sum(example_roll()), ')', sep='')})        
    }
)