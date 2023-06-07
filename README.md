# Yet Another Document Converter
A docker container for converting Open XML documents (mainly DOCX files) to PDF, PDF/A.

This project is a result of a freaky friday that took place at RUBICON IT https://www.rubicon.eu.

Conversion is done with libre office using unoconv.

The docker container runs a GRPC server in python for a client to call the conversion. Interface see `yadc.proto`.

Start with: `docker run -p50051:50051 rominator/yadc`

The `docker-compose.yml` file is only for local development/testing.
Spin up a container locally via `run.ps1`
