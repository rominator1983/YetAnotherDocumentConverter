# Yet Another Document Converter
A docker container for converting Open XML documents to PDF, PDF/A.

Conversion is done with libre office and unoconv.

The docker container runs a GRPC server to call the conversion.

Start with: `docker run -p50051:50051 rominator/yadc`
The docker-compose.yml file is only for local development/testing.

This project is a result of a freaky friday that took place at RUBICON IT https://www.rubicon.eu/.
