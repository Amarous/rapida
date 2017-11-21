# RAPIDA Ecommerce CMS 
## SimplaCMS 2.3.8 fork
 
 
##IMPORTANT INFO
Для работы системы на сервере Nginx необходимо прописать следующую инструкцию в конфиг.
```
    location / {
        try_files $uri $uri /index.php$is_args$args;
    }
 ```
 
## ****************
## Changelog
## ****************
 
## =================
## v0.0.8.1.5 21.12.2017
## =================
### bugs:
- Исправлен класс api->pages в части возвращаемых значений, теперь тут тоже возвращаются массивы, а не объекты. Теперь исправлено теоретически везде, что заметно упрощает адаптацию шаблонов. Простой шаблон адаптируется за 2 клика. Файлы шаблона обрабатываются 5-6 однострочными perl скриптами, которые делают замену кусков кода по регулярным выражениям.


## =================
## v0.0.8.1.4 20.12.2017
## =================
### bugs:
- Устранение мелких недостатков то там, то здесь.
- Фраза для формирования соли, используемой при формировании пароля, сохранена только в переменной класса config->salt_word.
- Устранена ошибка api->design(40) при создании каталога для кеша смарти, mkdir теперь работает рекурсивно, что не вызывает ошибку при отсутствии каталога /compiled.
- Устранены ошибки при импорте/экспорте товаров.

### improvements:
- Добавлен в качестве метода по умолчанию более быстрый способ сохранения кеша. Всего доступно 3 способа: var_export, serialize, json_encode. В зависимости от ситуации, победитель по скорости меняется. Надо будет решить по какому принципу выбирать тот или иной способ.
- Доработал контроллеры, чтобы в случае невозможности парсинга адресной строки, в случае отсутствия конкретной страницы из адресной строки включалась страница 404. 
- Небольшие изменения в таблице s_currencies. Добавлен уникальный индекс на поле name. Запрос для изменения.
```
ALTER TABLE `s_currencies` ADD UNIQUE `name` (`name`) USING BTREE;
```

## =================
## v0.0.8.1.3 18.12.2017
## =================
### bugs:
- Исправлена ошибка в features/get_product_options().
- Исправлена ошибка на странице каталога товаров в админке (справа не появлялись бренды).
- Устранена ошибка в настройках свойств товаров, когда после импорта не появлялись категории.
- Устранена ошибка в таблице s_users. Некоторые версии субд не позволяют иметь в 1 таблице 2 поля с настройкой default current_timestamp. В связи с этим у поля last_login изменено значение по умолчанию. 
- В методе products->delete_image() добавлена проверка, что если удаляемое изображение имеет position 0, нужно удалить запись о нем из таблицы s_products. Там запись об изображении хранится для повышения быстродействия.
- Исправлена кривая ссылка в админке на иконке "Каталог". 
- Начата работа по рефакторингу контроллеров админки. Первый контроллер ProductAdmin.php
- Сделана дополнительная проверка имен свойств в методе features->add_feature() для исключения создания дублей одинаковых свойств. 
- Дополнительные проверки входных данных на методы products->add_product() products->update_product() для возможности упрощения контроллеров админки. 
- Устранение ошибки в методе brands->get_brands().
- Исправлены ошибки контроллера xhr.
- Устранена проблема поиска товаров русскими буквами. Использование русских символов для поиска по полю, в котором хранится ascii невозможно. Поэтому теперь для поиска в таблице артикулов транслитерируется ключевая фраза. Изменены методы get_products, get_products_ids, count_products.
- В связи с удалением поля name в таблице s_images, исправлены методы, работающие с этой таблицей.

## improvements:
- Перетряхнул класс variants. 
- Много изменений в типах полей таблиц. Везде где можно изменил DEFAULT NULL. Спасибо Black Hat.
- В таблице s_variants изменена кодировка поля sku на ascii, удалено поле attachment, добавлены поля: price1, price2, price3 для сохраненения разных цен товара, например оптовых и закупочных. Для продолжения
работы придется создавать БД заново. Для сохранения товаров проще всего сделать экспорт, потом создание БД заново, а затем импорт товаров. 
- Переписан контроллер productAdmin.php. Теперь все разделено по отдельным блокам, просто и логично. Количество кода незначительно выросло, теперь где-то ~400 строк кода, против ~350 в старом контроллере. Весь js очищен от Jquery, теперь ajax добавление связанных товаров работает через xhr контроллер, а не через отдельный php файл, как в симпле. Для полноценной работы по принципу SPA придется сделать api богаче по функциям. Буду добавлять их по мере необходимости. 

## =================
## v0.0.8.1.2 11.11.2017
## =================

### bugs:
- Исправлена работа страницы пользователя после авторизации.
- Исправлена работа обновления счетчика товаров в индикаторе корзины.
- Исправлена работа на странице восстановления пароля пользователя.
- Исправлена система восстановление пароля по почте.
- Исправлен пустой список брендов в карточке товара в админке.
- Устранены ошибки в simpla->categories
- Устранены ошибки при экспорте товаров
- Исправлен экспорт товаров.
- Мелкие доработки в xhr контроллере.
- Мелкие исправления в шаблонах админки и дизайна сайта в связи с переходом на изменение формата данных, предоставляемых api. (Simpla возвращала почти всега данные в виде простого числового массива внутри которого содержались объекты, если внутри элементов(свойств) объекта было несколько элементов, они тоже делались числовыми массивами). Очень неудобный для работы формат был полностью изменен. Теперь все только в массивах.
- Исправлено отображение опций товара в карточке товара.

### improvements:
- Запуск/возобновление сессии переведен из index.php в конструктор класса api/Simpla.php. Теперь стартовать сессиию отдельно не требуется, удобно для работы существующих сейчас отдельно ajax скриптах, которые запускаются не через index.php.
- Первые попытки использовать api системы через ajax. На странице корзины при удалении товара, производится запрос к api, в случае успеха удаляется соответствующая строка с товаром.
 
## =================
## v0.0.8.1.1 09.11.2017
## =================

### features:
- Система стала полностью совместима с сервером Nginx. Теперь Apache вообще не требуется. Удалось добиться за счет перевода большей части маршрутизации в саму систему, а не через файлы конфигурации веб-сервера. Simpla всю маршрутизацию делает только через .htaccess. Rapida же наооборот, всю маршрутизацию, в том числе в админ. панели, делает через главный контроллер. Файл конфигурации Nginx или для Apache содержит 2 инструкцию: 1. Все что не является реальным файлом на диске, направлять в /index.php. 2. Все что является реальным файлом на диске открывать непосредственно веб-сервером без участия php. Подобный подход позволяет не нагружать систему простыми запросами статических данных.
- В админку в раздел настройки выведен выключатель кеша.
- В админку в раздел настройки выведен переключатель способа записи кеша. Быстрый или экономный.
- В админку в раздел настройки выведен выключатель отладчика.
- Авторизация администратора переключена на общую авторизацию пользователей.
- Инсталер обучен создавать запись администратора по новой схеме (не через файл simpla/.passwd)
- Раздел настроек пользователя расширен возможностью установки статуса администратора. Для обновления версии БД без перезаписи необходимо выполнить следующие запросы: 
```
ALTER TABLE `s_users` ADD `admin` TINYINT(1) NULL DEFAULT '0' AFTER `enabled`, ADD INDEX `perm` (`admin`);
ALTER TABLE `s_users` ADD `last_login` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `last_ip`, ADD INDEX `last_login` (`last_login`);
ALTER TABLE `s_users` ADD `perm` VARCHAR(200) CHARACTER SET ascii COLLATE ascii_general_ci NULL DEFAULT '0' AFTER `enabled`;
ALTER TABLE `s_users` CHANGE `created` `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP();
ALTER TABLE `s_users` CHANGE `enabled` `enabled` TINYINT(1) NULL DEFAULT '0';
ALTER TABLE `s_users` DROP INDEX `email`, ADD UNIQUE `email` (`email`) USING BTREE;
ALTER TABLE `s_brands` CHANGE `url` `url` VARCHAR(255) CHARACTER SET ascii COLLATE ascii_general_ci NULL DEFAULT NULL;
```

### improvements:
- Эффективно работать с оптимизацией БД можно только на большой базе. Разбираюсь с индексами. Выясняется, что в некоторых случаях в БД отсутсвуют элементарные индексы, необходимость которых очевидна. Например, оказалось, что индекс поля created в таблице s_products отсутствует в Simpla. В результате простейший запрос: 
```SELECT id, name, brand_id FROM s_products WHERE visible = 1 ORDER BY created DESC LIMIT 0, 3```
выполняется несколько секунд! 
- Немного улучшил скорость импорта товаров за счет увеличение количества импортируемых товаров за 1 цикл скрипта simpla/ajax/import.php. Было 10 товаров, сделал 50 и добавил кеширование метода features->get_options_uniq(). 
- Добавил кеширование метода features->get_options_ids()
- Добавил 3 необязательный параметр при записи в дисковый кеш. Теперь можно использовать более быстрое сохранение и загрузку из кеша. set_cache_nosql($key, $data, $json). Параметр json - необязательный и по-умолчанию установлен в значение true. В этом случае кеш пишется в виде JSON строки с неэкранированными символами UNICODE, перед записью строка для экономии места преобразовывается в кодировку cp1251 (задается в конфиге). Сами функции json_encode/json_decode медленнее на 40%, чем serialize()/unserialize(), а еще конвертация. В общем если 3 параметр задан false, данные сохраняются в виде serialize строки без изменения кодировки. Таким образом экономится примерно 250мс, что из 500мс на загрузку всей страницы. Возможно выведу в опции, чтобы можно было не экономить место и добиться более высоких скоростей.
- Проведена ревизия фундаментальных методов класса db, которые отвечают за работу метода db->placehold(), удален неиспользуемый тип плейсхолдера # - константа. Остальным типам составлено описание, их стало так много, что вспомнить нужный бывает сложно.
- Заметно ускорен импорт товаров за счет сокращения выполнения дублирующихся операций по добавлению брендов, названий свойств. Сами значения свойств теперь добавляются в основном одновременно, одним запросом, а не по одному.
- Класс api/managers удален, теперь управления всеми пользователями, и покупателями и системными пользователями осуществляется через 1 класс api/users.

### bugs:
- Взамен jquery механизма импорта изображений в товар способом "перетаскивание" внедрен более простой механизм на чистом JS. Теперь работает без нареканий.
- Исправлена ошибка в магическом методе config->__get(), которая приводила к ошибке, если переменной в конфиге нет.
- Скорее не устранение бага, а усовершенствование, тем не менее пишу в баги потому что обнаружилось в ходе дебагинга функции импорта товаров. При импорте возврат от insert_id используется в дальнейшей работе, поскольку insert_id() давал 0, на ошибочных запросах, 0 использовался дальше, как нормальное значение. Метод db->insert_id() очень тупо возвращает то, что дает mysqli->insert_id, если запрос не удался - insert_id возвращает 0, что нельзя считать нормальным ответом. Теперь в случае ошибки, db->insert_id() возвращает false. Аналогичное поведение сделал и для db->num_rows().
- Исправление отсутствия отображения брендов на страницах каталога.
- Мелкие исправления то там, то здесь.

## =================
## v0.0.8.1 05.11.2017
## =================
### features:
- У значений и названий опций обрезаются пробелы по краям на уровне самих моделей update_option() add_feature() update_feature()
- Добавлена возможность импорта сжатых в формате gz файлов csv.
- Теперь экран импорта csv не заполняется импортируемыми товарами, только строка прогресса и отображение progress: x of x kb
- Добавлены новая функции классу dtimer, предназначенному для отладки. Теперь записываемому в журнал сообщению может быть установлен тип 1 - ошибка, 2 - предупреждение, 3 - сообщение. dtimer::log('error', 1). Если тип не задан, сообщению устанавливается тип 3. При отображении тип сообщения выводится в первой колонке и окрашивается в зависимости от типа, ошибка - красный, предупреждение - желтый, сообщение - белый. Теперь для отладки все ошибки будут выводится именно через dtimer, trigger_error больше использоваться не будет.
- Еще 1 функция классу dtimer, теперь вместе с сообщение записывается сколько оперативной памяти занимает скрипт на момент записи сообщения. Память отображатся с параметром real_usage, get_memory_usage(true)
- В api/Simpla.php добавлена функция умной конвертация единиц времени и единиц измерения данных. Теперь функции используюся в index.php и api->dtimer для понятного отображения секунд и мегабайт.
- В config.ini добавлена опция для выключения кеша. cache = false;
- Наконец внедрен мультифильтр опций товаров в каталоге. Теперь можно выбирать сразу несколько опций у 1 фильтра, при этом доступными у остальных фильтров будут только те свойства, которые действительно возможно выбрать.

### improvements:
- Уменьшено количество данных передаваемых для записи в очередь заданий по методу get_options. Вместо $ids, передаются array_values($ids), тем самым сокращая объем за счет длинных ключей массива..
- Избавляюсь от неудобного наследия Simpla. Постепенно изменяю контроллеры на работу с массивами, а не объектами, как изначально заложено в Simpla. get_products(), get_related_products(), get_images(), get_variants(), get_variant(), get_categories(), get_category() (почти все) теперь возвращают массив. Чтобы сэкономить память при создании дерева категорий активно использовалась рекурсия. Дело в том, что в php присвоение объектов происходит по ссылке по умолчанию. Простой тест:
```
<?php
$o = new stdClass();
$o->prop = 120;
$b = $o;
$b->prop = 100;
print_r($o);
```
При переходе на массив в категориях нужно было сохранить ссылочное присвоение. Это удалось сделать через оператор ссылки &.

### bugs:
- Для возможности долгой работы скриптов в .htaccess добавлены параметры php_value, в т.ч. max_execution_time 30000. 
- Устранен баг view/ProductsView.php. Были ошибки для товаров без изображений. 
- Устранен баг api/ControllerMaster.php при открытии страниц 1 уровня (/cart/ /blog/).
- Изменены права доступа к создаваемым файлам кеша на 755. Устранена баг, связанный с некорректным выставлением прав доступа на файл из переменной. chmod($file, 755) не тоже самое, что $var = '755' chmod($file, $var). Все дело в том, что при непосредственном указании параметра в функцию, параметр воспринимается как восьмеричное число. Если установление параметра происходит из переменной, число это будет или строка значения не имеет. Значение воспринимается как десятеричное число, которое конвертируется в восьмеричное. Для устранения этой проблемы в конструкторе класса cache, значение параметра default_chmod из config/config.ini сразу преобразуется из восьмеричного в десятеричное. Соответственно дальше при преобразовании в функциях mkdir chmod их фактическое значение не изменяется. 
- Устранен небольшой баг в coMaster->parse_uri_path(). Некорректный формат адресной строки приводил к ошибке. 
- Исправлена ошибка simpla/FeaturesAdmin.php. Изменение сразу нескольких свойств не работало.
- Устранена ошибка в методе features->get_options() при формировании keyhash.
- Устранены баги с открытием страницы регистрации пользователя /register и поиска товара /search
- Устранен баг в карточке товара в админке. Ошибки в опциях товара после сохранения изменений.

## =================
## v0.0.8 03.11.2017
## =================
### features:
 - Начата работа по новой структуре контроллеров (в терминах Simpla - модуль). На смену маршрутизации через файл .htaccess, создан главный контроллер (coMaster). Все новые контроллеры для порядка расположены в каталоге api и подключаются, аналогично всем классам из файла api/Simpla.php. Теперь все, что делает .htaccess - направляет все запросы файлу index.php, или в admin/index.php. Остальная работа выполняется главным контроллером. Принцип работы такой: Главный контроллер производит первичный разбор адресной строки. В случае, если в get части запроса есть параметр xhr, эстафета передается контроллеру XHR запросов (coXhr), во всех остальных случаях работу продолжает контроллер Simpla (coSimpla), который работает по принципу заложенному в Simpla (подключает контроллер view/IndexView.php). В связи с этими изменениями потребовалось изменение способа формирования ссылки плугином для Smarty resize (api/Design.php), Теперь ссылка на файл формируется сразу в get параметр url, а не как раньше прямым текстом в адресной строке.
 - Внедрены ЧПУ ссылки.
 - Для работы ЧПУ добавлено поле trans в таблицу s_options_uniq. Полю trans задана кодировка ascii, если в дальнейшем понадобится создание индекса по этому полю. Индекс с ascii меньше, чем c utf8. В настоящее время поле trans используется исключительно для отображения, поиск происходит только по полям id и md4.
#### Для обновления c версии 0.0.7.3 необходимо выполнить следующие 2 sql запроса:
 ```
 ALTER TABLE `s_options_uniq` ADD `trans` VARCHAR(512) CHARACTER SET ascii COLLATE ascii_general_ci NULL DEFAULT NULL AFTER `val`;
 
 ALTER TABLE `s_features` CHANGE `uri` `trans` VARCHAR(200) CHARACTER SET ascii COLLATE ascii_general_ci NULL DEFAULT NULL;
 ```
### bugs:
 - Исправлен баг в js скрипте simpla/design/html/product.tpl. Поскольку добавление картинок перетаскиванием работает только, когда товар уже создан - при создании товара поле для перетаскивания скрыто.
 - В админке ссылка "открыть товар на сайте" появляется сразу при открытии товара.
 - Исправлена ошибка view/ProductView.php. Дублировались варианты товара.
 - Изменен механизм поиска с заданным брендом и опциями, теперь брендов, как и опций можно выбрать сразу несколько. Пример части адресной строки с несколькими брендами сразу "/brand-citilux.ideal_lux.arte_lamp.st_luce/"

## =================
## v0.0.7.3 26.10.2017
## =================
 - Исправлен ajax/search_products.php. Подсказки в поисковой строке.
 - Исправлена ошибка products->add_image() в нумерации поля position в таблице s_images. Первое изображение должно иметь позицию 0
 - Изменена кодировка полей task в таблицах s_queue s_queue_full. Раньше там была ascii, сейчас utf8, иначе неправильно сохраняются задания в которых присутствуют русские буквы. Такие задания возникают при выполнении поисковых запросов.
 - В методе products->add_image() изменена логика, теперь при добавлении картинки с position 0, сразу вносится запись 
 в таблицу s_products в поле image. Раньше туда изображение попадало только во время манипуляций с картинками, например, в админке. Т.е. требовалось выполнение метода products->update_image()
 - В методе image->download_image() при скачивании изображение с position 0, сразу изменяется 2 таблицы s_image и s_products.
 - Добавлен доступ к api через xhr. Для удобства работы необходимые функции собраны в файле js/main.js. Непосредственно для работы с api нужна 1 функция apiAjax(). В целях безопасности доступ разрешен только к следующим классам:
 	$allowed['classes'] = array('products', 'brands', 'variants', 'features', 'image', 'cart', 'blog', 'comments');
 	$allowed['methods'] = array('get_products', 'get_product', 'get_variants', 'get_variant', 'get_features', 
 		'get_options', 'get_cart', 'get_brands', 'get_brand', 'get_comments', 'get_comment', 'get_images');
 - Небольшой баг в view/ProductsView.php и view/ProductView.php, при переборе вариантов товара, отсутствующего на складе. varints->get_variants() возвращал false, а потом производился перебор, что приводило к ошибке.
 - В метод db->dump_table() добавлен 3 необязательный аргумент $skip_create, если true - таблица не удаляется и не создается заново. Вместо drop table; create table - выполняется очистка таблицы truncate table. Метод используется при создании дампа.
 
 =================
## v0.0.7.2 25.10.2017
 =================
 - Исправлены ошибки в install.php Теперь инсталер может создавать отсутствующий config/db.ini, /simpla/.htaccess и simpla/.passwd
 - В связи с ошибками на dev сервере mysql, пострадала таблица начальной БД ./rapida.sql в прошлом релизе 0.0.7.1. Проблема устранена.
 - Исправлена ошибка при создании файлов кеша, при создании каталогов кеша неверно устанавливались права доступа, что приводило к ошибке на хостинге, теперь права устанавливаются 755. То есть для хозяина файла: чтение, запуск и выполнение, для остальных - чтение и запуск.
 - Исправлена ошибка в db->dump_table() 
 
## =================
## v0.0.7.1 24.10.2017
## =================
 - Исправлена некритическая ошибка в работе функции sys->download_all_images()
 - Исправлен simpla/ajax/export.php
 - Исправлен simpla/ajax/import.php
 - Исправлен variants->add_variant()
 - Исправлен variants->get_variant()
 - Удален каталог simpla/update Похоже раньше он предназначался для обновления версий.
 - Поправил все методы add_ на добавление чего либо в БД Теперь прежде чем сформировать запрос, отсеиваются пустые значения, СУБД сама ставит пропущенные поля в значения по умолчанию.
 - Добавлен фильтр "Без изображений" в разделе "Товары" админ. интерфейса.
 - Оптимизированы SQL запросы по фильтрам in_stock "Нет на складе" и discounted "Со скидкой"  в методах get_products() count_products()
 - Исправил метод db->dump_table() Теперь данные таблиц сохраняются правильно, bin значения преобразуются перед записью в hex, цифровые - без кавычек, прочие символьные - в кавычках с экранированием, все остальное просто в кавычках.
 - теперь настройки доступа к БД вынесены в отдельный файл config/db.ini, чтобы можно было обновлять систему через git. Необходимые изменения внесены в класс config
 - Удален старый генератор YML фида yandex.php.old
 - Устранена куча мелких ошибок в разных местах.
 - Исправлен фильтр in_stock в методах get_products count_products
 
## =================
## v0.0.7 22.10.2017
## =================
 - В раздел "Автоматизация" добавлен новый подраздел "Обслуживание системы". В нем собраны собраны операции с системой. Например: Очистка от лишних записей таблицы уникальных значений свойств товаров, во время работы системы эта таблица только пополняется новыми записями, какие-то из этих записей перестанут относится хотя бы к одному товару и их можно будет удалить из таблицы. При импорте товаров с изображениями с внешних источников в базу данных записывается ссылки этих изображений, но загрузка и сохранение происходят только при обращении к соответствующей картинке. Если товаров и картинок много, удобно загрузить сразу все изображения с внешних источников.
 - Создал новый класс System sys, в нем будут методы, которые используются редко и не предназначены для повседневной работы. В перспективе в этот класс переедут все такие методы, так мы разгрузим память от лишнего. 
 - Перенес метод sync_options() из features->sync_options() в features->sys->sync_options()
 
## =================
## v0.0.6.2 22.10.2017
## =================
 - Исправлен мелкий баг в файле simpla/OrdersAdmin.php от страницы со списком заказов.
 - Исправлен аналогичный баг в файле simpla/OrderAdmin.php от страницы выбранного заказа.
 
## =================
## v0.0.6.1 22.10.2017
## =================
 - Исправлен баг с загрузкой изображений с внешнего источника https://
 - Исправлен баг при создании товара через админку simpla/ProductAdmin.php 
 - Теперь система не только php7, но и MySql 5.7 совместимая.
 
## =================
## v0.0.6 19.10.2017
## =================
 - Очень значительное с технической точки зрения изменение. Изменена структура хранения свойств товаров. Теперь таблица s_options горизонтальная, а не вертикальная. В ней хранятся id товара, id свойств по столбцам, и значения id самих значений свойств. Значения свойств хранятся в отдельной таблице s_options_uniq. Тут записаны id, уникальные значения свойств товаров и md4 хеши значений в шестнадцатеричном формате bin(16). В классе db небольшие доработки внесены в методы results_array results_object, в классе features почти все методы переделаны под новую систему хранения свойств, добавлены новые методы для работы с более сложной структурой хранения. Переделаны также методы get_products и count_products из класса products, которые в основном используются для отображения товара и подстчета количества страниц в витрине товаров.
 - В связи с вышеназванными изменениями ссылки с выбранными фильтрами теперь выглядят не так: site.com/catalog/phones?1=gsm, а вот так: site.com/catalog/phones?1=123. Т.е. теперь вместо значений id.
 - При тестировании на Mysql 5.7 x64 обнаружилось, что теперь СУБД более строго подходит к значениям полей "по умолчанию", если поле demo записано без значения по умолчанию, то запрос вида INSERT table SET some = 23 не пройдет так как не указано значение для поля demo. Если поле some стоит как integer, то запрос UPDATE table SET some = 'text' не пройдет. В этой связи в огромном количестве мест пришлось вносить правки.
 - Немного улучшил работу модуля backup, раньше он создавал пустой каталог files/products (в нем система пишет миниатюры изображений), т.е. если у вас там .htaccess, то он в архив не попадал. Сейчас все файлы, которые начинаются с точки в архив попадают.
 - Во всех таблицах БД поставил DEFAULT NULL всем полям, которые могут быть пустыми.
 - Переделал simpla/ajax/export.php. Для нормальной работы в кодировке cp1251, раньше использовалась глючная схема изменением кодировки на соединении с БД через set names, а также с установкой set_locale. Все это убрал, и вставил iconv непосредственно перед записью в csv. Т.е. БД и PHP работают в UTF-8 и только запись на диск идет в cp1251.
 - Изменил метод db->dump_table(), теперь создаются не только данные, но и сама таблица.
  
## =================
## v0.0.5.3 15.10.2017
## =================
 - Отключил type hinting в тех функциях, где я уже успел его использовать. Теперь система работает не только на php7, но и на php5.
 
## =================
## v0.0.5.2 15.10.2017
## =================
 - После включения кеша, возник баг с открытием страниц товара в админке. Устранен. 
 
## =================
## v0.0.5.1 15.10.2017
## =================
 - В демонстрационную инсталяционную базу, которая создается на этапе установке системы, добавлены недостающие таблицы s_queue рабочая очередь задач. s_queue_full очередь задач для сохранения всех задач (не очищается автоматически) s_cache_integer для записи кеша цифровых значений.
 - Расположение файлового кеша по умолчанию изменено на cache в корневой директории системы
 - Раньше к имени директории, которая создается для кеша в конце дописывался дефис. securityKey = mysite становилось mysite- Теперь так больше не делает.
 
## =================
## v0.0.5 14.10.2017
## =================
 - Удалены лишние файлы simpla/LicenseAdmin.php и simpla/design/html/license.tpl
 - Удалены хвосты из файла simpla/design/html/index.tpl от интеграции с сервисом "простые звонки"
 - В целях удобства в классе config api/Config.php, который отвечает за работу с config.ini добавлена парсинг ini файла по секциям, теперь в классе создана публичная переменная $vars_sections, где настройки config.ini, распределены по секциям. Например, настройки кеша доступны $this->config->vars_sections['cache']
 - устранена ошибка в методе cache->encode() (убрал лишний аргумент, который не использовался $param)
 - настройки кеша выведены из api/Cache.php в config/config.ini 
 - Добавлено кеширование на диск по самой "тяжелой" функции системы features->get_options(). Пожалуй, кеширование этой функции - самый эффективный тюнинг скорости который можно сделать. Время загрузки не самого большого раздела сократилось до 170мс, без кеширования это время составляло около 4с.
 - Исправлен баг с работой функции products->get_products(). В начале функции из $filter (аргумент функции) удалялись лишние параметры. Было сделано для того, чтобы не захламлять кеш лишней информацией, но применительно к функции get_products удалялись $filter['page'] $filter['limit'] $filter['sort'], в результате при переключении пагинации в разделах сайта, товары не изменялись.
 - Исправлен баг с тем, что пользователь отображался авторизованным даже, когда авторизации не происходило. view/View.php
 - в файле шаблона cart.tpl исправлен баг, приводящий к ошибке, когда пользователь не авторизован. {if $user->discount} заменено на {if isset($user->discount)}. Аналогичный баг исправлен в view/CartView.php в части $coupon_request, теперь, если действующих купонов нет, все равно в шаблон передается переменная $coupon_request, но со значением false. Стараюсь устранять ошибки, которые раньше не отображались в связи с тем, что отображение ошибок типа notice было принудительно отключено. К сожалению не всегда удается обойтись без исправлений в шаблоне. Потенциально в других шаблонах возможно повторение этих ошибок.
 - Изменен метод features->get_features(), теперь он тоже, как и products->get_products() выдает объект сразу сгруппированный по id, соответствующие изменения внесены в другие места, где используется данный метод.
 
## =================
## v0.0.4 13.10.2017
## =================
 - Изменен метод db->results(string $field = null, string $group_field = null), теперь он работает аналогично, results_array с той разницей, что выдает массив с объектами внутри, а не массив с массивами внутри.
 = Добавлены файлы для выполнения очереди задач через cron. Выполнить задания из очереди cron/queue_exec.php. Посмотреть кол-во заданий в очереди cron/queue_count.php
 - Добавлен метод db->results_object(string $group_field = null) и изменен db->results_array(string $group_field = null). Работают сходным образом, с той разницей, что один выдает объект, а второй массив.
 - На метод products->get_products() прикручен дисковый кеш через методы cache->set_cache_nosql() cache->get_cache_nosql(). Кеш пишет на диск вывод метода products->get_products в виде json строки, а при чтении из кеша, преобразует json строку обратно в объект.
 - Мелким изменениям подверглись почти все файлы view/*.php и simpla/*.php в связи с использованием в методе products->get_products() нового метода db->results_object(). Пришлось изменить на новый метод в связи с тем, что дисковый кеш cache->set_cache_nosql() и cache->get_cache_nosql() используют для записи на диск функции json_decode json_encode, которые все пишут в объект. В результате при обратном преобразовании ф-цией json_decode данных из кеша с диска невозможно было восстановить, объекты, как объекты, а массивы, как массивы. Теперь все данные выводятся чистыми объектами.
 - Внесены изменения в методы products->get_products() и products->get_related_products(), теперь результат выполнения сразу группируется по id, соответствующие изменения внесены во всех случаях использования этих методов.
 - Изменен метод 'products->add_image()'. Оптимизирована работа. Кол-во запросов уменьшено до 2. Первый запрос определяет максимальную позицию изображений товара, 2 запрос добавляет новое изображение товара, сразу устанавливая позицию макс. знач. + 1.
 - Исправлена ошибка в simpla/ProductAdmin.php message_error добавляется в шаблон в любом случае, если ошибки нет - добавляется пустой message_error.
 - В файле simpla/index.php удалены указания на несуществующий дебагер, добавлен дебагер dtimer::show(), также как в файле /index.php
 - в методе request->url иправлена ошибка. Если при парсинге адресной строки через $url = parse_url($_SERVER['REQUEST_URI']) в полученном массиве нет элемента 'query' (часть после ?) $url['query'] - вылетала ошибка. Теперь добавлена предварительная проверка и ошибка больше не вылетает.
 - Удалена поддержка сервиса "Простые звонки"
 - Исправлена ошибка в view\ProductsView.php в части перечисления свойств товаров $features.
 - Устранены мелкие баги (Какие именно не помню)
## =================
## v0.0.3 13.10.2017
## =================
 - Добавлен метод в класс db public function results_array(string $field = null, string $group_field = null). Основная фишка - поле группировки, позволяет избежать двойной работы, когда сначала в методе db->results происходит перебор и запись строк в объект, а потом, например, во view/ProductsView.php происходит перебор: 
 		foreach($this->products->get_products($filter) as $p)
 			$products[$p->id] = $p;
 только, чтобы записать id товаров в виде ключей массива. $this->db->results_array(null, 'id') выдаст результат в виде массива с ключами из поля id.
 
## =================
## v0.0.2 12.10.2017
## =================
 - Добавлен отладчик ошибок dtimer в виде отдельной библиотеки api/Dtimer.php
 - В config.ini выведена опция dtimer_disabled для включения/выпключения отладчика. Когда опция true, вызовы метода отладчика на запись dtimer::log('info') и на вывод журнала отладчика dtimer::show() не срабатывает и не забивает память. dtimer_disabled = false включает запись событий в отладчик, а также включает отображение журнала. Вызов происходит из файла index.php. Отладчик записывает текстовую строку, а также время записи этой строки в журнал отладчика.
 - Добавлена библиотека кеширования cache api/Cache.php и библиотека очереди queue api/Queue.php. Пока используется для кеширования только одного метода product->count_products(). Механизм работы. При обращении к методу по входным параметрам в массиве $filter формируется md4 hash, который через метод cache->get_cache_integer() ищет в базе сохраненный кеш, если кеш не найден, происходит полное выполнение метода count_products(), в конце перед return происходит запись в кеш через метод cache->set_cache_integer(). Очередь заданий queue используется следующим образом. метод queue->addtask($keyhash, 'name', $task); пишет в очередь заданий задачу на выполнение count_products() без использования кеша с последующим обновлением результата в кеше. За счет этого кеш постоянно обновляется, но обновление происходит в отдельном процессе вызываемом планировщиком cron, т.е. для пользователя функция выполняется быстро, а сложная работа протекает на фоне.
 
