require 'cinch'

$beerpref = {}

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = 'irc.freenode.org'
    c.channels = ["#hardorange"]
    c.nick = "OnTap"
  end

  on :channel, /^!drink (.+)/ do |m, nick|
  	if nick == bot.nick
  		m.reply "I don't drink beer."
  	elsif $beerpref.key?(nick)
		m.reply "I give #{nick} a #{$beerpref[nick]}."
	else
  		m.reply "I give #{nick} a beer."
  	end
  end

  on :channel, /^!setdrink (.+)/ do |m, beer|
  	$beerpref[m.user.nick] = beer
	m.reply "#{m.user.nick} likes #{beer}."
  end
end

bot.start
