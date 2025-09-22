package com.example.grpc_server;

import com.example.grpc.GreetRequest;
import com.example.grpc.GreetResponse;
import com.example.grpc.GreetingServiceGrpc;
import io.grpc.stub.StreamObserver;
import org.springframework.grpc.server.service.GrpcService;

@GrpcService
public class GreetingServiceImpl extends GreetingServiceGrpc.GreetingServiceImplBase {

    @Override
    public void greet(GreetRequest request, StreamObserver<GreetResponse> responseObserver) {
        String message = "Hola, " + request.getName() + " desde el servidor gRPC!";
        GreetResponse response = GreetResponse.newBuilder()
                .setMessage(message)
                .build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }
}
