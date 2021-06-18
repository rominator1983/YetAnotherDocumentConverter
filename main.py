#!/usr/bin/python3
from concurrent import futures

import sys
sys.path.append("/")
import grpc

import yadc_pb2
import yadc_pb2_grpc

import uno,unohelper
from unoconv import Convertor

print("Hello World from yadc!")

#converter = Convertor()

class YetAnotherDocumentConverter(yadc_pb2_grpc.YetAnotherDocumentConverterServicer):

    def Convert(self, request, context):
        return yadc_pb2.ConvertReply(ouputData=[42,21])


server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
yadc_pb2_grpc.add_YetAnotherDocumentConverterServicer_to_server(YetAnotherDocumentConverter(), server)
server.add_insecure_port('[::]:50051')
server.start()
server.wait_for_termination()
