allcars <- mutate(mtcars, car = row.names(mtcars))
allcars$am <- as.logical(allcars$am)
mycars <<- allcars

shinyServer(function(input, output) {
        output$cyl <- renderText({paste("Cylinders: ", input$cyls)})
        output$mpg <- renderText({paste("Miles Per Gallon: ", ifelse(input$economy, "Doesn't Matter", input$mpg))})
        output$tran <- renderText({paste("Transmission: ", input$tran)})
        output$qsec <- renderText({paste("1/4 Mile Time: ", ifelse(input$speed, "Doesn't Matter", input$qsec))})
        output$mycars <- renderText({
                # Take a dependency on input$goButton
                if (input$goButton == 0)
                        return()
                
                # Use isolate() to avoid dependency on input$obs
                isolate({
                        if (input$cyls == "Any")
                                mycars <<- allcars
                        else
                                mycars <<- allcars[allcars$cyl == input$cyls,]
                        if (input$tran != "Either") {
                                if (input$tran == "Manual")
                                        mycars <<- mycars[mycars$am,]
                                else
                                        mycars <<- mycars[!mycars$am,]
                        }
                        if (!input$economy) 
                                mycars <<- mycars[mycars$mpg >= input$mpg,]
                        else 
                                mycars <<- mycars[mycars$mpg >= 0,]
                        if (!input$speed) 
                                mycars <<- mycars[mycars$qsec <= input$qsec,]
                        else
                                mycars <<- mycars[mycars$qsec >= 0,]
                        carCount <<- nrow(mycars)
                        if (carCount > 0 ) {
                                out <- paste("<table><th>Car</th><th>MPG</th>",
                                             "<th>Displ</th><th>HP</th>",
                                             "<th>Weight</th><th>1/4M Time</th>",
                                             "<th>Carb</th><th>Cyl</ht>", sep="")                              
                                for (i in 1:carCount) {
                                        out <- paste(out, "<tr><td width=130px>",mycars$car[i], "</td>",
                                                     "<td width=50px>", mycars$mpg[i],"</td>",
                                                     "<td width=50px>", mycars$disp[i], "</td>",
                                                     "<td width=50px>", mycars$hp[i], "</td>",
                                                     "<td width=80px>", mycars$wt[i]*1000, "</td>",
                                                     "<td width=50px>", mycars$qsec[i], "</td>",
                                                     "<td width=50px>", mycars$carb[i], "</td>",
                                                     "<td width=50px>", mycars$cyl[i], "</td>",
                                                     "</tr>", sep = "")
                                }
                        } else {
                                out <- "<br>No cars meet your excellent standards<br>Please try again!"
                        }                        
                        out
                })
        })
        output$plotcars <- renderPlot({
                # Take a dependency on input$goButton
                if (input$goButton == 0)
                        return() 
                isolate({                                             
                        plotcars <- mutate(allcars, mine = factor("All Cars", levels = c("All Cars", "My Cars")), weight = wt*1000)
                        for (i in 1:nrow(plotcars)) if (plotcars$car[i] %in% mycars$car) {plotcars$mine[i] <- as.factor("My Cars")}
                        plot1 <- ggplot(plotcars, aes(weight, mpg, color=factor(mine))) + 
                                geom_point(size = 4) +
                                scale_color_manual(values=c("darkgray","red")) +
                                labs(x = "Weight", y="Miles Per Gallon")
                        plot2 <- ggplot(plotcars, aes(hp, qsec, color=factor(mine))) + 
                                geom_point(size = 4) +
                                scale_color_manual(values=c("darkgray","red")) +
                                labs(x = "Horsepower", y="1/4 Mile Time (secs)")
                        grid.arrange(plot1, plot2)
                })
        })
        output$carcount <- renderText({
                if (input$goButton == 0)
                        return()
                isolate({paste("My Dream Car Count: ", as.character(carCount))})              
        })
}) 
