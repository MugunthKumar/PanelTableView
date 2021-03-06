    //
//  SamplePanelsViewController.m
//  SampleApp
//
//  Created by honcheng on 11/27/10.
//  Copyright 2010 honcheng. All rights reserved.
//

#import "SamplePanelsViewController.h"
#import "SamplePanelView.h"

@implementation SamplePanelsViewController
@synthesize panelsArray;

- (id)init
{
	if (self = [super init])
	{
		self.panelsArray = [NSMutableArray new];
		int numberOfPanels = 10;
		for (int i=0; i<numberOfPanels; i++)
		{
			NSMutableArray *rows = [NSMutableArray array];
			int numberOfRows = arc4random()%20;
			for (int j=0; j<numberOfRows; j++)
			{
				[rows addObject:@""];
			}
			[self.panelsArray addObject:rows];
		}
		
		
		[self addTemporaryUI];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.panelsArray release];
    [super dealloc];
}

#pragma mark temporary

// this method is used to insert add/delete button to show the demonstrate the add/delete function
- (void)addTemporaryUI
{
	UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(onAddButtonPressed:)];
	UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(onDeleteButtonPressed:)];
	
	[self.navigationItem setLeftBarButtonItem:deleteItem];
	[self.navigationItem setRightBarButtonItem:addItem];
	[deleteItem release];
	[addItem release];
}

- (void)onAddButtonPressed:(id)sender
{
	[self.panelsArray addObject:[NSMutableArray arrayWithObjects:@"",@"",@"",nil]];
	[self addPage];
}

- (void)onDeleteButtonPressed:(id)sender
{
	[self.panelsArray removeObjectAtIndex:currentPage];
	[self removeCurrentPage];
}

#pragma mark panel views delegate/datasource

/**
 *
 * - (NSInteger)numberOfPanels
 * set number of panels
 *
 */

- (NSInteger)numberOfPanels
{
	int numberOfPanels = [self.panelsArray count];
	[self setTitle:[NSString stringWithFormat:@"%i panel(s)", numberOfPanels]];
	
	return numberOfPanels;
}

/**
 *
 * - (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
 * set number of rows for different panel & section
 *
 */
- (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
	return [[self.panelsArray objectAtIndex:page] count];
}

/**
 *
 * - (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
 * use this method to change table view cells for different panel, section, and row
 *
 */
- (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
{
	static NSString *identity = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell*)[panelView.tableView dequeueReusableCellWithIdentifier:identity];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity] autorelease];
	}
	[[cell textLabel] setText:[NSString stringWithFormat:@"panel %i section %i row %i", indexPath.page, indexPath.section, indexPath.row+1]];
	return cell;
}

/**
 *
 * - (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
 * similar to - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(IndexPath *)indexPath
 *
 */
- (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
{
	
}

/**
 *
 * - (PanelView *)panelForPage:(NSInteger)page
 * use this method to change panel types
 * SamplePanelView should subclass PanelView
 *
 */
- (PanelView *)panelForPage:(NSInteger)page
{
	static NSString *identifier = @"SamplePanelView";
	SamplePanelView *panelView = (SamplePanelView*)[self dequeueReusablePageWithIdentifier:identifier];
	if (panelView == nil)
	{
		panelView = [[[SamplePanelView alloc] initWithIdentifier:identifier] autorelease];
	}
	return panelView;
}

@end
