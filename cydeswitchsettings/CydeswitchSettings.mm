@interface PluginsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSArray *plugins;
	NSMutableDictionary *settings;
	NSIndexPath *currentIndexPath;
}
-(NSArray *)listFileAtPath:(NSString *)path;
-(void)startPluginsDir;
@end

@implementation PluginsViewController
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [plugins count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *MyIdentifier = @"pluginCell";
	NSBundle *currentPlugin = nil;
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
	}
	if(indexPath.row == 0)
	{
		cell.textLabel.text = @"default";
	}else
	{
		//Get the plugin's display name.
		currentPlugin = [[NSBundle alloc] initWithPath:[NSString stringWithFormat:@"/Library/Cydeswitch/plugins/%@", [plugins objectAtIndex:indexPath.row - 1], nil]];
		cell.textLabel.text = [[currentPlugin localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
		if(cell.textLabel.text == nil)
		{
			//No localized bundle, so let's get the global display name...
			cell.textLabel.text = [[currentPlugin infoDictionary] objectForKey:@"CFBundleDisplayName"];
		} 
	}
	
	if([[[cell textLabel] text] isEqualToString:[settings objectForKey:@"pluginToExecute"]])
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		currentIndexPath = [indexPath retain];
	}else if(indexPath.row > 0 && [[plugins objectAtIndex:indexPath.row - 1] isEqualToString:[settings objectForKey:@"pluginToExecute"]])
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		currentIndexPath = [indexPath retain];
	}
	[currentPlugin release];
	return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Switch Action";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
	currentCell.accessoryType = UITableViewCellAccessoryNone;
	UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
	newCell.accessoryType = UITableViewCellAccessoryCheckmark;
	[currentIndexPath release];
	currentIndexPath = [indexPath retain];
	
	if(indexPath.row == 0)
	{
		[settings setObject:@"default" forKey:@"pluginToExecute"];
	}else
	{
		[settings setObject:[plugins objectAtIndex:indexPath.row - 1] forKey:@"pluginToExecute"];
	}
	[settings writeToFile:
		[NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(), @"com.AndyIbanez.Cydeswitch.plist"]
				atomically:YES];
}

-(NSArray *)listFileAtPath:(NSString *)path
{
	NSError *error = nil;
	NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
	if(error != nil)
    {
		directoryContent = [NSArray array];
    }
	return directoryContent;
}

-(void)startPluginsDir
{
	plugins = [[self listFileAtPath:@"/Library/Cydeswitch/plugins"] retain];
	settings = [[NSMutableDictionary dictionaryWithContentsOfFile:
									[NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(), @"com.AndyIbanez.Cydeswitch.plist"]] retain];
	if(settings == nil)
	{
		//If not found, let's create it for future use.
		settings = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"default", @"pluginToExecute", nil];
		[settings writeToFile:
					[NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(), @"com.AndyIbanez.Cydeswitch.plist"]
				atomically:YES];
	}
}

-(id)initWithStyle:(UITableViewStyle)style
{
	if((self = [super initWithStyle:style]))
	{
		[self startPluginsDir];
	}
	return self;
}

-(void)dealloc
{
	[plugins release];
	[settings release];
	[currentIndexPath release];
	[super dealloc];
}
@end

@class View;
@interface PSListController
{
	id _specifiers;
}
@property (nonatomic, retain) UINavigationItem *navigationItem;
@property (nonatomic, retain) UIBarButtonItem *rightBarButtonItem;
-(id)loadSpecifiersFromPlistName:(id)name target:(id)target;
-(id)view;
-(void)dealloc;
-(void)respring;
@end

@interface CydeswitchSettingsListController : PSListController
{
	PluginsViewController *tvc;
}
-(id)specifiers;
-(void)dealloc;
@end

@implementation CydeswitchSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		tvc = [[PluginsViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		tvc.tableView.frame = CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height);
		[self.view addSubview:tvc.tableView];
		UIBarButtonItem *respringBtn = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
		[[self navigationItem] setRightBarButtonItem:respringBtn animated:YES];
		[respringBtn release];
	}
	return _specifiers;
}

-(void)dealloc
{
	[tvc release];
	[super dealloc];
}

-(void)respring
{
	system("killall -9 SpringBoard");
}

@end

// vim:ft=objc
