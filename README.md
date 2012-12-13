# Truenames

Improve test failure output by introspecting variable names.

Sometimes this is hard to read:

```
  1) User when looked up with a GitHub OAuth callback hash updates with the most recent information
     Failure/Error: expect(lookup_user).to eq(existing_user)

       expected: #<User id: 684, uid: 74387, oauth_token: "oldtoken", nickname: "oldnick", email: "old@email.com", name: "Old Name", created_at: "2012-10-13 06:26:11", updated_at: "2012-10-13 06:26:11">
            got: #<User id: 685, uid: 12345, oauth_token: "token-abc123", nickname: "jasonm", email: "jason@example.com", name: "Jason Morrison", created_at: "2012-10-13 06:26:11", updated_at: "2012-10-13 06:26:11">
```

and something like this might be easier:

```
  1) User when looked up with a GitHub OAuth callback hash updates with the most recent information
     Failure/Error: expect(lookup_user).to eq(existing_user)

       expected: lookup_user
            got: unrelated_user
```

## Installation

Add this line to your application's Gemfile:

    gem 'truenames'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install truenames

## Usage

For RSpec usage, add `require 'truenames/rspec'` to `spec/spec_helper.rb`.

![more magic](http://farm6.staticflickr.com/5043/5252815237_6a593edb76.jpg)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

* Is formatting of ambiguous cases, especially inside lists, helpful?
  Would permutations be better? E.g.:
  "(a, b, c or d)" vs "(a, b, c) or (a, b, d)"
* Match let! and let statements, without triggering lets which aren't yet evaled
* Make test-unit and minitest and whatever wrappers in addition to RSpec
