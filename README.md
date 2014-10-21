# Apress::Utils



## Gem Releasing

1. должен быть настроен git remote upstream и должны быть права на push
1. git checkout master
2. git pull upstream master
3. правим версию гема в файле VERSION в корне гема. (читаем правила версионирования http://semver.org/)
4. bundle exec rake release

## Contributing

1. Fork it ( https://github.com/abak-press/apress-utils/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
