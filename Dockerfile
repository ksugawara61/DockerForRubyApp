FROM nginx:1.17.0-alpine

ENV DOCUMENT_ROOT /var/www/html
ENV NGINX_CONF_PATH /etc/nginx
ENV NGINX_LOG_PATH /var/log/nginx
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv
ENV RUBY_VERSION 2.5.1

# for rbenv and ruby setting
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

# for nginx setting
ADD ./${NGINX_CONF_PATH}/ssl/  ${NGINX_CONF_PATH}/ssl/
ADD ./${NGINX_CONF_PATH}/conf.d/  ${NGINX_CONF_PATH}/conf.d/
COPY ./${NGINX_CONF_PATH}/nginx.conf  ${NGINX_CONF_PATH}/nginx.conf
RUN mkdir -p ${NGINX_LOG_PATH}/default ${NGINX_LOG_PATH}/ruby
RUN mkdir -p ${DOCUMENT_ROOT}
ADD ./${DOCUMENT_ROOT}/index.html ${DOCUMENT_ROOT}/index.html
