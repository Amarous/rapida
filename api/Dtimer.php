<?php

class dtimer
{

    public static $enabled = true;
    protected static $startTime;
    protected static $points = array();
    private static $color_array = array(1 => '#f00', 2 => '#ff0', 3 => '#fff');

    public static function reset()
    {
        self::$points = null;
        self::$startTime = null;
    }

    public static function log($message = '', $type = null)
    {
        //останавливаемся, если отключено
        if (self::$enabled !== true) {
            return false;
        }

        //тут будем заводить тип сообщения, если он не задан
        // 3 - информация, 2 - предупреждение, 1 - ошибка
        //по умолчанию сообщение будет информационным
        if (!isset($type)) {
            $type = '3';
        }

        if (self::$startTime === null)
            self::run();

        self::$points[] = array('message' => $message,
            'type' => $type, 'ram' => convert(memory_get_usage(true)), 'time' => microtime(true) - self::$startTime);
    }

    public static function run()
    {
        self::$startTime = microtime(true);
    }

    public static function show()
    {
        if (self::$enabled !== true) {
            return false;
        }

        $oldtime = 0;

        echo '
			<table style="table-layout: fixed; overflow-wrap: break-word; width: calc(100% - 20px); margin: 10px; !important; box-sizing: border-box; right:0; top:0; z-index:200; background:#fff !important">
			 <tr>
				<th style="width:2%; box-sizing: border-box; border: 1px dotted;">T.</th>
				<th style="width:75%; box-sizing: border-box; border: 1px dotted;">Message</th>
				<th style="width: 5.5%; box-sizing: border-box; border: 1px dotted;">RAM</th>
				<th style="width: 6.5%; box-sizing: border-box; border: 1px dotted;">Diff</th>
				<th style="width: 4.5%; box-sizing: border-box; border: 1px dotted;">Perc</th>
				<th style="width: 6.5%; box-sizing: border-box; border: 1px dotted;">Time</th>
			</tr>
		';
        $last = end(self::$points);
        //reset(self::$points);

        foreach (self::$points as $item) {

            $type = $item['type'];
            $color_type = self::$color_array[$item['type']];
            $message = $item['message'];
            $ram = $item['ram'];
            //время из последней записи
            $total = $last['time'];
            //разница во времени
            $diff = $item['time'] - $oldtime;
            //время из записи пишем для сравнения на следующем цикле
            $oldtime = $item['time'];

            if ($total != 0) {
                $perc = $diff / $total;
                $color = round(99 - $perc * 50, 3);
                $perc = round($perc * 100, 1);
            } else {
                $color = 255;
                $perc = 0;
            }
            //тут сконвертируем все величины времени
            //время из записи
            $time = convert_time($item['time']);
            $diff = convert_time($diff);
            echo "
				<tr>
					<td style='padding: 3px; box-sizing: border-box; border: 1px dotted;background: $color_type;'>{$type}</td>
					<td style='padding: 3px; box-sizing: border-box; border: 1px dotted;background: hsl( 0, 100%, $color% );'>$message</td>
					<td style='padding: 3px; box-sizing: border-box; border: 1px dotted;'>{$ram}</td>
					<td style='padding: 3px; box-sizing: border-box; border: 1px dotted;'>{$diff}</td>
					<td style='padding: 3px; box-sizing: border-box; border: 1px dotted;'>{$perc}</td>
					<td style='padding: 3px; box-sizing: border-box; border: 1px dotted;'>{$time}</td>
				</tr>
			";

        };
        echo "</table>\n";
        self::$points = array();
    }

    public static function show_console()
    {
        if (self::$enabled !== true) {
            return false;
        }

        $oldtime = 0;


        $last = end(self::$points);
        //reset(self::$points);

        foreach (self::$points as $item) {

            $type = $item['type'];
            $color_type = self::$color_array[$item['type']];
            $message = $item['message'];
            $ram = $item['ram'];
            //время из последней записи
            $total = $last['time'];
            //разница во времени
            $diff = $item['time'] - $oldtime;
            //время из записи пишем для сравнения на следующем цикле
            $oldtime = $item['time'];

            if ($total != 0) {
                $perc = $diff / $total;
                $color = round(99 - $perc * 50, 3);
                $perc = round($perc * 100, 1);
            } else {
                $color = 255;
                $perc = 0;
            }
            //тут сконвертируем все величины времени
            //время из записи
            $time = convert_time($item['time']);
            $diff = convert_time($diff);
            echo "****    $type    ram:{$ram}    diff:{$diff}    perc:{$perc}   time:{$time}    ***********\n";
            echo "$message\n";
            //echo "******************************************************\n";
        };
        self::$points = array();
    }


}
