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

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView {
    self.view = [[MTKView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
