FROM ruby:3.2.2

# Install dependencies
RUN apt-get update && apt-get install -y postgresql-client

# Set working directory
WORKDIR /good-night-clockify

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ['bundle', 'exec', 'rails', 'server', '-b', '0.0.0.0']
