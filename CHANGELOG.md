# v2.9.1

* 2021-07-22 [dd0a3f8](../../commit/dd0a3f8) - __(Igor Prudnikov)__ Release v.2.9.1 
* 2021-07-22 [887740d](../../commit/887740d) - __(Igor Prudnikov)__ fix: fix frozen string modification 
* 2021-07-22 [dd73cee](../../commit/dd73cee) - __(Igor Prudnikov)__ chore: remove encoding comments 

# v2.9.0

* 2021-07-20 [99a6f6c](../../commit/99a6f6c) - __(Andrew N. Shalaev)__ fix: use appropriate rspec-rails version 
* 2021-07-16 [0bf36de](../../commit/0bf36de) - __(Andrew N. Shalaev)__ feature: freeze string literals 
* 2021-07-16 [066b36f](../../commit/066b36f) - __(Andrew N. Shalaev)__ feature: add ruby2.4 support 

# v2.8.6

* 2021-07-09 [c08aab7](../../commit/c08aab7) - __(Andrew N. Shalaev)__ fix: include patch for formbuilder for error_message_on helper 
https://jira.railsc.ru/browse/BPC-17628

# v2.8.5

* 2021-02-20 [40c5fce](../../commit/40c5fce) - __(TamarinEA)__ fix: do not rewrite rails method in cached queries 

# v2.8.4

* 2021-02-15 [e5a1a40](../../commit/e5a1a40) - __(Simeon Movchan)__ fix: dont cache queries with joins 
https://jira.railsc.ru/browse/PC4-25904

# v2.8.3

* 2020-07-27 [895b485](../../commit/895b485) - __(Andrew N. Shalaev)__ fix: check and dup frozen strings 

# v2.8.2

* 2020-01-24 [5757009](../../commit/5757009) - __(ZhidkovDenis)__ chore: move to drone 1.6 
* 2020-01-21 [9f1d1ce](../../commit/9f1d1ce) - __(ZhidkovDenis)__ fix: replace deleted helper form_tag_in_block in rails 4.2 
* 2020-01-21 [abdffe9](../../commit/abdffe9) - __(ZhidkovDenis)__ chore: drop rails 3.2 support, run drone with ruby 2.3 

# v2.8.1

* 2019-06-11 [5f34db3](../../commit/5f34db3) - __(Valery Glyantsev)__ fix: read cache without delete 
https://jira.railsc.ru/browse/PC4-22381

# v2.8.0

* 2018-05-25 [97bb6a2](../../commit/97bb6a2) - __(Zhidkov Denis)__ feat: allow to set time precision for json encoder in rails 4.0.x 
https://jira.railsc.ru/browse/ORDERS-1589

# v2.7.0

* 2018-05-02 [e9833c1](../../commit/e9833c1) - __(Artem Napolskih)__ feature: return behavior method first from Rails 3x 

# v2.6.2

* 2018-04-06 [ffbf04e](../../commit/ffbf04e) - __(Artem Napolskih)__ feature: rails 4 Flash fixes 
https://github.com/rails/rails/commit/b97e087321f33283d836c5b5964976c88230349a

# v2.6.1

* 2018-03-16 [442f2ac](../../commit/442f2ac) - __(Mikhail Nelaev)__ fix: не затирать before_commit_changed до завершения транзакции 
https://jira.railsc.ru/browse/GOODS-1183

* 2018-03-16 [bb2329e](../../commit/bb2329e) - __(Mikhail Nelaev)__ chore: use postgres 9.6 

# v2.6.0

* 2018-03-20 [21f3cf8](../../commit/21f3cf8) - __(Artem Napolskih)__ feature: rails 4 Flash fixes 
* 2018-01-16 [5044919](../../commit/5044919) - __(Artem Napolskih)__ Fix error_message_on helper on Rails 4 
* 2018-01-16 [2b86493](../../commit/2b86493) - __(Denis Korobicyn)__ chore: limit version pg 
* 2018-01-16 [909621f](../../commit/909621f) - __(Denis Korobicyn)__ fix: allow nil values on enum for rails 4 
https://jira.railsc.ru/browse/PC4-21363

# v2.5.0

* 2018-01-18 [f9f1087](../../commit/f9f1087) - __(Michail Merkushin)__ fix: Lock pg less then 1 
* 2017-12-27 [f6a1167](../../commit/f6a1167) - __(korotaev)__ feat(cached_queries): local store expiring setting 
https://jira.railsc.ru/browse/GOODS-964

# v2.4.0

* 2017-08-07 [1522c65](../../commit/1522c65) - __(Semyon Pupkov)__ Fix set false default for rails4 
https://jira.railsc.ru/browse/USERS-452

* 2017-08-01 [4344b8f](../../commit/4344b8f) - __(Artem Napolskih)__ fix: returns lost patches 
* 2017-07-30 [0072435](../../commit/0072435) - __(Artem Napolskih)__ feature: introduce local cache to query cache 
* 2017-07-19 [3cc634c](../../commit/3cc634c) - __(Semyon Pupkov)__ fix: remove enum types momoization 
* 2017-07-18 [1de521e](../../commit/1de521e) - __(Semyon Pupkov)__ feature: support enums for rails 4.0 (#40) 
https://jira.railsc.ru/browse/USERS-452
* 2017-05-16 [e0de5b7](../../commit/e0de5b7) - __(Artem Napolskih)__ feature: added class name to query cache key 
* 2017-05-16 [312585c](../../commit/312585c) - __(Artem Napolskih)__ feature: ability to specify query cache storage 

# v2.3.0

* 2017-05-04 [c259a55](../../commit/c259a55) - __(vadshalamov)__ fix: uninitialized constant ActionView::TemplateRenderer::ApplicationController 
* 2017-05-04 [6eab127](../../commit/6eab127) - __(vadshalamov)__ feature: add from_punycode method to UrlParser 
* 2017-05-04 [9958026](../../commit/9958026) - __(vadshalamov)__ feature: add normalize method to UrlParser 
* 2017-05-04 [0ba537c](../../commit/0ba537c) - __(vadshalamov)__ feature: add UrlParser from domains 
https://jira.railsc.ru/browse/USERS-350

# v2.2.0

* 2017-03-31 [22e906f](../../commit/22e906f) - __(Michail Merkushin)__ fix: Fix stack level too deep with autosave or validation 
https://jira.railsc.ru/browse/PC4-19237

* 2017-03-31 [fa89e06](../../commit/fa89e06) - __(Michail Merkushin)__ chore: Update drone config 

# v2.1.0

* 2017-02-09 [be63dab](../../commit/be63dab) - __(terentev)__ feat(action_view): Add cache_if, cache_unless helper methods 
https://jira.railsc.ru/browse/GOODS-331

# v2.0.1

* 2016-12-06 [181a6a3](../../commit/181a6a3) - __(Denis Korobicyn)__ fix: allow encode cache to ascii for ruby 2 also 
https://jira.railsc.ru/browse/PC4-18574

Беда таже самая

Сейчас покапал поглубже
Воспроизводится только на проде, только на опрделенных строках
Проблема в преобразованиях в readthis при дампе значений тут -
https://github.com/abak-press/readthis/blob/master/lib/readthis/entity.rb#L91-L94
тк сам Marchal дампит значение совместимое с utf-8

# v2.0.0

* 2016-10-28 [40cc86c](../../commit/40cc86c) - __(Zhidkov Denis)__ feat: drop support of rails 3.1, add patches for rails 3.2 

# v1.8.0

* 2016-10-25 [2d83ff5](../../commit/2d83ff5) - __(Zhidkov Denis)__ chore: add drone ci 

# v1.7.3

* 2016-10-01 [559cbf5](../../commit/559cbf5) - __(Dmitry Bochkarev)__ chore: порядок для запуска тестов 
* 2016-10-01 [4d9311f](../../commit/4d9311f) - __(Dmitry Bochkarev)__ fix(open-uri): не пытаемся парсить пустой урл(возникает при редиректах) 
https://jira.railsc.ru/browse/SERVICES-1411

# v1.7.2

* 2016-07-07 [6d702a5](../../commit/6d702a5) - __(Semyon Pupkov)__ fix: allow to include standalone module 
if require apress/utils/email_validation it raised error
NameError: uninitialized constant Apress::Utils

# v1.7.1

* 2016-06-21 [63b7ce4](../../commit/63b7ce4) - __(Denis Korobicyn)__ fix: gemspec dependency for readthis 

# v1.7.0

* 2016-06-20 [5c08597](../../commit/5c08597) - __(Denis Korobicyn)__ chore: remove gemfiles 
* 2016-06-20 [9a550df](../../commit/9a550df) - __(Denis Korobicyn)__ hack: force key encoding in readthis 
https://jira.railsc.ru/browse/PC4-17574

* 2016-05-29 [30e629f](../../commit/30e629f) - __(Konstantin Lazarev)__ fix(Active::Record): speed up STI models 
https://jira.railsc.ru/browse/CK-218

Метод [ActiveRecord::Base.compute_type](http://apidock.com/rails/v3.1.0/ActiveRecord/Base/compute_type/class),
используемый для вычисления класса модели, отрабатывает очень
медленно, в случае когда ему передается неполное наименование класса.
Происходит это от того, что метод пытается искать класс на всех уровнях
вложенности неймспейса, т.е. в случае:
```
Apress::Companies::Menus::CompanyMenus::Base.compute_type('VerticalMenu')
```
оригинальный метод будет искать класс среди:
```
Apress::Companies::Menus::CompanyMenus::Base::VerticalMenu
Apress::Companies::Menus::CompanyMenus::VerticalMenu
Apress::Companies::Menus::VerticalMenu
и т.д.
```
Данный ПР попытка ускорить работу метода путем исключения
"лишних" вариантов для поиска. Т.е. пропатченный метод в данном случае ищет только среди:
```
Apress::Companies::Menus::CompanyMenus::VerticalMenu
VerticalMenu
```

* 2016-05-23 [f310260](../../commit/f310260) - __(Sergey Kucher)__ fix: error on loading file with % character https://jira.railsc.ru/browse/PC4-17361 

# v1.6.0

* 2016-04-04 [5b7a1ed](../../commit/5b7a1ed) - __(Dmitry Bochkarev)__ fix(open-uri): парсинг доменов с _ и юникодом 
https://jira.railsc.ru/browse/SERVICES-1003
https://jira.railsc.ru/browse/BPC-7954

* 2016-01-28 [79445ab](../../commit/79445ab) - __(rolex08)__ fix: added tags for cached queries 
https://jira.railsc.ru/browse/SG-4292

# v1.5.0

* 2016-01-29 [11b8518](../../commit/11b8518) - __(Denis Korobitcin)__ feature(ar): pluck method backport 

# v1.4.0

* 2015-12-22 [02ab31a](../../commit/02ab31a) - __(Denis Korobitcin)__ feature(ar_caching) run_without_cache method 
https://jira.railsc.ru/browse/PC4-16194

# v1.3.0

* 2015-11-21 [cc3302f](../../commit/cc3302f) - __(Napolskih)__ feature: back to rails cache, tags removed, expires_in added for cached queries 
* 2015-11-21 [8367b25](../../commit/8367b25) - __(Napolskih)__ Revert "feature: cached queries on redis" 
This reverts commit 9eed8cc341a7937e0559178b49ce2e874c4e415f.

Conflicts:

	spec/spec_helper.rb

* 2015-11-18 [0924304](../../commit/0924304) - __(Artem Napolskih)__ specs: use transactional fixtures 

# v1.2.1

* 2015-11-03 [260dd2b](../../commit/260dd2b) - __(Michail Merkushin)__ fix: misstake in redis specs 

# v1.2.0

* 2015-11-01 [9eed8cc](../../commit/9eed8cc) - __(Michail Merkushin)__ feature: cached queries on redis 
Цель: уменьшение чтений из мемкеша.
Т.к. использовалось тегирование, то мы имели как минимум два запроса в мемкеш.
Также из мемкеша быстро вымываются данные.

# v1.1.0

* 2015-08-28 [c23a9b5](../../commit/c23a9b5) - __(Igor)__ fix: disallow numeric domain in email 

# v1.0.0

* 2015-07-18 [cc3074c](../../commit/cc3074c) - __(Sergey D)__ chore: update dependency string_tools 
* 2015-07-16 [429df1c](../../commit/429df1c) - __(Sergey D)__ feat: move StringTools to gem 
Closes SG-3689

# v0.3.3

* 2015-04-16 [792ee44](../../commit/792ee44) - __(Semyon Pupkov)__ fix(sanitize): allow all css properties in html 
https://jira.railsc.ru/browse/PC4-14886

# v0.3.2

* 2015-03-11 [6b5896c](../../commit/6b5896c) - __(Semyon Pupkov)__ Remove old changelog file 
* 2015-03-11 [2a6a13f](../../commit/2a6a13f) - __(Semyon Pupkov)__ Add missing dependencies 
* 2015-03-10 [1e513e5](../../commit/1e513e5) - __(Semyon Pupkov)__ Fix uninitialized constant 
Fix uninitialized constant Apress::Utils::Extensions::ActiveRecord::StatementInvalid

# v0.3.1

* 2015-03-02 [247e189](../../commit/247e189) - __(Korotaev Danil)__ chore(cleanup): remove dependency apress-gems 
* 2015-03-02 [3945f1b](../../commit/3945f1b) - __(Korotaev Danil)__ chore(all): appraisal for rails 3.1, 3.2 
+ Rails 3.2 without patching

# v0.3.0

* 2014-12-25 [0aabd7f](../../commit/0aabd7f) - __(Michael Sogomonyan)__ refactor(extensions): remove ActionDispatch::Routing::Mapper extension (goes to apress-application) 

# v0.2.0

* 2014-10-21 [3364290](../../commit/3364290) - __(bibendi)__ fix make file, remove appraisal 
* 2014-10-21 [a0c945b](../../commit/a0c945b) - __(bibendi)__ chore(readme): add dolly bage 
* 2014-10-21 [40a1a87](../../commit/40a1a87) - __(bibendi)__ chore(tests): remove shippable 
* 2014-10-21 [f2651d2](../../commit/f2651d2) - __(bibendi)__ chore(gemspec): add gem apress-gems 
* 2014-10-21 [41bf183](../../commit/41bf183) - __(bibendi)__ tests(email): add validate specs 

# v0.1.2

* 2014-08-22 [319fbd0](../../commit/319fbd0) - __(Simeon Movchan)__ check constraints presence in transaction with deferred constraints 

# v0.1.1

* 2014-07-29 [e3a9bea](../../commit/e3a9bea) - __(bibendi)__ fix postgres patches 

# v0.1.0

* 2014-07-28 [75dd7d5](../../commit/75dd7d5) - __(bibendi)__ move extensions from core 

# v0.0.2

* 2014-07-15 [3d724c6](../../commit/3d724c6) - __(bibendi)__ fix autoload lib path 
* 2014-07-15 [17f80cb](../../commit/17f80cb) - __(bibendi)__ fix upload gem path 
* 2014-07-15 [986f4d3](../../commit/986f4d3) - __(bibendi)__ fix gemspec 
* 2014-07-15 [866fba7](../../commit/866fba7) - __(bibendi)__ first commit 
