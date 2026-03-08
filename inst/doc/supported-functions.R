## ----echo = FALSE, results = "asis"-------------------------------------------
functions <- jsonlite::read_json("supported-functions.json")

for (x in functions) {
  cat(paste("###", x$package))
  cat("\n")

  for (y in x$functions) {
    cat(paste("-", y, "\n"))
  }

  cat("\n")
}

