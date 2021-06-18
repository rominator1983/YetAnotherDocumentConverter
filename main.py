#!/usr/bin/python3
from concurrent import futures

import sys
import io
import grpc

import yadc_pb2
import yadc_pb2_grpc

import uno,unohelper

print("Hello World from yadc!")

class YetAnotherDocumentConverter(yadc_pb2_grpc.YetAnotherDocumentConverterServicer):

    def Convert(self, request, context):
        #print (request.mode)
        fo = open("foo.docx", "w+b")
        fo.write(request.inputData)
        fo.close()
        
        #converter = Convertor("-f pdf foo.docx")
        #converter.convert("foo.docx")

        fo = open("foo.pdf", "rb")
        output = fo.read()
        fo.close()
        return yadc_pb2.ConvertReply(ouputData=output)


server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
yadc_pb2_grpc.add_YetAnotherDocumentConverterServicer_to_server(YetAnotherDocumentConverter(), server)
server.add_insecure_port('[::]:50051')
server.start()
server.wait_for_termination()
