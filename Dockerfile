FROM ruby:3.4.1-bookworm
ARG HOST_UID=1000
RUN useradd rurema -u ${HOST_UID} --create-home --shell /bin/bash
USER rurema:rurema
ENV BUNDLE_AUTO_INSTALL true
WORKDIR /workspaces/doctree
ENTRYPOINT ["bundle", "exec"]
CMD ["rake"]
