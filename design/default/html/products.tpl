{* Список товаров *}

{* Канонический адрес страницы *}
{if isset($category, $brand) && $category && $brand}
{$condition = 1}
{$canonical="/catalog/{$category['url']}/{$brand['url']}" scope=parent}
{elseif isset($category) && $category}
{$condition = 2}
{$canonical="/catalog/{$category['url']}" scope=parent}
{elseif isset($brand) && $brand}
{$condition = 3}
{$canonical="/brands/{$brand['url']}" scope=parent}
{elseif isset($keyword) && $keyword}
{$condition = 4}
{$canonical="/products?keyword={$keyword|escape}" scope=parent}
{else}
{$condition = 5}
{$canonical="/products" scope=parent}
{/if}

<!-- Хлебные крошки /-->
<div id="path">
	<a href="/">Главная</a>
	{if isset($category) && $category}
	{foreach $category['path'] as $cat}
	→ <a href="catalog/{$cat['url']}">{$cat['name']|escape}</a>
	{/foreach}  
	{if isset($brand) && $brand}
	→ <a href="catalog/{$cat['url']}/{$brand['url']}">{$brand['name']|escape}</a>
	{/if}
	{elseif isset($brand) && $brand}
	→ <a href="brands/{$brand['url']}">{$brand['name']|escape}</a>
	{elseif isset($keyword) && $keyword}
	→ Поиск
	{/if}
</div>
<!-- Хлебные крошки #End /-->

{* Заголовок страницы *}
{if isset($keyword) && $keyword}
<h1>Поиск {$keyword|escape}</h1>
{elseif isset($page) && $page}
<h1>{$page['name']|escape}</h1>
{else}
<h1>{$category['name']|escape} {$brand['name']|escape}</h1>
{/if}


{* Описание страницы (если задана) *}
{$page['body']}

{if $current_page_num==1}
{* Описание категории *}
{$category['description']}
{/if}
{* Фильтр по брендам *}
{if isset($category['brands']) && $category['brands']}

<div id="brands">
	<a href="{chpu_url params=[brand=>[], page=>'' ]}" {if !$brand['id']}class="selected"{/if}>Все бренды</a>
	{foreach $category['brands'] as $b}
		{if $b['image']}
		<a data-brand="{$b['id']}" href="{chpu_url params=[brand=>[$b['url']], page=>'' ]}"><img src="{$config->brands_images_dir}{$b['image']}" alt="{$b['name']|escape}"></a>
		{else}
		<a data-brand="{$b['id']}" href="{chpu_url params=[brand=>[$b['url']], page=>'' ]}" {if $b['id'] == $brand['id']}class="selected"{/if}>{$b['name']|escape}</a>
		{/if}
	{/foreach}
</div>
{/if}

{if $current_page_num==1}
{* Описание бренда *}
{$brand['description']}
{/if}

{* Фильтр по свойствам *}
{if $features}
<table id="features">
	{*$filter['features']|@debug_print_var*}
	{foreach $features as $fid=>$f}
	<tr>
	<td class="feature_name" data-feature="{$f['id']}">
		{$f['name']}:
	</td>
	<td class="feature_values">
		<a href="{chpu_url params=[filter=>[$f['trans']=>[]], page=>'' ]}">Все</a>
		{foreach $options['full'][$f['id']]['vals'] as $k=>$o}
			{$otrans=$options['full'][$f['id']]['trans'][$k]}
			{if isset($options['filter'][$f['id']][$k])}
			<a {if isset($filter['features'][$f['id']][$k])}class="selected" {/if}
			href="{chpu_url params=[filter=>[$f['trans']=>[$otrans]], page=>'' ]}">{$o|escape}</a>
			{else}
			{$o|escape}
			{/if}
		{/foreach}
	</td>
	</tr>
	{/foreach}
</table>
{/if}


<!--Каталог товаров-->
{if $products}

{* Сортировка *}
{if $products|count>0}
<div class="sort">
	Сортировать по 
	<a {if $sort=='position'} class="selected"{/if} href="{url sort=position page=null}">умолчанию</a>
	<a {if $sort=='price'}    class="selected"{/if} href="{url sort=price page=null}">цене</a>
	<a {if $sort=='name'}     class="selected"{/if} href="{url sort=name page=null}">названию</a>
</div>
{/if}


{include file='pagination.tpl'}


<!-- Список товаров-->
<ul class="products">

	{foreach $products as $product}
			{$pid = $product['id']}
			{$url = $product['url']}
			{$name = $product['name']}
			{$image = $product['image']}
			{$image_id = $product['image_id']}
	<!-- Товар-->
	<li class="product">
		
		<!-- Фото товара -->
		{if $image}
		<div class="image">
			<a href="products/{$url}"><img src="{$image|resize:products:$image_id:200:200}" alt="{$name|escape}"/></a>
		</div>
		{/if}
		<!-- Фото товара (The End) -->

		<div class="product_info">
		<!-- Название товара -->
		<h3 class="{if $product['featured']}featured{/if}"><a data-product="{$pid}" href="products/{$url}">{$name|escape}</a></h3>
		<!-- Название товара (The End) -->

		<!-- Описание товара -->
		<div class="annotation">{$product['annotation']}</div>
		<!-- Описание товара (The End) -->
		
		{if $product['variants']|count > 0}
		<!-- Выбор варианта товара -->
		<form class="variants" action="/cart">
			<table>
			{foreach $product['variants'] as $v}
			<tr class="variant">
				<td>
					<input id="variants_{$v['id']}" name="variant" value="{$v['id']}" type="radio" class="variant_radiobutton" {if $v@first}checked{/if} {if $product['variants']|count<2}style="display:none;"{/if}/>
				</td>
				<td>
					{if $v['name']}<label class="variant_name" for="variants_{$v['id']}">{$v['name']}</label>{/if}
				</td>
				<td>
					{if $v['old_price'] > 0}<span class="old_price">{$v['old_price']|convert}</span>{/if}
					<span class="price">{$v['price']|convert} <span class="currency">{$currency['sign']|escape}</span></span>
				</td>
			</tr>
			{/foreach}
			</table>
			<input type="submit" class="button" value="в корзину" data-result-text="добавлено"/>
		</form>
		<!-- Выбор варианта товара (The End) -->
		{else}
			Нет в наличии
		{/if}

		</div>
		
	</li>
	<!-- Товар (The End)-->
	{/foreach}
			
</ul>

{include file='pagination.tpl'}	
<!-- Список товаров (The End)-->

{else}
Товары не найдены
{/if}
<!--Каталог товаров (The End)-->
