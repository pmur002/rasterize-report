
# Base image
FROM ubuntu:16.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

# Install additional software
# R stuff
RUN apt-get update && apt-get install -y \
    xsltproc \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    bibtex2html \
    subversion 

# Get R commit r74634 
RUN svn co -r74634 https://svn.r-project.org/R/trunk/ R
# Building R from source
RUN apt-get install -y r-base-dev texlive-full libcairo2-dev
RUN cd R; ./configure --with-x=no --without-recommended-packages 
RUN cd R; make
RUN cd R; make install

# For building the report
RUN Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("xml2", "1.1.1", repos="https://cran.rstudio.com/")'
RUN apt-get install -y imagemagick

# Packages used in the report
RUN Rscript -e 'library(devtools); install_version("lattice", "0.20-35", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("ggplot2", "2.2.1", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("png", "0.1-7", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gridGraphics", "0.3-0", repos="https://cran.rstudio.com/")'
RUN apt-get install -y libmagick++-dev
RUN Rscript -e 'library(devtools); install_version("magick", "1.7", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("gridSVG", "1.6-0", repos="https://cran.rstudio.com/")'

# The main report package(s)
RUN Rscript -e 'library(devtools); install_github("pmur002/rasterize@v0.1", repos="https://cran.rstudio.com/")'


