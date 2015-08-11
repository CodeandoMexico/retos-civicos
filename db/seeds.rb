# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  # organizations
  org1 = Organization.create(slug: 'super-cool')
  org2 = Organization.create(slug: 'association-x')

  # admin users
  u1 = User.new(name: 'Super Cool', email: 'super_cool_org@gmail.com', password: 'password')
  u2 = User.new(name: 'Association X', email: 'association_x@gmail.com', password: 'password')
  u1.userable = org1
  u2.userable = org2
  u1.save
  u2.save

  # challenges
  c1 = Challenge.new(
    title: 'Quitando el hambre',
    description: 'Ésta es una descripción del reto',
    status: 'open',
    pitch: 'Ésta es un pitch del reto',
    about: 'Acerca del reto',
    prize: 'Contrato por 300K MXN',
    starts_on: Time.now,
    ideas_phase_due_on: Time.now + 30.days,
    ideas_selection_phase_due_on: Time.now + 60.days,
    prototypes_phase_due_on: Time.now + 90.days,
    finish_on: Time.now + 120.days,
  )

  c2 = Challenge.new(
    title: 'Resolvidendo la inseguridad',
    description: 'Ésta es una descripción del reto',
    status: 'open',
    pitch: 'Ésta es un pitch del reto',
    about: 'Acerca del reto',
    prize: 'Contrato por 300K MXN',
    starts_on: Time.now - 30.days,
    ideas_phase_due_on: Time.now,
    ideas_selection_phase_due_on: Time.now + 30.days,
    prototypes_phase_due_on: Time.now + 60.days,
    finish_on: Time.now + 90.days,
  )

  c3 = Challenge.new(
    title: 'Conoce tus comunidades',
    description: 'Ésta es una descripción del reto',
    status: 'open',
    pitch: 'Ésta es un pitch del reto',
    about: 'Acerca del reto',
    prize: 'Contrato por 300K MXN',
    starts_on: Time.now - 30.days,
    ideas_phase_due_on: Time.now,
    ideas_selection_phase_due_on: Time.now + 30.days,
    prototypes_phase_due_on: Time.now + 60.days,
    finish_on: Time.now + 90.days,
  )

  c1.organization = org1
  c2.organization = org1
  c3.organization = org2

  c1.save
  c2.save
  c3.save

  # Members
  u1 = User.new(name: 'Member 1', email: 'member+1@gmail.com', password: 'password')
  u2 = User.new(name: 'Member 2', email: 'member+2@gmail.com', password: 'password')
  u3 = User.new(name: 'Member 3', email: 'member+3@gmail.com', password: 'password')

  u1.userable = Member.create
  u2.userable = Member.create
  u3.userable = Member.create
  u1.save
  u2.save
  u3.save
end
