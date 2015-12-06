//
//  AddCommandViewController.m
//  Samaritan
//
//  Created by YASH on 06/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "AddCommandViewController.h"
#import "SamaritanData.h"
#import "Themes.h"
#import "AppDelegate.h"

@interface AddCommandViewController () <UITextFieldDelegate>
{
    
    NSString *command;
    NSString *tag;
    
    NSManagedObjectContext *managedObjectContext;
    NSFetchRequest *fetchRequest;
    
    Themes *currentTheme;
    
}

@end

@implementation AddCommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    
    NSFetchRequest *themesRequest = [NSFetchRequest fetchRequestWithEntityName:@"Themes"];
    [themesRequest setPredicate:[NSPredicate predicateWithFormat:@"themeName contains[cd] %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTheme"]]];
    NSArray *themes = [managedObjectContext executeFetchRequest:themesRequest error:nil];
    currentTheme = [themes firstObject];
    
    // fetched recent theme object, set it to text field and background
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.commandTextField)
    {
        [self.commandTextField becomeFirstResponder];
    }
    
    if (textField == self.tagTextField)
    {
        [self.tagTextField becomeFirstResponder];
    }
    
    return YES;
    
}
/*
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
    [self resignFirstResponder];
    
    if (textField == self.commandTextField)
    {
        command = self.commandTextField.text;
    }
    
    if (textField == self.tagTextField)
    {
        tag = self.tagTextField.text;
    }
    
    [self addCommandToSavedList];
    
}*/

- (void) addCommandToSavedList
{
    
    NSManagedObjectContext *context = [AppDelegate managedObjectContext];
    NSFetchRequest *fetchReq = [NSFetchRequest fetchRequestWithEntityName:@"SamaritanData"];
    NSError *err = nil;
    
    NSArray *dataArray = [[AppDelegate managedObjectContext] executeFetchRequest:fetchReq error:&err];
    
    BOOL commandAlreadyAdded = false;
    
    for (int i=0; i<dataArray.count; i++)
    {
        SamaritanData *dataCheck = [dataArray objectAtIndex:i];
        if ([dataCheck.tags isEqualToString:tag])
        {
            commandAlreadyAdded = true;
            break;
        }
    }
    
    if (!commandAlreadyAdded)
    {
        
        SamaritanData *data = [NSEntityDescription insertNewObjectForEntityForName:@"SamaritanData" inManagedObjectContext:context];
        data.displayString = command;
        data.tags = tag;
        
        NSLog(@"Favourites %@ %@", data.displayString, data.tags);
        
        if (![context save:&err])
        {
            
            NSLog(@"%@",err);
            
        }
        
    }
    
}

- (IBAction)doneButton:(UIButton *)sender
{
    
    [self resignFirstResponder];
    command = self.commandTextField.text;
    tag = self.tagTextField.text;
    [self addCommandToSavedList];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
