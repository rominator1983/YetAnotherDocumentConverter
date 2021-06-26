#!/usr/bin/python3
from concurrent import futures

import sys
import io

from subprocess import Popen, PIPE

import grpc
import yadc_pb2
import yadc_pb2_grpc
import time
from datetime import datetime

print("Starting grpc server")

class YetAnotherDocumentConverter(yadc_pb2_grpc.YetAnotherDocumentConverterServicer):

    def Convert(self, request, context):
        
        startTime = time.time()
        now = datetime.now()

        # TODO: is synchronization necessary? The documentation at https://docs.moodle.org/311/en/Universal_Office_Converter_(unoconv) states that
        #    this should only be necessary when calling unoconv directly without listener
        fo = open("foo.docx", "w+b")
        fo.write(request.inputData)
        fo.close()
        
        args = ['unoconv', '-f', 'pdf', 'foo.docx']
        
        if request.mode == 1:
          args.insert(3, "-eUseTaggedPDF=1")
          args.insert(4, "-eSelectPdfVersion=1")

        print("converting document @ " + now.strftime("%Y-%m-%d %H:%M:%SZ"))
        
        if request.mode == 0:
          print("- mode: PDF")
        else:        
          print("- mode: PDF/A")

        # TODO: implement error handling, return codes etc.
        process = Popen(args,stdout=PIPE, stderr=PIPE)
        stdout, stderr = process.communicate()

        fo = open("foo.pdf", "rb")
        output = fo.read()
        fo.close()

        executionTime = (time.time() - startTime)
        print("- rendering took: " + str(executionTime) + " seconds")
        print("")

        return yadc_pb2.ConvertReply(ouputData=output)


server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
yadc_pb2_grpc.add_YetAnotherDocumentConverterServicer_to_server(YetAnotherDocumentConverter(), server)
server.add_insecure_port('[::]:50051')
server.start()
server.wait_for_termination()
