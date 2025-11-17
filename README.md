# Lord of War

Little experiment for an airsoft community hub

## Installation

Install gems

```bash
bundle install
```

Initialize DB and seeds

```bash
$ sqlite3 low.db < sql/create_schema.sql
$ sqlite3 low.db < sql/seeds.sql
$ ./bin/scraper_veta_airsoft upload data/vetaairsoft/products_clean.json
$ sqlite3 low.db < sql/test.sql
```

Start API

```bash
$ bundle exec rackup --port 4567 --server puma --host 0.0.0.0
```

Process teams information

```bash
$ ./bin/scraper_teams scrap
$ ./bin/scraper_teams images
$ ./bin/scraper_teams gensql "74604fce-0953-4e87-93e5-e10e2b7389ff" | xsel --clipboard
```

## Usage

Enter `http://127.0.0.1:4567/`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cultome/lord_of_war. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/cultome/lord_of_war/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the LordOfWar project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cultome/lord_of_war/blob/master/CODE_OF_CONDUCT.md).
