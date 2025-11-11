# Lord of War

Little experiment for an airsoft community hub

## Installation

Install gems

```bash
bundle install
```

Initialize DB and seeds

```bash
sqlite3 low.db < sql/create_schema.sql
sqlite3 low.db < sql/seeds.sql
```

Start API

```bash
bundle exec rackup -p 4567
```

## Usage

Enter `http://127.0.0.1:4567/`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cultome/lord_of_war. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/cultome/lord_of_war/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LordOfWar project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cultome/lord_of_war/blob/master/CODE_OF_CONDUCT.md).
