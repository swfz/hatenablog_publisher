# HatenablogPublisher

![ci](https://github.com/swfz/hatenablog_publisher/workflows/ci/badge.svg)

Module to manage local markdown and images using Hatena Blog API and PhotoLife API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hatenablog_publisher'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hatenablog_publisher

## Usage

- Patterns for writing CLI commands

```
#!/usr/bin/env ruby
require 'hatenablog_publisher'
require 'active_support/core_ext/hash'
require 'optparse'

args = ARGV.getopts('',
                    'draft',
                    'user:',
                    'site:',
                    'ad_type:',
                    'ad_file:',
                    'filename:',
                    'config:',
                    'data_file:',
                    'trace').symbolize_keys

HatenablogPublisher.publish(args)
```

### Option

#### required
- user
    - posted by.

- site
    - blog domain

- filename
    - markdown file

#### optional

- ad_type
    - image
    - html

- ad_file
    - YAML syntax

- config
    - A file containing command line options
    - YAML format

- data_file
    - for article management
    - JSON format

- trace
    - Detailed Output

### Ad Content

require `ad_type` and `ad_file`

- `ad_file`

Insert a pre-defined ad tag (assuming you are an Amazon associate) at the end of the article

e.g.)

```
---
AWS:
  - name: Book Name
    html: '<iframe ........'
    image: '<a target.......'
  - name: Book Name2
    html: '<iframe ........'
    image: '<a target.......'
Sample:
  - name: Book Name3
    html: '<iframe ........'
    image: '<a target.......'
```

### Use Config File

default: hatenablog_publisher_config.yml

If you want to specify

```
--config my_config.yml
```

available ERB syntax

e.g)

```
consumer_key: <%= ENV['HATENABLOG_CONSUMER_KEY'] %>
consumer_secret: <%= ENV['HATENABLOG_CONSUMER_SECRET'] %>
access_token: <%= ENV['HATENABLOG_ACCESS_TOKEN'] %>
access_token_secret: <%= ENV['HATENABLOG_ACCESS_TOKEN_SECRET'] %>
user: hoge
site: hoge.hatenablog.jp
```

### If you want to manage the data in a markdown file

In the first line of the markdown, write the following

front_matter format

- sample.md

```
---
title: sample markdown
category:
  - Markdown
  - Sample
```

after published, data such as article ID will be added to the file.

### If you want to manage your data in a custom data file

Data such as article and image IDs are recorded in markdown by default

If you are managing the article data with confidence, you can specify an article data management file to record the data

```
hatenablog_publisher --data_file article_data.json
```

It must be written in the following JSON format

e.g)

- data.json

```
[
  {
    "title": "Article Title",
    "category": [
      "Sample",
      "Markdown"
    ]
  },
  {
    "title": "Article Title2",
    "category": [
      "Sample",
      "Markdown"
    ]
  },
  .....
  .....
  .....
]
```

after published, data such as article ID will be added to the file.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hatenablog_publisher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/hatenablog_publisher/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HatenablogPublisher project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hatenablog_publisher/blob/master/CODE_OF_CONDUCT.md).
