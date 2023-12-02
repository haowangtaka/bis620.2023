
#' @title Print "hello world"
#' @description Print the hello world function to the console with
#' parameter say who to say hello to.
#' @param who Who to say hello to. (Default is "world")
#' @examples
#' hello("people in group 5 of BIS620 class")
#' @export
hello <- function(who = "world") {
  sprintf("Hello, %s!", who)
  # paste0("Hello, ", who, "!!")
}
