{* Список товаров *}

<div class="breadcrumb">
	<a href="/">Главная</a>
	{if $category}
	{foreach from=$category->path item=cat}
	&raquo; <a href="catalog/{$cat->url}">{$cat->name|escape}</a>
	{/foreach}  
	{if $brand}
	&raquo; <a href="catalog/{$cat->url}/{$brand->url}">{$brand->name|escape}</a>
	{/if}
	{elseif $brand}
	&raquo; <a href="brands/{$brand->url}">{$brand->name|escape}</a>
	{elseif $keyword}
	&raquo; Поиск
	{/if}

      </div>
{* Заголовок страницы *}
{if $keyword}
<h1>Поиск {$keyword|escape}</h1>
{elseif $page}
<h1>{$page->name|escape}</h1>
{else}
<h1>{$category->name|escape} {$brand->name|escape} {$keyword|escape}</h1>
{/if}

    <div class="category-info">
            <div class="std">
{* Описание страницы (если задана) *}
{$page->body}

{if $current_page_num==1}
{* Описание категории *}
{$category->description}
{/if}

{* Фильтр по брендам *}
{if $category->brands}
<div id="brands">
	<a href="catalog/{$category->url}" {if !$brand->id}class="selected"{/if}>Все бренды</a>
	{foreach name=brands item=b from=$category->brands}
		{if $b->image}
		<a data-brand="{$b->id}" href="catalog/{$category->url}/{$b->url}"><img src="{$config->brands_images_dir}{$b->image}" alt="{$b->name|escape}"></a>
		{else}
		<a data-brand="{$b->id}" href="catalog/{$category->url}/{$b->url}" {if $b->id == $brand->id}class="selected"{/if}>{$b->name|escape}</a>
		{/if}
	{/foreach}
</div>
{/if}

{* Описание бренда *}
{$brand->description}

{* Фильтр по свойствам *}
{if $features}
<table id="features">
	{foreach $features as $f}
	<tr>
	<td class="feature_name" data-feature="{$f->id}">
		{$f->name}:
	</td>
	<td class="feature_values">
		<a href="{url params=[$f->id=>null, page=>null]}" {if !$smarty.get.$f@key}class="selected"{/if}>Все</a>
		{foreach $f->options as $o}
		<a href="{url params=[$f->id=>$o->value, page=>null]}" {if $smarty.get.$f@key == $o->value}class="selected"{/if}>{$o->value|escape}</a>
		{/foreach}
	</td>
	</tr>
	{/foreach}
</table>
{/if}

</div>
      </div>
<!--Каталог товаров-->
{if $products}

{* Сортировка *}
{if $products|count>1}
     
        <div class="product-filter">
        <div class="sort"><b>Сортировать по :</b>
      <select onchange="location = this.value;">
		<option value="{url sort=position page=null}"{if $sort=='position'} selected{/if}>умолчанию</option>
		<option value="{url sort=price page=null}"{if $sort=='price'} selected{/if}>цене</option>
		<option value="{url sort=name page=null}"{if $sort=='name'} selected{/if}>названию</option>
      </select>
    </div>

    <div class="display"><b>Показывать :</b> <a id="list_a" onclick="display('list');">Список</a> <div id="grid_a">Таблица</div></div>

  </div>
{/if}
  <div class="product-list">
    <ul>
    {foreach $products as $product}
    		<form class="variants" action="/cart">	
    <li class="product {if ($product@iteration+2)%3 == 0}first-in-line{elseif $product@iteration%3 == 0}last-in-line{/if}">
            <div class="image">
		{if $product->image}
			<a href="products/{$product->url}" title="{$product->name|escape}">
			<img src="{$product->image->filename|resize:200:200}" alt="{$product->name|escape}"  />
			</a>
		{/if}
            </div>
            <div class="name">
           <a data-product="{$product->id}" href="products/{$product->url}" title="{$product->name|escape}">
            {$product->name|escape}
            </a>
            </div>
      <div class="description">
	{$product->annotation}
		</div>

		      {if $product->variants|count > 0}	
            <div class="price">
                <span class="price-new">{$product->variant->price|convert}</span> {$currency->sign|escape}                        
                <span class="price-old">
				{if $product->variant->compare_price > 0}
				{$product->variant->compare_price|convert}
				{/if}
				</span>
              </div>
        
            <div class="rating">
			<!-- Выбор варианта товара -->
			{* Не показывать выбор варианта, если он один и без названия *}
			<select name="variant" {if $product->variants|count==1  && !$product->variant->name}style='display:none;'{/if}>
				{foreach $product->variants as $v}
				<option value="{$v->id}" {if $v->compare_price > 0}compare_price="{$v->compare_price|convert}"{/if} price="{$v->price|convert}">
				{$v->name}
				</option>
				{/foreach}
			</select>
			<!-- Выбор варианта товара (The End) --> 
			          
            </div>
 <div class="cart">
 <span class="button">
 <input type="submit"  value="в корзину" data-result-text="добавлено"/>
 </span>
 </div>
		{else}
		
			<div class="price">Нет в наличии</div>
		<div class="rating">	
		</div>
		<div class="cart">
		</div>	
		{/if}
		
    </li>
    </form>
    {/foreach}
             </ul>
  </div>
  
{include file='pagination.tpl'}
      </div>
<script type="text/javascript">
<!--

view = $.totalStorage('display');

if (view) {
	display(view);
} else {
	display('list');
}
//--></script> 
<script type="text/javascript">
{literal}
		(function($){$.fn.equalHeights=function(minHeight,maxHeight){tallest=(minHeight)?minHeight:0;this.each(function(){if($(this).height()>tallest){tallest=$(this).height()}});if((maxHeight)&&tallest>maxHeight)tallest=maxHeight;return this.each(function(){$(this).height(tallest)})}})(jQuery)
	$(window).load(function(){
		if($(".cat-height").length){
		$(".cat-height").equalHeights()}
	})
$(function() {

	// Выбор вариантов
	$('select[name=variant]').change(function() {
		price = $(this).find('option:selected').attr('price');
		compare_price = '';
		if(typeof $(this).find('option:selected').attr('compare_price') == 'string')
			compare_price = $(this).find('option:selected').attr('compare_price');
		$(this).find('option:selected').attr('compare_price');
		$(this).closest('form').find('span.price-new').html(price);
		$(this).closest('form').find('span.price-old').html(compare_price);
		return false;		
	});
		
});	
{/literal}	
</script>

{else}
Товары не найдены
{/if}	
<!--Каталог товаров (The End)-->