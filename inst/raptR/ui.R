shinyUI(pageWithSidebar(
  
  headerPanel("raptR"),
  sidebarPanel(
    
    ## use shinyjs to disable/enable buttons w/ JS
    shinyjs::useShinyjs(),
    
    ## reactive vs. upon-manual-submit calculations
    uiOutput('submitCtrl'),
    
    ## enable reactive option
    uiOutput('reactiveCtrl'),
    
    hr(),
    
    ## dataset selection
    uiOutput('datasetCtrl'),
    ## "view plot" button if import tab
    conditionalPanel(
      condition = 'input.conditionedPanels=="importTab"',
      ## view plot button
      actionButton("viewPlot", label = "View Plot")
    ),
    
    hr(),
    
    ## file input/upload panel
    conditionalPanel(
      condition = 'input.conditionedPanels=="importTab"',
      source('./views/import/dataImportCtrlsUI.R', local=TRUE)$value
    ),  # end of file input/upload panel
    
    ## aggregation options
    conditionalPanel(
      condition = 'input.conditionedPanels=="tableTab"',
      source('./views/table/manAggCtrlsUI.R', local=TRUE)$value
    ),  # end of conditionalPanel for aggregation options
    
    ## plot options
    conditionalPanel(
      condition = 'input.conditionedPanels=="plotTab"',
      source('./views/plot/plotCtrlsUI.R', local=TRUE)$value
    )  # end of conditionalPanel for plot options

  ),  # end of sidebarPanel
  
  mainPanel(
    #import modal panels
    source('./views/modals/modalPanels.R',local=TRUE)$value,
    
    tabsetPanel(type = "tabs",
                tabPanel("Plot", 
                         br(),
                         uiOutput('exportPlotCtl'),
                         br(),
                         plotOutput("plot", brush=brushOpts(id="zoom_brush", resetOnNew=TRUE)),
                         value='plotTab'
                ),
                tabPanel("Table", 
                         br(),
                         uiOutput('dlBtnCSV'),
                         br(),
                         DT::dataTableOutput("displayTable"),
                         value='tableTab'
                ),
                tabPanel('Import',
                         tags$head(tags$script('
                                     Shiny.addCustomMessageHandler("myCallbackHandler",
                                       function(typeMessage) {
                                          if(typeMessage == 1){
                                          $("a:contains(Plot)").click();
                                          }
                                          });
                                          ')),
                         value='importTab'
                ),
                id = "conditionedPanels"
    )
  )  
  
))