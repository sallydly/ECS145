#ProbA.r

#secretencoder: encodes message into picture

#secretdecoder: decodes secret message (user should know startpix, stride, consec, etc)
library(pixmap)

gcd <- function(num1, num2) {
  temp <- 1

  if (num1 > num2) {
    larger <- num1
    smaller <- num2
  }
  else {
    larger <- num2
    smaller <- num1
  }
  
  while(temp != 0) {
    temp <- larger %% smaller
    larger <- smaller
    smaller <- temp
  }
  return larger
} #determines GCD is 1 or not

secretencoder <- function(imgfilename, msg, startpix, stride, consec=NULL) {
	img <- try(read.pnm(imgfilename)) #try opening (if error, stop running)
	if (class(img) == "try-error") { 
		stop("Could not open file. Stopping script.", call. = FALSE) 
	}

  # extract pixel data 
  pixels <- img@grey

  if (consec != NULL){
    #check if consec is prime to img size
    if (gcd(length(img@grey), as.numeric(consec)) != 1) {
      warning("consec should be relatively prime to image size.")
    }
  }
  else{
    # user opts for quick and dirty encoding
    substr <- strsplit(msg,'')[[1]][1:nchar(msg)] # splits up the string into a vector of individual characters
    utf <- sapply(substr, utf8ToInt) # convert each char to Unicode code points
    utf <- utf / 128
    lastpix <- (nchar(msg) + ((startpix-1)%/%stride)) * stride # last pixel for the last char in msg to embed in without wrapping
    indices <- c(seq(startpix, lastpix, stride) %% length(pixels)) # a vector of indices in pixel to encode the msg in, wraps around to the beginning if reached the end
    pixels[indices]  <- utf
  }    
}