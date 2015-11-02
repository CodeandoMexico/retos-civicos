Retos Públicos
============

##Dependencias
- Ruby 2.1.3
- Rails 3.2.19
- PostgreSQL 9.3+


##Instalación / Configuración
1. bundle install
2. rake db:setup
3. rake db:migrate
4. rails server

Para crear una organización:
``` ruby
rails console
user = User.new(email: "username@domain", password: "some_password")
organization = Organization.new(slug: "url_shortcut") # ej. my-organization
user.userable = organization
user.save
```

##Demo
Puedes visualizar un demo en la aplicación de [retos](http://retos.datos.gob.mx/)

##¿Preguntas o problemas?

Mantenemos la conversación del proyecto en nuestra página de problemas [issues] (https://github.com/civica-digital/retos-publicos/issues).

##Contribuye

Queremos que este proyecto sea el resultado de un esfuerzo de la comunidad. Usted puede colaborar con [código](https://github.com/civica-digital/retos-publicos/pulls), [ideas](https://github.com/civica-digital/retos-publicos/issues) y [bugs](https://github.com/civica-digital/retos-publicos/issues).

##Core Team

Este proyecto es una iniciativa de [Cívica Digital](http://www.codeandomexico.org).

##Licencia

_Available under the license: Apache License, Version 2.0. Read the document [LICENSE](/LICENSE) for more information._

Creado por [Cívica Digital](http://www.codeandomexico.org), 2013-2015.
