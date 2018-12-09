FROM ruby:2.5.3-alpine

# Install apt based dependencies required to run Rails as 
# well as RubyGems. As the Ruby image itself is based on a 
# Debian image, we use apt-get to install those.
RUN apk --update add build-base tzdata \
  aspell aspell-utils aspell-en

# Install latin dictionary because it is not available as a package for alpine
RUN wget https://ftp.gnu.org/gnu/aspell/dict/la/aspell6-la-20020503-0.tar.bz2 && \
  bunzip2 aspell6-la-20020503-0.tar.bz2 && \
  tar -xvf aspell6-la-20020503-0.tar && \
  cd aspell6-la-20020503-0 && \
  ./configure && \
  make && \
  make install

# Configure the main working directory. This is the base 
# directory used in any further RUN, COPY, and ENTRYPOINT 
# commands.
RUN mkdir -p /app
WORKDIR /app

RUN mkdir -p /data
RUN aspell -d en dump master | aspell expand > /data/english-words.txt
RUN aspell -d la dump master | aspell expand > /data/latin-words.txt

# Copy the Gemfile as well as the Gemfile.lock and install 
# the RubyGems. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . ./

