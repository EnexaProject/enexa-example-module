FROM python:3.9
WORKDIR /app
ADD . ./
CMD ./module

# Add ENEXA utils.
COPY --from=enexa-utils:1 / /.
