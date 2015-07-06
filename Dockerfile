FROM ruby:2.1

RUN gem install cinch

COPY bot.py .

CMD ["ruby","bot.py"]


