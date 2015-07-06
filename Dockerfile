FROM ruby:2.1-onbuild

RUN gem install cinch

COPY bot.py bot.py

CMD ["ruby","bot.py"]


