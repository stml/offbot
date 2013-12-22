# offbott by James and ntlk

[Offbott](http://offbott.com/) is a (mostly) friendly robot who helps small teams keep a journal of their projects.

Every day, Offbott sends an email to every member of your team, asking what they're up to. It might be a little, it might be a lot. You don't even have to answer if you're busy, or working on something else.

Offbott remembers what everyone says, and at any stage of the project you and everyone else on the team can check in to see how it's all going. And at the end of the project, you've got a journal to save and review.

It's pretty simple.

[Register](http://offbott.com/people/sign_up) to start tracking your projects on the hosted version, or host your own.

This project is currently maintained by [ntlk](http://github.com/ntlk).

## Running your own

### Requirements

Offbot is a Ruby on Rails app. It uses Iconv which requires Ruby 1.9.2.

### Installation

You will want to make adjustments to configure it, so best approach is to fork the repository.

You will need to install all the gems:

    bundle install

Then set up the database for development:

    rake db:create db:migrate


### Configuration

You will have to change a few things before it will work correctly. This project hasn't been designed to be configurable for self-hosting out of the box.

Offbott currently requires an external email delivery service to run. It's configured to use [Sendgrid](http://sendgrid.com/), but you should be able to easily replace it with [Mandrill](http://mandrillapp.com/) for example.

Sendgrid is available as a Heroku add-on, so once added you don't have to do anything else in production, but you will have to add Sendgrid configuration to your environment variables:

    SENDGRID_USERNAME=XXXX
    SENDGRID_PASSWORD=XXXX


