RAPIDA 0.0.3 ecommerce CMS SimplaCMS 2.3.8 fork

****************
Changelog
****************



=================
v0.0.3 13.10.2017
=================
- Добавлен метод в класс db public function results_array(string $field = null, string $group_field = null). Основная фишка - поле группировки, позволяет избежать двойной работы, когда сначала в методе db->results происходит перебор и запись строк в объект, а потом, например, во view/ProductsView.php происходит перебор: 
		foreach($this->products->get_products($filter) as $p)
			$products[$p->id] = $p;
только, чтобы записать id товаров в виде ключей массива. $this->db->results_array(null, 'id') выдаст результат в виде массива с ключами из поля id.

=================
v0.0.2 12.10.2017
=================
- Добавлен отладчик ошибок dtimer в виде отдельной библиотеки api/Dtimer.php
- В config.ini выведена опция dtimer_disabled для включения/выпключения отладчика. Когда опция true, вызовы метода отладчика на запись dtimer::log('info') и на вывод журнала отладчика dtimer::show() не срабатывает и не забивает память. dtimer_disabled = false включает запись событий в отладчик, а также включает отображение журнала. Вызов происходит из файла index.php. Отладчик записывает текстовую строку, а также время записи этой строки в журнал отладчика.
- Добавлена библиотека кеширования cache api/Cache.php и библиотека очереди queue api/Queue.php. Пока используется для кеширования только одного метода product->count_products(). Механизм работы. При обращении к методу по входным параметрам в массиве $filter формируется md4 hash, который через метод cache->get_cache_integer() ищет в базе сохраненный кеш, если кеш не найден, происходит полное выполнение метода count_products(), в конце перед return происходит запись в кеш через метод cache->set_cache_integer(). Очередь заданий queue используется следующим образом. метод queue->addtask($keyhash, 'name', $task); пишет в очередь заданий задачу на выполнение count_products() без использования кеша с последующим обновлением результата в кеше. За счет этого кеш постоянно обновляется, но обновление происходит в отдельном процессе вызываемом планировщиком cron, т.е. для пользователя функция выполняется быстро, а сложная работа протекает на фоне.

