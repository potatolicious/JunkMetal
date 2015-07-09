//
//  ViewController.m
//  iOSJunkMetal
//
//  Created by Jerry Wong on 7/8/15.
//  Copyright (c) 2015 Jerry Wong. All rights reserved.
//

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#import "ViewController.h"

@interface ViewController () <MTKViewDelegate>
@property (nonatomic, readonly) MTKView *metalView;
@property (nonatomic, readonly) id<MTLDevice> device;

@property (nonatomic) id<MTLBuffer> vertexBuffer;
@property (nonatomic) id<MTLLibrary> defaultLibrary;

@property (nonatomic) MTLRenderPipelineDescriptor *renderPipeline;
@property (nonatomic) id<MTLRenderPipelineState> pipelineState;

@property (nonatomic) id<MTLCommandQueue> commandQueue;

@end

@implementation ViewController

- (void)loadView {
    MTKView *view = [[MTKView alloc] init];
    view.clearColor = MTLClearColorMake(0.0, 1.0, 0.0, 1.0);
    view.preferredFramesPerSecond = 60;
    view.delegate = self;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (id<MTLDevice>)device {
    return [(MTKView *)self.view device];
}

- (MTKView *)metalView {
    return (MTKView *)self.view;
}

#pragma mark - Setup

- (void)setup {
    id<MTLDevice> device = self.device;
    float vertexData[] = {
        0.f, 1.f, 0.f,
        -1.f, -1.f, 0.f,
        1.f, -1.f, 0.f };
    NSUInteger vertexDataSize = sizeof(vertexData) * sizeof(vertexData[0]);
    self.vertexBuffer = [device newBufferWithBytes:&vertexData length:vertexDataSize options:0];

    self.defaultLibrary = [device newDefaultLibrary];
    id<MTLFunction> fragShader = [self.defaultLibrary newFunctionWithName:@"basic_fragment"];
    id<MTLFunction> vertShader = [self.defaultLibrary newFunctionWithName:@"basic_vertex"];

    MTLRenderPipelineDescriptor *pipeline = [[MTLRenderPipelineDescriptor alloc] init];
    pipeline.vertexFunction = vertShader;
    pipeline.fragmentFunction = fragShader;
    pipeline.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    self.renderPipeline = pipeline;

    NSError *pipelineError = nil;
    self.pipelineState = [device newRenderPipelineStateWithDescriptor:self.renderPipeline error:&pipelineError];
    if (pipelineError || !self.pipelineState) {
        NSLog(@"CRITICAL: Failed to create pipeline state: %@", pipelineError);
    }

    self.commandQueue = [device newCommandQueue];
}

#pragma mark - MTKViewDelegate

- (void)drawInView:(nonnull MTKView *)view {
    MTKView *metalView = self.metalView;
    MTLRenderPassDescriptor *renderPassDescriptor = metalView.currentRenderPassDescriptor;
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];

    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    if (renderEncoder) {
        [renderEncoder setRenderPipelineState:self.pipelineState];
        [renderEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3 instanceCount:1];
        [renderEncoder endEncoding];
    }

    [commandBuffer presentDrawable:metalView.currentDrawable];
    [commandBuffer commit];
}

- (void)view:(nonnull MTKView *)view willLayoutWithSize:(CGSize)size {

}

@end
