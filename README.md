# Retos Cívicos

## Dependencias

- Ruby 2.1.3
- Rails 3.2.19
- PostgreSQL 9.3+

## Instalación / Configuración

1. `bundle install`
1. `cp config/application.sample.yml config/application.yml` y edita (al menos
   hay que establecer `CKAN_API_BASE` y `DEVISE_KEY`).
1. `rake db:setup`
1. `rake db:migrate`
1. `rake db:seed`
1. `rails server`

Para crear una organización:

```ruby
rails console
user = User.new(email: "username@domain", password: "some_password")
organization = Organization.new(slug: "url_shortcut") #  ej. my-organization
user.userable = organization
user.save
```

## Versión en vivo

La aplicación corre en https://retos.codeandomexico.org

## Contribuye

Queremos que este proyecto sea el resultado de un esfuerzo de la comunidad.
Usted puede colaborar con

[código](https://github.com/codeandomexico/retos-civicos/pulls),
[ideas](https://github.com/codeandomexico/retos-civicos/issues) y
[bugs](https://github.com/codeandomexico/retos-civicos/issues).

## Core Team

Este proyecto es una iniciativa de [Cívica
Digital](http://www.codeandomexico.org).

## Licencia

_Available under the license: Apache License, Version 2.0. Read the document
[LICENSE](/LICENSE) for more information._

Creado por [Cívica Digital](http://www.codeandomexico.org), 2013-2015.
