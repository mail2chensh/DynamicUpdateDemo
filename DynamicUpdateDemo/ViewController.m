//
//  ViewController.m
//  DynamicUpdateDemo
//
//  Created by Nix Wang on 15/11/8.
//  Copyright © 2015年 nixwang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)loadFramework:(id)sender {
    UIViewController *vc = [self loadFrameworkNamed:@"Module"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIViewController *)loadFrameworkNamed:(NSString *)bundleName {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = nil;
    if ([paths count] != 0) {
        documentDirectory = [paths objectAtIndex:0];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *bundlePath = [documentDirectory stringByAppendingPathComponent:[bundleName stringByAppendingString:@".framework"]];
    
    // Check if new bundle exists
    if (![manager fileExistsAtPath:bundlePath]) {
        NSLog(@"No framework update");
        bundlePath = [[NSBundle mainBundle]
                      pathForResource:bundleName ofType:@"framework"];
        
        // Check if default bundle exists
        if (![manager fileExistsAtPath:bundlePath]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Framework not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return nil;
        }
    }
    
    // Load bundle
    NSError *error = nil;
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:bundlePath];
    if (frameworkBundle && [frameworkBundle loadAndReturnError:&error]) {
        NSLog(@"Load framework successfully");
    }else {
        NSLog(@"Failed to load framework with err: %@",error);
        return nil;
    }
    
    // Load class
    Class PublicAPIClass = NSClassFromString(@"PublicAPI");
    if (!PublicAPIClass) {
        NSLog(@"Unable to load class");
        return nil;
    }
    
    NSObject *publicAPIObject = [PublicAPIClass new];
    return [publicAPIObject performSelector:@selector(mainViewController)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
