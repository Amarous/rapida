<?php
session_start();
if (isset($_SESSION['admin'])) {
	require_once (dirname(__FILE__) . '/../api/Simpla.php');
	$simpla = new Simpla();


	print "<PRE>";

	//~ $simpla->cache->set_cache_nosql('123', array(1,2,3,4,'пять'));
	//~ $var = $simpla->cache->get_cache_nosql('123');
	//~ print_r($var);



			$f = $simpla->features->get_features_ids(array('in_filter'=>1, 'return' => 
			array('key' => 'id', 'col' => 'id')
			)
			);
	var_dump($f);

	print "</PRE>";
	dtimer::show();
}
