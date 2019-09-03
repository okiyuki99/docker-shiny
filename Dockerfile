FROM rocker/shiny:latest

LABEL maintainer "bigtree3101@gmail.com"

RUN rm -rf /var/lib/apt/lists/* && apt-get update && \
  apt-get install -y --no-install-recommends software-properties-common supervisor wget openssh-server sudo \
    git-core fonts-vlgothic nkf jq \
    rsync gawk netcat curl libglu1-mesa-dev libv8-dev \
    mysql-client && \
    # locale
    sed -ir 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && update-locale LANG=ja_JP.UTF-8

# for build
RUN apt-get update && apt-get install -y --no-install-recommends \
  libudunits2-dev libgdal-dev libssl-dev zlib1g-dev libmagick++-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# rJava
RUN apt-get update && apt-get install -y --no-install-recommends libbz2-dev libpcre3-dev openjdk-8-jdk liblzma-dev && \
  R CMD javareconf && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# pacman
RUN install2.r --error --deps TRUE pacman

# renv
RUN R -e 'install.packages("https://github.com/rstudio/renv/archive/0.5.0-66.tar.gz", repo=NULL, type="source")'

# other
RUN install2.r --error --deps TRUE \
  config \
  dplyr \
  DT \
  forcats \
  ggplot2 \
  git2r \
  glue \
  ggplot2 \
  httr \
  kableExtra \
  logger \
  plotly \
  purrr \
  testthat

# shiny tools
RUN install2.r --error --deps TRUE shinyAce shinycssloaders shinythemes shinydashboard shinyalert tippy shinytest

# Install PhantomJS for shinytest
RUN R -e 'shinytest::installDependencies()'

# DB management libraries
RUN apt-get update && apt-get install -y --no-install-recommends libpq-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  install2.r --error DBI RPostgreSQL RMySQL dbplyr

# shiny
EXPOSE 3838
CMD ["/usr/bin/shiny-server.sh"]

