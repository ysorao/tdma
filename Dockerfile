# Usa la versión exacta confirmada: 2.5.0
FROM ruby:2.5.9-bullseye

# 1. Instala dependencias del sistema operativo
# Incluye libpq-dev para la gem 'pg' (PostgreSQL) y Node.js para Asset Pipeline
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# 2. Establece el directorio de trabajo
WORKDIR /usr/src/app

# 3. Copia e instala las Gems
# Primero copia solo los archivos de dependencias para aprovechar el cache de Docker
COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install

# 4. Copia el resto del código de la aplicación
COPY . /usr/src/app

# 5. Configuración de puertos
# El puerto por defecto de Puma o WEBrick
EXPOSE 3000

# 6. Comando de inicio del servidor
# Este comando le dice al contenedor cómo iniciar (usando Puma, el servidor común de Rails)
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
