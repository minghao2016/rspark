FROM rocker/verse:3.6.3-ubuntu18.04
# Updated to rocker: R-3.6.3 Ubuntu-18.04
# Note: problems from keys (.asc) may have to do with switching from xenial to bionic.
# Possible fix: get new keys!
# FROM rocker/verse:3.6.1

MAINTAINER Jim Harner <ejharner@gmail.com>

ARG pgversion=11
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN apt-get update && apt-get install -y  apt-utils apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common tzdata
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    add-apt-repository --yes 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main'

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client-${pgversion} libicu-dev openjdk-8-jdk && apt-get clean && update-java-alternatives -s java-1.8.0-openjdk-amd64
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
RUN JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
RUN apt-get install -y scala
# Switch to rstudio CRAN mirror (untested)
# RUN R CMD options(repos = c(CRAN = "https://cran.rstudio.com"))
# Set environment variable for rJava package installation
ENV LD_LIBRARY_PATH $JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server
# Update environmental variables.  R needs to know these changed in its configuration for it to affect package installation.
RUN R CMD javareconf


####################
# R PACKAGES
####################
# Switch to rstudio CRAN mirror (untested)
# RUN R CMD options(repos = c(CRAN = "https://cran.rstudio.com"))
# Set environment variable for rJava package installation
ENV LD_LIBRARY_PATH $JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/server
# Install R packages
RUN Rscript -e "install.packages(c(\"rjson\", \"RJSONIO\", \"jsonlite\", \"functional\", \"R.methodsS3\", \"caTools\", \"trelliscopejs\", \"RPostgreSQL\", \"RJDBC\", \"housingData\", \"Lahman\", \"nycflights13\", \"flexdashboard\", \"sparklyr\", \"glmnet\", \"reticulate\", \"tensorflow\"), repos = 'http://cran.rstudio.com')"

ADD postgresql-42.2.2.jar /opt

####################
# ENVIRONMENT CONFIG
####################
# Add necessary mods to Renviron file
#ADD Renviron /usr/local/lib/R/etc/
# Create symlink to actual Rscript
RUN ln -s /usr/local/bin/Rscript /usr/bin/Rscript

# USER rstudio
# Install rspark test files
# ADD rspark-tests.tar.gz /home/rstudio
RUN mkdir /home/rstudio/rspark-tests && \
git clone https://github.com/jharner/rspark-tests.git /tmp/foo && \
cd /tmp/foo && \
git archive master | tar -x -C /home/rstudio/rspark-tests  && \
cd && \
rm -rf /tmp/foo
RUN mkdir /home/rstudio/rspark-tutorial && \
git clone https://github.com/jharner/rspark-tutorial.git /tmp/foo && \
cd /tmp/foo && \
git archive master | tar -x -C /home/rstudio/rspark-tutorial  && \
cd && \
rm -rf /tmp/foo
RUN chown -R rstudio:rstudio /home/rstudio

EXPOSE 8787

CMD ["/init"]


	
