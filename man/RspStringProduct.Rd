%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  RspStringProduct.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 \name{RspStringProduct}
\docType{class}
\alias{RspStringProduct}


 \title{The RspStringProduct class}

 \description{
  Package:  R.rsp \cr
\bold{Class RspStringProduct}\cr

\code{logical}\cr
\code{~~|}\cr
\code{~~+--}\code{\link[R.rsp]{RspProduct}}\cr
\code{~~~~~~~|}\cr
\code{~~~~~~~+--}\code{RspStringProduct}\cr

\bold{Directly known subclasses:}\cr
\cr

public class \bold{RspStringProduct}\cr
extends \link[R.rsp]{RspProduct}\cr



  An RspStringProduct is an \code{\link{RspProduct}} that represents an
  RSP product in form of a \code{\link[base]{character}} string.
 }

 \usage{RspStringProduct(...)}

 \arguments{
   \item{...}{\code{\link[base]{character}} strings passed to \code{\link{RspProduct}}.}
 }

 \section{Fields and Methods}{
  \bold{Methods:}\cr
\tabular{rll}{
 \tab \code{\link[R.rsp:as.character.RspStringProduct]{as.character}} \tab Returns a plain character string representation of an RSP string product.\cr
 \tab \code{\link[R.rsp:print.RspStringProduct]{print}} \tab Prints an RSP string product.\cr
}


 \bold{Methods inherited from RspProduct}:\cr
findProcessor, getType, hasProcessor, print, process

 \bold{Methods inherited from logical}:\cr
as.data.frame, as.raster, whichVector

 }

 \author{Henrik Bengtsson (\url{http://www.braju.com/R/})}


\keyword{classes}
\keyword{internal}