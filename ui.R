library(shiny)
library(dplyr)
library(stringr)
library(ggplot2)
library(gridExtra)

mycars <- mutate(mtcars, car = row.names(mtcars))

shinyUI(fluidPage(
                fluidRow(
                        column(1),
                        column(10,
                                h2("Find My 1974 Dream Car", align = "center"),
                                p("You're reminiscing about those fine 1974 Motor Trend showcase cars and have a few thoughts about factors such as 1/4 Mile Speed, Automatic vs Manual transmission, 4, 6 or 8 cylinders and, of course, Fuel Economy."),
                                p("Find your car by working the selection controls below and then press Find Cars to view those cars that fit your criteria.")
                        ),
                        column(1)
                ),
                fluidRow(
                        sidebarPanel( 
                                radioButtons("cyls",
                                        label = "Cylinders",
                                        c("4 Cyl" = "4",
                                          "6 Cyl" = "6",
                                          "8 Cyl" = "8",
                                          "Any" = "Any"),
                                        "Any"),
                                radioButtons("tran",
                                        label = "Transmission",
                                        c(Auto = "Automatic",
                                          Manual = "Manual",
                                          Either = "Either"),
                                        "Either"),
                                actionButton("goButton", "Find Cars")
                        ),
                        sidebarPanel(
                                sliderInput("mpg",
                                        label = "Miles Per Gallon",
                                        min = range(mycars$mpg)[1],
                                        max = range(mycars$mpg)[2],
                                        value = median(mycars$mpg),
                                        step = 0.2),
                                checkboxInput("economy", "MPG Doesn't Matter", FALSE),
                                sliderInput("qsec",
                                        label = "1/4 Mile Time",
                                        min = range(mycars$qsec)[1],
                                        max = range(mycars$qsec)[2],
                                        value = median(mycars$qsec),
                                        step = 0.2),
                                checkboxInput("speed", "1/4 Mile Time Doesn't Matter", FALSE)
                        ),
                        sidebarPanel(
                                h4("My Search Critera", align = "center"),
                                textOutput("cyl"),
                                textOutput("mpg"),
                                textOutput("tran"),
                                textOutput("qsec"),
                                p(),
                                textOutput("carcount")                               
                        )
                ),
                fluidRow(
                        column(1),
                        column(10,
                                h4("My Cars", align = "center"),
                                plotOutput("plotcars"),
                                tableOutput("mycars")
                        ),
                        column(1)
                )
        )
)
