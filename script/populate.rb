#!/bin/env ruby
require 'config/environment'
require 'faker'

STATUSES = ["pending", "resumesubmitted", "accepted", "rejected"]

(1..100).each do |i|
  c = Candidate.new
  c.first_name = Faker::Name.first_name
  c.last_name = Faker::Name.last_name
  c.email = Faker::Internet.email
  c.phone_number = Faker::PhoneNumber.phone_number
  c.position = "Temp"
  c.status = "pending" # STATUSES[rand(STATUSES.size)]
  c.save!

  c.update_attribute(:created_at, i.days.ago)
end
