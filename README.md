# Canari

A gem to monitor TLS certificates using Cert Stream

## Installation

Install the gem (deployment to Rubygems coming soon) :

```ruby
gem install canari
```

Install memcached and create the `canari.yml` configuration file:

```
---
:memcached:
  :host: localhost
  :port: 11211
  :namespace: canari
:smtp:
  :address: smtp.server.example
  :port: 25
:notifier:
  :from: your-email@example.com
  :to: your-email@example.com
```

Create the `domains.txt` file containing the domain names you'd like to
monitor, one name per line:

```
google.com
gouv.fr
fr
...
```

Please notice each match, even a partial one, will trigger an
email notification. In the example above, every certificate issued for the
`.fr` TLD would result in a notification.

Then execute:

    $ canari start

More options available using:

    $ canari help

Or:

    $ canari help start
