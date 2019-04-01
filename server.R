# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)
library(here)
library(rlang)

# Define a server for the Shiny app
function(input, output, session) {
  
  results <<- list()

  # Fill in the spot we created for a plot
  output$phonePlot <- renderPlot({

    # save the expression to create the plot. This will be accessed in the .rmd file
    results <<- expr(barplot(WorldPhones[,!!input$region]*1000,
                 main=!!input$region,
                 ylab="Number of Telephones",
                 xlab="Year"))
    # Render a barplot
    barplot(WorldPhones[,input$region]*1000,
            main=input$region,
            ylab="Number of Telephones",
            xlab="Year")
  })
  
  output$report <- downloadHandler(
    filename = "report.html",
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- here::here("www/report.Rmd")
      file.copy(here::here("report.Rmd"), tempReport, overwrite = TRUE)
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )

  # Close the app when the session completes. Necessary for deployed apps
  if(!interactive()) {
    session$onSessionEnded(function() {
      stopApp()
      q("no")
    })
  }
}
