
#' @title Print "hello world"
#' @description Print the hello world function to the console with
#' parameter say who to say hello to.
#' @param who Who to say hello to. (Default is "world")
#' @export
hello <- function(who = "world") {
  sprintf("Hello, %s!", who)
  # paste0("Hello, ", who, "!!")
}
