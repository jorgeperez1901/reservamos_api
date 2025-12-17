# Reservamos API 🌎🌤️

API desarrollada en **Ruby on Rails**.  
Esta API se encarga de la autenticación de usuarios y de integrar información de ciudades desde **Reservamos** con datos climáticos obtenidos desde **OpenWeather**.

---

## 🚀 Tecnologías

- Ruby **3.0.0**
- Ruby on Rails **6.x / 7.x**
- SQLite
- JWT (autenticación)
- HTTParty
- OpenWeather API

---

## 📋 Requisitos

- Ruby **3.0.0** (recomendado con RVM)
- Rails 6.x o 7.x
- Bundler
- SQLite
- Git

---

## ⚙️ Instalación

Clona el repositorio:

bash
git clone git@github.com:jorgeperez1901/reservamos_api.git
cd reservamos_api

nstala la versión de Ruby:

rvm install 3.0.0
rvm use 3.0.0


Instala dependencias:

bundle install


Configura la base de datos:

rails db:create
rails db:migrate
---

# Configuración de credenciales 🔐

Edita las credenciales de Rails:

EDITOR="nano" rails credentials:edit

Agrega la siguiente información:

openweather:
  api_key: YOUR_OPENWEATHER_API_KEY
---

# ▶️ Ejecución

Levanta el servidor:

rails server


Accede desde el navegador o cliente HTTP:

http://localhost:3000

# 🔑 Autenticación

La API utiliza JWT para proteger los endpoints.

Flujo:

Signup / Login

Generación de token

Envío del token en el header:

Authorization: Bearer <token>

# 🌎 Endpoints principales
# 🔹 Autenticación

POST /auth/signup

POST /auth/login

# 🔹 Places

GET /api/places?type=city

Lista de ciudades populares con clima actual

# 🔹 Forecast

GET /api/show/:lat/:lon

Pronóstico del clima a 7 días
