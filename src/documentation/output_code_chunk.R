# function that takes the code from a stan model as input and
# returns a list of the code chunks in the stan model
# where the list names are the chunk names and the list values
# are the code chunks

# if chunk.name is not NULL, then only return the code chunk
# with that name

get_stancode_chunks <- function(stancode, chunk.name=NULL){
  # get the chunk names
  chunk.names <- grep("^#'", stancode, value=TRUE) %>%
    gsub("^#'", "", .) %>%
    gsub("'$", "", .)
  
  # get the chunk code
  chunk.code <- grep("^#'", stancode, value=TRUE, invert=TRUE)
  
  # create a list of the chunk names and code
  chunk.list <- setNames(chunk.code, chunk.names)

  # if chunk.name is not NULL, then only return the code chunk
  # with that name
  if(!is.null(chunk.name)){
    # return the code chunk
    return(chunk.list[[chunk.name]])
  }

  # otherwise return the whole list
  return(chunk.list)
}