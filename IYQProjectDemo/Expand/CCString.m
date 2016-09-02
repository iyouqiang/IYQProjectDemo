#import "CCString.h"
#import <UIKit/UIKit.h>
@implementation NSString (CCString)

#pragma mark UI

- (void)show_alert_title:(NSString*)title message:(NSString*)msg
{
	[self show_alert_title:title message:msg delegate:nil];
}

- (void)show_alert_title:(NSString*)title message:(NSString*)msg delegate:(id)an_obj
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg
		delegate:an_obj cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
}

- (void)show_alert_message:(NSString*)msg
{
	[self show_alert_title:self message:msg];
}

- (void)show_alert_title:(NSString*)title
{
	[self show_alert_title:title message:self];
}

- (void)show_alert_message:(NSString*)msg delegate:(id)an_obj
{
	[self show_alert_title:self message:msg delegate:an_obj];
}

- (void)show_alert_title:(NSString*)title delegate:(id)an_obj
{
	[self show_alert_title:title message:self delegate:an_obj];
}

#pragma mark Application

- (BOOL)go_url
{
	NSString* s = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:s]];
}

- (BOOL)can_go_url
{
	NSString* s = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:s]];
}

#pragma mark File

- (NSString*)filename_document
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) 
		objectAtIndex:0] stringByAppendingPathComponent:self];
}

- (NSString*)filename_bundle
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:self];
}

- (BOOL)is_directory
{
	BOOL	b;

    NSFileManager *file_manager = [NSFileManager defaultManager];
	[file_manager fileExistsAtPath:[self filename_document] isDirectory:&b];

	return b;
}

- (BOOL)file_exists
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[self filename_document]];
}

- (BOOL)file_exists_bundle
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[self filename_bundle]];
}

- (BOOL)create_dir
{
	NSFileManager*	manager = [NSFileManager defaultManager];
	return [manager createDirectoryAtPath:[self filename_document] withIntermediateDirectories:YES attributes:nil error:nil];
}

- (BOOL)file_backup
{
	NSError* error;

	if ([[self filename_document] file_exists])
		return NO;
	else
	{
		[[NSFileManager defaultManager] 
			//linkItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]
			  copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self]
					  toPath:[self filename_document]
					   error:&error];
			//handler:nil];
		if (error != nil)
		{
			NSLog(@"ERROR backup: %@", error.localizedDescription);
			return NO;
		}
		else
			return YES;
	}

	return NO;
}

- (BOOL)file_backup_to:(NSString*)dest
{
	return [[NSString stringWithFormat:@"%@/%@", dest, self] file_backup];
}

#pragma mark URL

- (NSString*)url_to_filename
{
	NSString*	s = self;

	s = [s stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
	s = [s stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];

	return s;
}

- (NSString*)to_url
{
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark String

- (BOOL)has_substring:(NSString*)sub
{
	NSRange range = [self rangeOfString:sub];
	if ((range.location == NSNotFound) && (range.length == 0))
		return NO;

	return YES;
}

- (NSString*)string_without:(NSString*)head to:(NSString*)tail
{
	return [self string_without:head to:tail except:nil];
}

- (NSString*)string_without:(NSString*)head to:(NSString*)tail except:(NSArray*)exceptions
{
	int			i;
	BOOL		finding_head = YES;
	NSRange		range_source, range_dest;
	NSString*	s = [NSString stringWithString:self];
	NSString*	sub = @"";

	while (sub != nil)
	{
		sub = nil; 
		for (i = 0; i < s.length; i++)
		{
			range_source.location = i;
			if (finding_head)
			{
				range_source.length = head.length;
				if (range_source.length + i > s.length)
					break;
				if ([[s substringWithRange:range_source] isEqualToString:head])
				{
					//	NSLog(@"found head at: %i", i);
					range_dest.location = i;
					finding_head = NO;
				}
			}
			else
			{
				range_source.length = tail.length;
				if (range_source.length + i > s.length)
					break;
				if ([[s substringWithRange:range_source] isEqualToString:tail])
				{
					//	NSLog(@"found tail at: %i", i);
					range_dest.length = i - range_dest.location + tail.length;
					sub = [s substringWithRange:range_dest];
					finding_head = YES;
					if ([exceptions containsObject:sub] == NO)
						break;
					//	else
					//	NSLog(@"skipping %@", sub);
				}
			}
		}
		if (sub != nil)
		{
			if ([exceptions containsObject:sub])
				break;
			//	NSLog(@"found sub: %@", sub);
			s = [s stringByReplacingOccurrencesOfString:sub withString:@""];
		}
	}

	return s;
}

- (NSString*)string_between:(NSString*)head and:(NSString*)tail
{
	NSRange range_head = [self rangeOfString:head];
	NSRange range_tail = [self rangeOfString:tail];
	NSRange range;

	if (range_head.location == NSNotFound)
		return nil;
	if (range_tail.location == NSNotFound)
		return nil;

	range.location = range_head.location + range_head.length;
	range.length = range_tail.location - range.location;

	return [self substringWithRange:range];
}

#pragma mark Time & Date

- (NSString*)convert_date_from:(NSString*)format_old to:(NSString*)format_new
{
	NSString* dateStr = self;

	//	Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:format_old];
	NSDate *date = [dateFormat dateFromString:dateStr];  
	
	//	Convert date object to desired output format
	[dateFormat setDateFormat:format_new];
	dateStr = [dateFormat stringFromDate:date];

	return dateStr;
}

@end
