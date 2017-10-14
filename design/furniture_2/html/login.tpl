{* Страница входа пользователя *}

 <div class="page-title">   
<h1>Вход</h1>
</div>
{if $error}
<div class="message_error">
	{if $error == 'login_incorrect'}Неверный логин или пароль
	{elseif $error == 'user_disabled'}Ваш аккаунт еще не активирован.
	{else}{$error}{/if}
</div>
{/if}

<form class="form login_form" method="post">
	<label>Email</label>
	<input type="text" name="email" data-format="email" data-notice="Введите email" value="{$email|escape}" maxlength="255" />

    <label>Пароль (<a href="user/password_remind">напомнить</a>)</label>
    <input type="password" name="password" data-format=".+" data-notice="Введите пароль" value="" />
	<button type="submit" name="login" value="Войти" class="button"><span><span>Войти</span></span></button>
</form>