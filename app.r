library(readr)
library(shiny)
library(tidyverse)
library(dplyr, warn.conflicts = FALSE)
library(plyr)
library(readxl)
library(ggplot2)
library(robust)
library(MASS)
library(rstanarm)
library(tidyr)
library(rvest)
library(rlist)
library(XML)
library(httr)
library(taRifx)
library(readr)
library(tidymodels)

#Data
NFL_2016_label <- read_excel("raw_data/NFL_2016_label.xlsx", 
                             skip = 3)
NFL_2016 <- NFL_2016_label%>%
  mutate(year = 2016)

NFL_2017_label <- read_excel("raw_data/NFL_2017_label.xlsx", 
                             skip = 3)
NFL_2017 <- NFL_2017_label%>%
  mutate(year = 2017)

NFL_2018_label <- read_excel("raw_data/NFL_2018_label.xlsx", 
                             skip = 3)
NFL_2018 <- NFL_2018_label%>%
  mutate(year = 2018)


NFL_Full_stat <- join(NFL_2016,NFL_2017,by = "year", type = "full")
NFL_Full_stat <- join(NFL_Full_stat,NFL_2018,by = "year", type = "full")

Combine_2016 <- read_excel("raw_data/Combine_2016.xlsx")
Combine_2016 <- Combine_2016%>%
  mutate(year = 2016)

Combine_2017 <- read_excel("raw_data/Combine_2017.xlsx")
Combine_2017 <- Combine_2017 %>%
  mutate(year = 2017)

Combine_2018 <- read_excel("raw_data/Combine_2018.xlsx")
Combine_2018 <- Combine_2018 %>%
  mutate(year = 2018)

Combine_Full_stat <- join(Combine_2016,Combine_2017,by = "year", type = "full")
Combine_Full_stat <- join(Combine_Full_stat,Combine_2018,by = "year", type = "full")

Combine_Full_stat <-  Combine_Full_stat %>%
  rename("Player" = "Name")

Combine_NFL_Full <- join(NFL_Full_stat, Combine_Full_stat, by = "Player", type = "full")

mm <- rlm(formula = `Approx Val CarAV` ~ Rnd+Pos+G,
          data = NFL_Full_stat
)

college_data <- read_excel("College_data.xlsx")



college_data1 <- college_data %>%
  select(Var.1:Var.6, player)

college_data2 <- college_data %>%
  select(Passing:Kick.Ret.3, -player)

college_data2[] <- lapply(college_data2, function(x) as.numeric(as.character(x)))

college_data <- cbind(college_data1,college_data2)

str(college_data3)

college_data <- college_data %>%
  rename("Year1" = "Var.1",
         "College" = "Var.2",
         "Conference" = "Var.3",
         "Class.Year" = "Var.4",
         "Position" = "Var.5",
         "College.Games" = "Var.6",
         "College.Completions" = "Passing",
         "College.Passing.Attempts" = "Passing.1",
         "College.Completion.Rate" = "Passing.2",
         "College.Passing.Yards" = "Passing.3",
         "College.Yards.Per.Attempt" = "Passing.4",
         "College.Adjusted.YPA" = "Passing.5",
         "College.Passing.Touchdowns" = "Passing.6",
         "College.Passing.Interceptions" = "Passing.7",
         "College.Passer.Rating" = "Passing.8",
         "College.Solo.tackle" = "Tackles",
         "College.Assist.Tackles" = "Tackles.1",
         "College.Total.Tackles" = "Tackles.2",
         "College.TFL" = "Tackles.3",
         "College.Sacks" = "Tackles.4",
         "College.Interceptions" = "Def.Int",
         "College.Int.Yards" = "Def.Int.1",
         "College.Int.Tds" = "Def.Int.3",
         "College.Pass.Defensed" = "Def.Int.4",
         "College.Fumble.Recoveries" = "Fumbles",
         "College.Forced.Fumbles" = "Fumbles.3",
         "College.Receptions" = "Receiving",
         "College.Receiving.Yards" = "Receiving.1",
         "College.YPR" = "Receiving.2",
         "College.Receiving.TDs" = "Receiving.3",
         "College.Rushing.Attempts" = "Rushing",
         "College.Rushing.Yards" = "Rushing.1",
         "College.YPC" = "Rushing.2",
         "College.Rushing.TDs" = "Rushing.3",
         "College.Total.Plays" = "Scrimmage",
         "College.Scrimmage.Yards" = "Scrimmage.1",
         "College.AVGYFS" = "Scrimmage.2",
         "College.Total.Touchdowns" = "Scrimmage.3",
         "Player" = "player"
         
  )



college_3 <- college_data %>%
  filter(Year1 == "Career") %>%
  mutate(college.passing.pg = College.Passing.Yards/College.Games,
         college.att.pg = College.Passing.Attempts/College.Games,
         college.comp.pg = College.Completions/College.Games,
         college.passtd.pg = College.Passing.Touchdowns/College.Games,
         college.passint.pg = College.Passing.Interceptions/College.Games,
         college.solotackles.pg = College.Solo.tackle/College.Games,
         college.asst.pg = College.Assist.Tackles/ College.Games,
         college.totaltck.pg = College.Total.Tackles/College.Games,
         college.TFL.pg = College.TFL/College.Games,
         college.sack.pg = College.Sacks/College.Games,
         college.int.pg = College.Interceptions/College.Games,
         college.passdefensed.pg = College.Pass.Defensed/College.Games,
         college.ff.pg = College.Forced.Fumbles/College.Games,
         college.receptions.pg = College.Receptions/College.Games,
         college.receivingyrds.pg = College.Receiving.Yards/College.Games,
         college.receivingtd.pg = College.Receiving.TDs/College.Games,
         college.rushattmpt.pg = College.Rushing.Attempts/College.Games,
         college.rushyrds.pg = College.Rushing.Yards/College.Games,
         college.rushtd.pg = College.Rushing.TDs/College.Games,
         College.scrimyards.pg = College.Scrimmage.Yards/College.Games,
         college.tottd.pg = College.Total.Touchdowns/College.Games)


full_data <- full_join(Combine_NFL_Full, college_3, by = "Player")

full_data1 <- full_data %>%
  select(`40 Yard Dash`, 
         `Bench Press`, 
         `Vertical Jump`, 
         `Broad Jump`,
         `Three Cone Drill`,
         `20 Yard Shuttle`,
         `60 Yard Shuttle`)

full_data2 <- full_data %>%
  select(-`40 Yard Dash`, 
         -`Bench Press`, 
         -`Vertical Jump`, 
         -`Broad Jump`,
         -`Three Cone Drill`,
         -`20 Yard Shuttle`,
         -`60 Yard Shuttle`)

full_data1[] <- lapply(full_data1, function(x) as.numeric(as.character(x)))

full_data <- cbind(full_data1,full_data2)

full_data <- full_data %>%
  mutate(NFLYPC =`Rushing Yds`/`Rushing Att`,
         NFLYPR = `Receiving Yds`/Receptions,
         NFLYPA = `Passing Yds`/`Passing Att`,
         NFLINTTD = `Passing TD`/`Passing Int`,
         ValuePerYear = `Approx Val CarAV`/(2020 - year),
         NFL.passing.pg = `Passing Yds`/G,
         NFL.att.pg = `Passing Att`/G,
         NFL.comp.pg = `Passing Cmp`/G,
         NFL.passtd.pg = `Passing TD`/G,
         NFL.passint.pg = `Passing Int`/G,
         NFL.solotackles.pg = `Solo Tackle`/G,
         NFL.sack.pg = Sk/G,
         NFL.int.pg = Int/G,
         NFL.receptions.pg = Receptions/G,
         NFL.receivingyrds.pg = `Receiving Yds`/G,
         NFL.receivingtd.pg = `Receiving TD`/G,
         NFL.rushattmpt.pg = `Rushing Att`/G,
         NFL.rushyrds.pg = `Rushing Yds`/G,
         NFL.rushtd.pg = `Rushing TD`/G
  )



QB <- full_data %>%
  filter(Pos == "QB") %>%
  select(Rnd,
         NFLINTTD,
         NFLYPA,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         NFL.att.pg,
         NFL.comp.pg,
         NFL.passint.pg,
         NFL.passtd.pg,
         NFL.passing.pg,
         `Passing Cmp`,
         `Passing Att`,
         `Passing Yds`,
         `Passing TD`,
         `Passing Int`,
         `Rushing Att`,
         `Rushing Yds`,
         `College/Univ`,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         College.Games,
         College.Completions,
         College.Passing.Attempts,
         College.Completion.Rate,
         College.Passing.Yards,
         College.Yards.Per.Attempt,
         College.Adjusted.YPA,
         College.Passing.Touchdowns,
         College.Passing.Interceptions,
         College.Passer.Rating,
         college.passing.pg,
         college.att.pg,
         college.comp.pg,
         college.passtd.pg,
         college.passint.pg,
         ValuePerYear
  )

RB <- full_data %>%
  filter(Pos == "RB") %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         NFL.receptions.pg,
         NFL.receivingyrds.pg,
         NFL.receivingtd.pg, 
         NFL.rushattmpt.pg,
         NFL.rushyrds.pg,
         NFL.rushtd.pg ,
         College.Games,
         `Rushing Att`,
         `Rushing Yds`,
         Receptions,
         `Receiving Yds`,
         `Receiving TD`,
         `College/Univ`,
         year,
         Grade,
         NFLYPC,
         College.Rushing.Attempts,
         College.Rushing.Yards,
         College.Rushing.TDs,
         College.Receptions,
         College.Receiving.Yards,
         College.Receiving.TDs,
         NFLYPR,
         College.YPR,
         College.YPC,
         College.Total.Plays,
         College.Total.Tackles,
         College.Total.Touchdowns,
         College.Scrimmage.Yards,
         College.AVGYFS,
         college.receptions.pg,
         college.receivingyrds.pg,
         college.receivingtd.pg,
         college.rushattmpt.pg,
         college.rushyrds.pg,
         college.rushtd.pg,
         College.scrimyards.pg,
         college.tottd.pg,
         ValuePerYear
  )

TE <- full_data %>%
  filter(Pos == "TE") %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         College.Games,
         `Rushing Att`,
         `Rushing Yds`,
         Receptions,
         `Receiving Yds`,
         `Receiving TD`,
         `College/Univ`,
         year,
         Grade,
         NFLYPC,
         College.Rushing.Attempts,
         College.Rushing.Yards,
         College.Rushing.TDs,
         College.Receptions,
         College.Receiving.Yards,
         College.Receiving.TDs,
         NFL.receptions.pg,
         NFL.receivingyrds.pg,
         NFL.receivingtd.pg, 
         NFL.rushattmpt.pg,
         NFL.rushyrds.pg,
         NFL.rushtd.pg ,
         NFLYPR,
         College.YPR,
         College.YPC,
         College.Total.Plays,
         College.Total.Tackles,
         College.Total.Touchdowns,
         College.Scrimmage.Yards,
         College.AVGYFS,
         college.receptions.pg,
         college.receivingyrds.pg,
         college.receivingtd.pg,
         college.rushattmpt.pg,
         college.rushyrds.pg,
         college.rushtd.pg,
         College.scrimyards.pg,
         college.tottd.pg,
         ValuePerYear
  )

WR <- full_data %>%
  filter(Pos == "WR") %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         College.Games,
         `Rushing Att`,
         `Rushing Yds`,
         Receptions,
         `Receiving Yds`,
         `Receiving TD`,
         `College/Univ`,
         year,
         Grade,
         NFLYPC,
         NFL.receptions.pg,
         NFL.receivingyrds.pg,
         NFL.receivingtd.pg, 
         NFL.rushattmpt.pg,
         NFL.rushyrds.pg,
         NFL.rushtd.pg ,
         College.Rushing.Attempts,
         College.Rushing.Yards,
         College.Rushing.TDs,
         College.Receptions,
         College.Receiving.Yards,
         College.Receiving.TDs,
         NFLYPR,
         College.YPR,
         College.YPC,
         College.Total.Plays,
         College.Total.Tackles,
         College.Total.Touchdowns,
         College.Scrimmage.Yards,
         College.AVGYFS,
         college.receptions.pg,
         college.receivingyrds.pg,
         college.receivingtd.pg,
         college.rushattmpt.pg,
         college.rushyrds.pg,
         college.rushtd.pg,
         College.scrimyards.pg,
         college.tottd.pg,
         ValuePerYear
  )

Tackle <- full_data %>%
  filter(Pos == "T") %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         `College/Univ`,
         year,
         Grade,
         ValuePerYear
  )

IOL <- full_data %>%
  filter(Pos == c("G","C")) %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         `College/Univ`,
         year,
         Grade,
         ValuePerYear
  )

DT <- full_data %>%
  filter(Pos == "DT") %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         College.Games,
         `College/Univ`,
         year,
         Grade,
         `Solo Tackle`,
         Int,
         Sk,
         NFL.solotackles.pg,
         NFL.sack.pg,
         NFL.int.pg,
         College.Solo.tackle,
         College.Assist.Tackles,
         College.TFL,
         College.Sacks,
         College.Interceptions,
         College.Int.Yards,
         College.Int.Tds,
         College.Pass.Defensed,
         College.Fumble.Recoveries,
         College.Forced.Fumbles,
         college.solotackles.pg,
         college.asst.pg,
         college.totaltck.pg,
         college.TFL.pg,
         college.sack.pg,
         college.passdefensed.pg,
         college.ff.pg,
         college.int.pg,
         ValuePerYear)

DE <- full_data %>%
  filter(Pos == "DE") %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         College.Games,
         `College/Univ`,
         year,
         Grade,
         `Solo Tackle`,
         Int,
         Sk,
         NFL.solotackles.pg,
         NFL.sack.pg,
         NFL.int.pg,
         College.Solo.tackle,
         College.Assist.Tackles,
         College.TFL,
         College.Sacks,
         College.Interceptions,
         College.Int.Yards,
         College.Int.Tds,
         College.Pass.Defensed,
         College.Fumble.Recoveries,
         College.Forced.Fumbles,
         college.solotackles.pg,
         college.asst.pg,
         college.totaltck.pg,
         college.TFL.pg,
         college.sack.pg,
         college.passdefensed.pg,
         college.ff.pg,
         college.int.pg,
         ValuePerYear)


LB <- full_data %>%
  filter(Pos == c("OLB","ILB")) %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         College.Games,
         `College/Univ`,
         year,
         Grade,
         `Solo Tackle`,
         Int,
         Sk,
         NFL.solotackles.pg,
         NFL.sack.pg,
         NFL.int.pg,
         College.Solo.tackle,
         College.Assist.Tackles,
         College.TFL,
         College.Sacks,
         College.Interceptions,
         College.Int.Yards,
         College.Int.Tds,
         College.Pass.Defensed,
         College.Fumble.Recoveries,
         College.Forced.Fumbles,
         college.solotackles.pg,
         college.asst.pg,
         college.totaltck.pg,
         college.TFL.pg,
         college.sack.pg,
         college.passdefensed.pg,
         college.ff.pg,
         college.int.pg,
         ValuePerYear)

CB <- full_data %>%
  filter(Pos == "CB") %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         College.Games,
         `College/Univ`,
         year,
         Grade,
         `Solo Tackle`,
         NFL.solotackles.pg,
         NFL.sack.pg,
         NFL.int.pg,
         Int,
         Sk,
         College.Solo.tackle,
         College.Assist.Tackles,
         College.TFL,
         College.Sacks,
         College.Interceptions,
         College.Int.Yards,
         College.Int.Tds,
         College.Pass.Defensed,
         College.Fumble.Recoveries,
         College.Forced.Fumbles,
         college.solotackles.pg,
         college.asst.pg,
         college.totaltck.pg,
         college.TFL.pg,
         college.sack.pg,
         college.passdefensed.pg,
         college.ff.pg,
         college.int.pg,
         ValuePerYear)

S <- full_data %>%
  filter(Pos == "S") %>%
  select(Rnd,
         Pick,
         Tm,
         Player,
         Pos,
         Age,
         To,
         `Approx Val CarAV`,
         G,
         year,
         Grade,
         Height,
         `Arm Length`,
         Weight,
         Hands,
         `40 Yard Dash`,
         `Bench Press`,
         `Vertical Jump`,
         `Broad Jump`,
         `Three Cone Drill`,
         `Hands Rank`,
         `40 Rank`,
         `Bench Rank`,
         `Vertical Rank`,
         `Broad Rank`,
         `3 Cone Rank`,
         `20 Shuttle Rank`,
         `60 Shuttle Rank`,
         College.Games,
         `College/Univ`,
         year,
         Grade,
         `Solo Tackle`,
         Int,
         Sk,
         NFL.solotackles.pg,
         NFL.sack.pg,
         NFL.int.pg,
         College.Solo.tackle,
         College.Assist.Tackles,
         College.TFL,
         College.Sacks,
         College.Interceptions,
         College.Int.Yards,
         College.Int.Tds,
         College.Pass.Defensed,
         College.Fumble.Recoveries,
         College.Forced.Fumbles,
         college.solotackles.pg,
         college.asst.pg,
         college.totaltck.pg,
         college.TFL.pg,
         college.sack.pg,
         college.passdefensed.pg,
         college.ff.pg,
         college.int.pg,
         ValuePerYear)


ui <- navbarPage(
  "Final Project Title",
  tabPanel("Summary Stats",
           fluidPage(
             titlePanel("Dataset Summaries"),
             sidebarLayout(
               sidebarPanel(
                 selectInput(inputId = "dataset",
                             label = "Choose a dataset:",
                             choices = c("NFL", "Combine"
                             ))),
               
               mainPanel(verbatimTextOutput("summary")))
           )),
  tabPanel("Plot of Round and Career Value",
           fluidPage(plotOutput("plot"))
  ),
  
  tabPanel("Regression Analysis",
           fluidPage(verbatimTextOutput("regress")),
           h3("Explanation of Regression"),
           p("This regression accounts for games played,position, and round drafted and the effect on Average Career Value, as we can see, as games played increases, career value does, and earlier rounds bring higher averages. Defensive ends, corners, fullbacks and many other positions are less likely to have higher average career values while quarterbacks and guards receive favorable coefficients.")
  ),
  tabPanel("About", 
           titlePanel("About"),
           h3("Project Background and Motivations"),
           p("My project is focused on utilizing data from the NCAA, NFL Combine, and NFL Statistics to find a link between college performance/athletic testing and NFL performance across different positions."),
           h3("Data Sourcing"),
           p("My data repository can be found here",a("data repo", href = "https://github.com/sethf26/shiny.git"), "and my sources currently include Profootball reference for NFL data, the NFL combine official repository for combine data, and the NCAA for college data, but I have yet to collect full college data due to inconsistencies in the year players enter the draft. I currently have 2 data sets including full NFL and combine stats for draft classes from 2016-2018, and am having trouble joining them by player name due to a pesky backslash present in my data")))


server <- function(input, output) {
  # Return the requested dataset ----
  datasetInput <- reactive({
    switch(input$dataset,
           "NFL" = NFL_Full_stat,
           "Combine" = Combine_Full_stat)
  })
  
  # Generate a summary of the dataset ----
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  
  output$regress <- renderPrint({
    summary(mm)
  })
  
  output$plot <- renderPlot({
    ggplot(NFL_Full_stat, mapping = aes(x = Rnd, y = `Approx Val CarAV`, color = Pos))+geom_point()+labs(title = "Average Career Value by Round", x = "Round Drafter", y = "Average Career Value")
  })
  
  # Show the first "n" observations ----
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
  
}
shinyApp(ui = ui, server = server)