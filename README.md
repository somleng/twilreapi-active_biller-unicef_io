# Twilreapi::ActiveBiller::UnicefIO

[![Build Status](https://travis-ci.org/dwilkie/twilreapi-active_biller-unicef_io.svg?branch=master)](https://travis-ci.org/dwilkie/twilreapi-active_biller-unicef_io)

This gem contains billing logic for People In Need Cambodia for [Twilreapi](https://github.com/dwilkie/twilreapi).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'twilreapi-active_biller-unicef_io', :github => "dwilkie/twilreapi-active_biller-unicef_io"
```

And then execute:

    $ bundle

## Configuration

To configure [Twilreapi](https://github.com/dwilkie/twilreapi) to use `Twilreapi::ActiveBiller::UnicefIO::Biller`, set the environment variable `ACTIVE_BILLER_CLASS_NAME=Twilreapi::ActiveBiller::UnicefIO::Biller`

The following environment variables can be set to determine the billing:

* `TWILREAPI_ACTIVE_BILLER_UNICEF_IO_PER_MINUTE_CALL_RATE_TO_${OPERATOR_ID}`:  The per minute call rate to `OPERATOR_ID` in micro currency units. E.g. `700000` is equivalent to `$0.70`
* `TWILREAPI_ACTIVE_BILLER_UNICEF_IO_BILL_BLOCK_SECONDS`: The amount of seconds in a bill block. E.g. `15` means 15 second bill blocks.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dwilkie/twilreapi-active_biller-unicef_io.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

