import telebot

bot = telebot.TeleBot("702649113:AAF75o17J8a4koVnpBleg6cd6Ep7kq01J_g")

@bot.message_handler(func=lambda m: True)
def echo_all(message):
	bot.reply_to(message, message.text)

bot.polling(none_stop=True, timeout=123)
