# load dependencies
library(testthat)
library(qqid)

# check if the ANU Quantum Random Number Generator API is available 
check_qrng <- function(){
  tryCatch(
    expr = {
      req <- curl::curl_fetch_memory('https://qrng.anu.edu.au/index.php')
      req$status_code
    },
    error = function(e){
      -1
    }
  )
}

## run tests only if internet access and the QRNG API is both available
if(curl::has_internet() & check_qrng() == 200){
  test_check("qqid")
}

# [END]
