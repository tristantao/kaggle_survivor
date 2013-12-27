#Given a dataset, creates a boolean variable of "is_" for each list_to_replace
add_title_vars = function (targetData, list_to_replace) {
  for (title in list_to_replace) {
    new_col = 0
    for (i in 1:nrow(trainData)) { 
      if (targetData$Name[i] == title) {
        new_col[i] = 1
      } else {
        new_col[i] = 0
      }
    }
    targetData[paste("Is", title, sep="_")] <- new_col
  }
  return (targetData)
}
