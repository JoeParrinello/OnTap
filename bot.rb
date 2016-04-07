require 'cinch'

$beerpref = {}

$default_drink = "beer"

# emulate /me behavior
def action_string(string)
  "\001ACTION #{string}\001"
end

def give_drink(m, nick, drink)
    m.reply action_string(" gives #{nick} a #{drink}.")
end

def give_user_preferred_drink(m, nick)
    if $beerpref.key?(nick)
        give_drink(m, nick, $beerpref[nick])
    else
        give_drink(m, nick, $default_drink)
    end
end

bot = Cinch::Bot.new do
    configure do |c|
        raise "Environment Variable for Server not Set." unless ENV.has_key?("server")
        raise "Environment Variable for Channel not Set." unless ENV.has_key?("channel")
        c.server   = ENV['server']
        c.channels = [ENV['channel']]
        c.nick = "BraunTap"
    end

    on :channel, /^!drink (.+)/ do |m, nick|
        nick = nick.strip # some irc clients add whitespace when autocompleting nickname.
        if m.channel.has_user?(nick)
            if nick == bot.nick
                m.reply "I don't drink beer."
            else
                give_user_preferred_drink(m, nick)
            end
        else
            m.reply "#{nick} isn't online to receive a drink."
        end
    end

    on :channel, /^!drink$/ do |m|
        give_user_preferred_drink(m, m.user.nick)
    end

    on :channel, /^!drinks$/ do |m|
        m.reply "A round of drinks on #{m.user.nick}"
        m.channel.users.each  { |user, modes|
            if user.nick != bot.nick
                give_user_preferred_drink(m, user.nick)
            end
        }
    end

    on :channel, /^!drinks (.+)$/ do |m, drink|
        m.reply "A round of #{drink} on #{m.user.nick}"
        m.channel.users.each  { |nick, modes|
            if nick != bot.nick
                give_drink(m, nick, drink)
            end
        }
    end

    on :channel, /^!setdrink (.+)/ do |m, beer|
        $beerpref[m.user.nick] = beer
        m.reply "#{m.user.nick} likes #{beer}."
    end

    on :channel, /^!help/ do |m|
        m.reply "help: Help Commands!"
        m.reply "help: !drink <nick> gives a drink"
        m.reply "help: !setdrink <drink name> sets your preferred drink"
        m.reply "help: !drink gives yourself a drink, you alcoholic"
        m.reply "help: !drinks gives everyone their preferred drink"
        m.reply "help: !drinks <drink> gives everyone a <drink>"

    end
end

bot.start
