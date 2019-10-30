//
//  ViewController.m
//  CheckAirplane
//
//  Created by nico on 24.10.19.
//  Copyright © 2019 nico. All rights reserved.
//

#import "ViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <Network/Network.h>

@interface ViewController ()
@property (strong,nonatomic) nw_path_monitor_t pathMonitor;
@property (assign, nonatomic) bool isAirplaneMode;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pathMonitor = nw_path_monitor_create_with_type(nw_interface_type_cellular);
    nw_path_monitor_set_update_handler(self.pathMonitor, ^(nw_path_t  _Nonnull path) {
        NSLog(@"Network path changed");
        __block int interfaces = 0;
        nw_path_enumerate_interfaces(path, ^bool(nw_interface_t  _Nonnull interface) {
            const char * name = nw_interface_get_name(interface);
            NSLog(@"%s", name);
            interfaces++;
            return true;
        });
        if (interfaces == 0) {
            NSLog(@"Flight mode");
            self.isAirplaneMode = true;
        } else {
            self.isAirplaneMode = false;
        }
    });
    nw_path_monitor_start(self.pathMonitor);
}
- (IBAction)didTap:(id)sender {
    CTTelephonyNetworkInfo *info =[[CTTelephonyNetworkInfo alloc] init];
       NSString * radio = info.currentRadioAccessTechnology;
    NSLog(@"Radio: %@", radio);
}


- (IBAction)didTapNetwork:(id)sender {
    if (self.isAirplaneMode) {
        NSLog(@"AIRPLANE MODE");
    } else {
        NSLog(@"Connected");
    }
}


@end
