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
		m.reply "#{m.user.nick} gives #{nick} a #{$beerpref[nick]}."
	else
  		m.reply "#{m.user.nick} gives #{nick} a beer."
  	end
  end

  on :channel, /^!drink/ do |m|
	if $beerpref.key?(m.user.nick)
		m.reply "I give #{m.user.nick} a #{beerpref[m.user.nick]}."
	else
		m.reply "I give #{m.user.nick} a beer."
	end
  end


  on :channel, /^!setdrink (.+)/ do |m, beer|
  	$beerpref[m.user.nick] = beer
	m.reply "#{m.user.nick} likes #{beer}."
  end

  on :channel, /^!help/ do |m|
	m.reply "help: Help Commands!"
	m.reply "help: !drink <nick> gives a drink"
	m.reply "help: !setdrink <drink name> sets your prefered drink"
	m.reply "help: !drink gives yourself a drink, you alcoholic"
  end
end

bot.start
