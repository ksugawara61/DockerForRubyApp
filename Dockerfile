FROM nginx:1.17.0-alpine

# for rbenv env
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
ENV RUBY_VERSION 2.5.1

RUN apk add --update \
  bash \
  git \
  wget \
  curl \
  vim \
  build-base \
  readline-dev \
  openssl-dev \
  zlib-dev \
  linux-headers \
  imagemagick-dev \    
  libffi-dev \    
  libffi-dev \
 && rm -rf /var/cache/apk/*

RUN git clone --depth 1 git://github.com/sstephenson/rbenv.git ${RBENV_ROOT} \
 && git clone --depth 1 https://github.com/sstephenson/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build \
 && git clone --depth 1 git://github.com/jf/rbenv-gemset.git ${RBENV_ROOT}/plugins/rbenv-gemset \
 && ${RBENV_ROOT}/plugins/ruby-build/install.sh

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh 

RUN rbenv install $RUBY_VERSION \
 && rbenv global $RUBY_VERSION

RUN gem install bundler
