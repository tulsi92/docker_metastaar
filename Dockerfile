# Newer version of micromamba with lots of features
FROM mambaorg/micromamba:1.5.8

## Copy env file. Must be chowned to the micromamba user
COPY --chown=micromamba:micromamba R.yaml /tmp/env.yaml

## Install the environment. This is done as the micromamba user so superuser commands will not work
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

## Use base image with R installed
# FROM rocker/r-ver:4.2.2

## Change user to root to make root directory and chown it to mamba user. Mamba env is not active here
USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y && \
    apt-get clean \
    apt-get autoclean \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

## Install remotes to install packages from GitHub-devtools?
RUN R -e "install.packages('remotes', repos = 'http://cran.rstudio.com')"

## Install specific R packages from GitHub-devtools?
RUN R -e "remotes::install_github('xihaoli/STAAR')"
RUN R -e "remotes::install_github('xihaoli/STAARpipeline')"
RUN R -e "remotes::install_github('xihaoli/STAARpipelineSummary')"
RUN R -e "remotes::install_github('xihaoli/MultiSTAAR')"
RUN R -e "remotes::install_github('xihaoli/MetaSTAAR')"
RUN R -e "remotes::install_github('li-lab-genetics/MetaSTAARlite')"
