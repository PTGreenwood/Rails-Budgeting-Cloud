FROM starefossen/ruby-node
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs vim
RUN mkdir /personalBudgeting
WORKDIR /personalBudgeting
COPY Gemfile personalBudgeting/Gemfile
COPY Gemfile.lock personalBudgeting/Gemfile.lock
RUN bundle install
COPY . /personalBudgeting
