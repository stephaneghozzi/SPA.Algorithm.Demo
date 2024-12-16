spa_algorithm_demo_app <- function() {

  options(htmlwidgets.TOJSON_ARGS = list(na = 'string'))

  shiny::shinyApp(
    ui = spa_algorithm_demo_ui,
    server = spa_algorithm_demo_server
  )

}
