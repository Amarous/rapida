<?php


session_start();
if (!isset($_SESSION['admin'])) {
	print "Please login as admin first! \n";
	die;
}
require_once (dirname(__FILE__) . '/../api/Simpla.php');
$si = new Simpla();

dtimer::$enabled = true;

$src = 'https://www.sevenlight.ru/yandex_full.xml.gz';
$src2 = 'https://xiaomi2buy.ru/files/products/12101.10x10.jpg';
$src5 = 'https://www.xiaomi2buy.ru/files/products/parketnaya-doska-befag-dub-natur-dunajskij-cena-2660-rub-mister-parket.800x600.jpg';
$src4 = 'https://www.xiaomi2buy.ru';
$src3 = 'https://sevenlight.ru/yandex.xml.gz';
$src7 = 'https://sevenlight.ru/yandex_400.xml.gz';
$src6 = 'http://sevenlight.ru/files/products/avrora_100771b.20x20.png';
$src8 = 'https://sevenlight.ru/files/products/avrora_100771b.40x40.png';
//~ var_dump(CURL_HTTP_VERSION_2TLS);

//~ for($i = 0; $i < 1; $i++){
//~ $size = $si->curl->remote_filesize($src);


	
//~ $options = array (CURLOPT_NOBODY => 1);
//~ $si->curl->curl_open($src5, $options);

$tmp = $si->curl->download($src8);

var_dump ($tmp);
//~ var_dump($si->curl->filecheck($src5, $tmp));


print "<PRE>";

//~ }

//~ print "$src3 filesize: ". $si->curl->remote_filesize($src3);
//~ $size3 = $si->image->remote_filesize($src2);


//~ $resume = $si->image->is_resumable($src2);
//~ $resume2 = $si->image->is_resumable($src3);



//~ print "\n $src filesize: $size";
//~ print "\n $src3 filesize: $size2";
//~ print "\n $src2 filesize: $size3";

//~ $si->image->curl_close();

//~ print "\n $src2 resumable: ". print_r($resume);
//~ print "\n $src3 resumable: ". print_r($resume2);

//~ $si->image->curl_open($src);
//~ $si->image->curl_exec();
//~ print_r($si->image->curl_headers);


dtimer::show();

