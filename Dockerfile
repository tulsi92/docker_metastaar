## Newer version of micromamba with lots of features
FROM mambaorg/micromamba:1.5.8

## Copy env file. Must be chowned to the micromamba user
COPY --chown=micromamba:micromamba R.yaml /tmp/env.yaml

## Install the environment. This is done as the micromamba user so superuser commands will not work
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

## Use rocker base image with R installed
FROM rocker/r-ver:4.2.2

# Install dependencies for micromamba
USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        wget \
        bzip2 \
        ca-certificates \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Install remotes in R
RUN R -e "install.packages('remotes', repos = 'http://cran.rstudio.com')"

# Install specific R packages from GitHub
RUN R -e "remotes::install_github('xihaoli/STAAR')"
RUN R -e "remotes::install_github('xihaoli/STAARpipeline')"
RUN R -e "remotes::install_github('xihaoli/MultiSTAAR')"
RUN R -e "remotes::install_github('zilinli1988/SCANG')"
RUN R -e "remotes::install_github('xihaoli/STAARpipelineSummary')"
RUN R -e "remotes::install_github('xihaoli/MetaSTAAR')"
RUN R -e "remotes::install_github('li-lab-genetics/MetaSTAARlite')"
