FROM ruby:3.4.1-slim

# Instalar dependencias del sistema
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    git \
    curl \
    libvips-dev \
    imagemagick \
    wkhtmltopdf \
    fonts-liberation \
    libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

# Directorio de trabajo
WORKDIR /app

# Copiar Gemfile primero para cachear dependencias
COPY Gemfile Gemfile.lock ./

# Instalar bundler y gemas
RUN gem install bundler:2.4.22 && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Copiar el resto de la aplicación
COPY . .

# Precompilar assets
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Exponer puerto
EXPOSE 3000

# Comando por defecto
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
