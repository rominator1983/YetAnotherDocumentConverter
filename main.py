#!/usr/bin/python3
from concurrent import futures

import sys
import io

from subprocess import Popen, PIPE

import grpc
import yadc_pb2
import yadc_pb2_grpc

print("Starting grpc server")

class YetAnotherDocumentConverter(yadc_pb2_grpc.YetAnotherDocumentConverterServicer):

    def Convert(self, request, context):
        
        fo = open("foo.docx", "w+b")
        fo.write(request.inputData)
        fo.close()
        
        process = Popen(['unoconv', '-f', 'pdf', 'foo.docx'], stdout=PIPE, stderr=PIPE)
        stdout, stderr = process.communicate()

        fo = open("foo.pdf", "rb")
        output = fo.read()
        fo.close()

        return yadc_pb2.ConvertReply(ouputData=output)


server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
yadc_pb2_grpc.add_YetAnotherDocumentConverterServicer_to_server(YetAnotherDocumentConverter(), server)
server.add_insecure_port('[::]:50051')
server.start()
server.wait_for_termination()
