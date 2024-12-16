spa_algorithm_demo_app <- function() {

  shiny::shinyApp(
    ui = spa_algorithm_demo_ui,
    server = spa_algorithm_demo_server
  )

}
