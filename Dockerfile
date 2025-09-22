FROM ruby:3.4.6-bookworm
RUN useradd rurema --create-home --shell /bin/bash
USER rurema:rurema
ENV BUNDLE_AUTO_INSTALL true
WORKDIR /workspaces/doctree
ENTRYPOINT ["bundle", "exec"]
CMD ["rake"]
