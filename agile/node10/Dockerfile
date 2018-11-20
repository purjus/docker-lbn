FROM purjuscommunication/lbn-agile-base

ARG NODE_VERSION=10

# Node
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install --yes --quiet --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq && apt-get install --yes --quiet --no-install-recommends yarn \
    && rm -rf /var/lib/apt/lists/*

CMD ["php-fpm"]
