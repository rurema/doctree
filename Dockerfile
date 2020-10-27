FROM rubylang/ruby:2.7.2-bionic
RUN install -o 1000 -g 1000 -m 755 -d /rurema /rurema/doctree
WORKDIR /rurema/doctree
USER 1000:1000
RUN git clone --depth=1 https://github.com/rurema/bitclust ../bitclust
COPY Gemfile .
RUN bundle install --path=.bundle
ENTRYPOINT ["bundle", "exec"]
CMD ["rake"]
