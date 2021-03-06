#problemB.r
#implemtenting Python's os.path.walk() in R
#walk(currdir, f, arg, firstcall=TRUE)
#  f will have arguments (drname, filelist, arg)
#    f's arg <- walk's arg after recursion?
#  dname <- currdir
walk <- function(currdir, f, arg, firstcall=TRUE) {
  #arguments for f(drname, flist, arg)
	if (firstcall == TRUE) { #first call of recursion...set up
		originaldir <- getwd() #when we finish walking, go back to directory where walk was originally called
		flist <<- vector(length=0)  #global; flist will contain all the ABSOLUTE PATHS of files and directories contained in 'currdir'
	}
	
	setwd(currdir) #move to that directory
	diritems <- dir()
	
	if (length(diritems) != 0) {
		fullpath <- function(x) file.path(getwd(), x) #absolute paths in filelist
		diritems <- fullpath(diritems)
		flist <<- c(flist, diritems) #all files/dir in that directory -> append to flist
		#get all directories
		finf <- file.info(diritems) #info for items. we're using the isdir property
		dirlist <- diritems[finf["isdir"] == TRUE] #filter
		
		#recursion
		
		for (d in dirlist) {
			walk(d, f, arg, firstcall=FALSE)
			setwd('..') #manually set back to previous dir (ie. walk recursion brings us to "a/b", when we come out we want to be in "a")
		}
	} #if directory is not empty
	
	if (firstcall == TRUE) { #we finish recursion and are back in the first call
		setwd(originaldir)
		return(f(currdir, flist, arg))
	}
}

nbytes <- function(drname, filelist, arg) {
	finf <- file.info(filelist) #gets file info
	flist <- filelist[finf["isdir"] == FALSE] #filter only files
	
	getsize <- function(x) file.size(x)
	sizelist <- getsize(flist)
	
	numbytes <- sum(sizelist)
	
	return(numbytes)
}

rmemptydirs <- function(drname, filelist, arg) {
	finf <- file.info(filelist) #gets file info
	dlist <- filelist[finf["isdir"] == TRUE] #filter only dir
	
	for (d in dlist) {
		if (length(dir(d)) == 0) { #dir is empty
			unlink(d, recursive=TRUE)
		}
	}
}
