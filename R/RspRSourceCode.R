###########################################################################/**
# @RdocClass RspRSourceCode
#
# @title "The RspRSourceCode class"
#
# \description{
#  @classhierarchy
#
#  An RspRSourceCode object is an @see "RspSourceCode" holding R source code.
# }
# 
# @synopsis
#
# \arguments{
#   \item{...}{@character strings.}
# }
#
# \section{Fields and Methods}{
#  @allmethods
# }
# 
# @author
#
# @keyword internal
#*/###########################################################################
setConstructorS3("RspRSourceCode", function(...) {
  extend(RspSourceCode(...), "RspRSourceCode");
})




#########################################################################/**
# @RdocMethod getCompleteCode
#
# @title "Gets the complete R source code"
#
# \description{
#  @get "title" with output functions defined.
# }
#
# @synopsis
#
# \arguments{
#   \item{output}{A @character string specifying type of output function.}
#   \item{...}{Not used.}
# }
#
# \value{
#  Returns a @character string.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/######################################################################### 
setMethodS3("getCompleteCode", "RspRSourceCode", function(object, output=c("string"), ...) {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Local functions
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  minIndent <- function(s) {
    s <- gsub('"\n"', '"\r"', s);
    s <- strsplit(s, split="\n", fixed=TRUE)[[1]];
    s <- sapply(s, FUN=function(s) gsub('"\r"', '"\n"', s));
    names(s) <- NULL;

    # Clean all-blank lines
    s <- gsub("^[ ]*$", "", s);

    # Find minimum indentation of non-blank lines
    idxs <- which(nchar(s) > 0L);

    # Nothing to do?
    if (length(idxs) == 0L) {
      return(s);
    }

    prefix <- gsub("^([ ]*).*", "\\1", s[idxs]);
    min <- min(nchar(prefix));

    # Nothing to do?
    if (min == 0L) {
      return(s);
    }

    pattern <- sprintf("^%s", paste(rep(" ", times=min), collapse=""));
    s <- gsub(pattern, "", s);

    s;
  } # minIndent()

  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Validate arguments
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Argument 'output':
  output <- match.arg(output);



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Create header and footer code
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (output == "string") {
    # Build R source code
    header <- minIndent('
      .rcon <- textConnection(NULL, open="w", local=TRUE);
      on.exit({ if (exists(".rcon")) { close(.rcon); rm(.rcon); }}, add=TRUE);
  
      .ro <- function(..., collapse="", sep="") {
        msg <- paste(..., collapse=collapse, sep=sep);
        base::cat(msg, sep="", file=.rcon);
      } # .ro()
    ');

    footer <- minIndent('
      .ro("\n"); # Force a last complete line
      rm(.ro);
      .rres <- paste(textConnectionValue(.rcon), collapse="\n");
      close(.rcon); rm(.rcon);

      # Return result and remove ".rres" at the same time
      (function(x) {
        res <- force(x);
        rm(".rres", envir=parent.frame());
        res;
      })(.rres);
    ');
  } # if (output == ...)


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Merge all code
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  code <- c(header, object, footer);
  code <- paste(code, collapse="\n");

  code;
}, protected=TRUE) # getCompleteCode()



#########################################################################/**
# @RdocMethod parse
#
# @title "Parses the R code"
#
# \description{
#  @get "title".
# }
#
# @synopsis
#
# \arguments{
#   \item{...}{Additional arguments passed to @seemethod "getCompleteCode".}
# }
#
# \value{
#  Returns an @expression.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/######################################################################### 
setMethodS3("parse", "RspRSourceCode", function(object, ...) {
  # Make R source code header and footer
  code <- getCompleteCode(object, ...);

  # Parse R source code
  expr <- base::parse(text=code);

  expr;
}, protected=TRUE) # parse()



#########################################################################/**
# @RdocMethod evaluate
# @aliasmethod findProcessor
#
# @title "Parses and evaluates the R code"
#
# \description{
#  @get "title".
# }
#
# @synopsis
#
# \arguments{
#   \item{output}{A @character string specifying type of output function.}
#   \item{envir}{The @environment in which the RSP string is evaluated.}
#   \item{args}{A named @list of arguments assigned to the environment
#     in which the RSP string is parsed and evaluated. See @see "rargs".}
#   \item{...}{Optional arguments passed to @see "base::eval".}
# }
#
# \value{
#  Returns the outputted @character string, iff any.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/######################################################################### 
setMethodS3("evaluate", "RspRSourceCode", function(object, output=c("string"), envir=parent.frame(), args="*", ..., verbose=FALSE) {
  # Argument 'args':
  args <- rargs(args);


  # Parse R RSP source code
  expr <- parse(object, output=output);

  # Assign arguments to the parse/evaluation environment
  attachLocally(args, envir=envir);

  # Evaluate R source code
  res <- eval(expr, envir=envir, ...);

  RspStringProduct(res, type=getType(object));
}) # evaluate()


setMethodS3("findProcessor", "RspRSourceCode", function(object, ...) {
  evaluate;
}) # findProcess()



#########################################################################/**
# @RdocMethod tangle
#
# @title "Drops all text-outputting calls from the R code"
#
# \description{
#  @get "title".
# }
#
# @synopsis
#
# \arguments{
#   \item{...}{Not used.}
# }
#
# \value{
#  Returns an @see "RspRSourceCode" objects without output calls.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/######################################################################### 
setMethodS3("tangle", "RspRSourceCode", function(code, ...) {
  # Remember attributes
  attrs <- attributes(code);

  # Drop all .ro("...")
  excl <- (regexpr(".ro(\"", code, fixed=TRUE) != -1L);
  code <- code[!excl];

  # Replace all .ro({...}) with {...}
  idxs <- grep(".ro(", code, fixed=TRUE);
  code[idxs] <- gsub(".ro(", "", code[idxs], fixed=TRUE);
  code[idxs] <- gsub("[)]$", "", code[idxs], fixed=FALSE);

  # Reset attributes
  attributes(code) <- attrs;

  code;
}, protected=TRUE) # tangle()


##############################################################################
# HISTORY:
# 2013-02-16
# o Added findProcessor() for RspRSourceCode, which returns the evaluate()
#   method.
# o Added getCompleteCode() for RspRSourceCode.
# o Renamed RSourceCode to RspRSourceCode.
# 2013-02-14
# o Added tangle() for RSourceCode.
# 2013-02-11
# o Added Rdoc help.
# 2013-02-09
# o Created.
##############################################################################