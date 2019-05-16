# Json Api Deserializer

> This is the deserializer code from [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers) for the JSON API spec

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_api_deserializer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_api_deserializer

## API

`JsonApiDeserializer.parse({}, [options])`

options = `:only, :except, :keys, :polymorphic`

## Usage

```ruby
JsonApiDeserializer.parse({
  'data' => {
    'type' => 'photos',
    'id' => 'zorglub',
    'attributes' => {
      'title' => 'Ember Hamster',
      'src' => 'http://example.com/images/productivity.png'
    }
  })

=> { title: 'Ember Hamster', src: 'http://example.com/images/productivity.png' }
```

```ruby
JsonApiDeserializer.parse({
  'data' => {
    'type' => 'photos',
    'id' => 'zorglub',
    'attributes' => {
      'title' => 'Ember Hamster',
      'src' => 'http://example.com/images/productivity.png'
    }
  }, only: [:title])

=> { title: 'Ember Hamster' }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nikkypx/json_api_deserializer
