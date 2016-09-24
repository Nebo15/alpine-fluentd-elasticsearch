FROM fluent/fluentd:v0.12.29

MAINTAINER Nebo #15 <support@nebo15.com>

# Reset user to have privileged env
WORKDIR /home/fluent
USER root

# Build environment
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH

# Install ElasticSearch and kubernetes_metadata_filter plugins
RUN apk --no-cache --update add sudo build-base ruby-dev && \
    sudo -u fluent gem install fluent-plugin-elasticsearch \
                               fluent-plugin-record-reformer \
                               fluent-plugin-kubernetes \
                               fluent-plugin-kubernetes_metadata_filter && \
    rm -rf /home/fluent/.gem/ruby/2.3.0/cache/*.gem && sudo -u fluent gem sources -c && \
    apk del sudo build-base ruby-dev && rm -rf /var/cache/apk/*

# Export Fluentd port
EXPOSE 24284

# Switch to system user
USER fluent

# Start fluentd
CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
