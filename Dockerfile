FROM ruby:2.1-onbuild

COPY bot.py .

CMD ["ruby","bot.py"]


