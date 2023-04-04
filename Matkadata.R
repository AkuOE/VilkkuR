library(tidyverse)
library(shiny)
library(shinyjs)

#Alustetaan mahdolliset vuoden valinnat
vuosilista <- seq.int(2018, 2090)
vuosi <- 2018

shinyApp(
  
  #Käyttöliittymä tiedon välittämistä Datajalostamoon
  ui=shinyUI(navbarPage(
    useShinyjs(),
    
    tabPanel("Uuden datan lisäys",
             
             tabPanel("Uuden datan lisäys",
                      
                      selectInput(
                        "vuoden_valinta",
                        "Valitse vuosi:",
                        vuosilista,
                      ),
                      fileInput("upload", "Valitse tiedosto:", multiple = FALSE, accept = '.csv', buttonLabel = "Etsi tiedosto", placeholder = "Ei valittua tiedostoa"),
                      actionButton("do", "Aloita"),
                      h2("Käsiteltävä tiedosto:"),
                      dataTableOutput("Haluttu_tiedosto"),
             ),
             
    ))),
  server=shinyServer(function(input, output, session){
    
    options(shiny.maxRequestSize = 100*1024^2)
    
    output$result <- renderText({
      paste("Vuosi:", input$vuoden_valinta)
    })
    
    #Upload
    observe({
      
      vuosi <<- strtoi(input$vuoden_valinta)
      
      if (is.null(input$upload)) return()
      
      File_Path <- paste0("./Input/Vilkku-fillari_matkat_fin_",vuosi,".csv")
      file.copy(input$upload$datapath,
                File_Path, overwrite = TRUE)
      
      #Näytetään valittu csv-pöytänäkymässä tarkastusta varten.
      
      kasiteltava_tiedosto <- input$upload$datapath
      
      tiedosto <- paste0(kasiteltava_tiedosto)
      
      matkadf <- read.csv2(tiedosto)
      
      output$Haluttu_tiedosto <- renderDataTable({ matkadf })
      
    })
    
    observeEvent(input$do, {
      
      #Estetään nappien painaminen tiedon käsittelyn ajaksi
      disable("do")
      disable("upload")
      disable("vuoden_valinta")
      
      
      kasiteltava_tiedosto <- input$upload$datapath
      
      tiedosto <- paste0(kasiteltava_tiedosto)
      
      matkadf <- read.csv2(tiedosto)
      
      print(moro)
      
    })#ObserveEvent close
  })#ShinyServer close
)#ShinyApp Close