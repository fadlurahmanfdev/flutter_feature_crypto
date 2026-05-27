fvm use 3.41.6 && fvm global 3.41.6  \
  && flutter clean && flutter pub get \
  && cd example && fvm use 3.41.6 && fvm global 3.41.6 \
  && flutter clean && flutter pub get \
  && cd ..