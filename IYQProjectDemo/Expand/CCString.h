#import <UIKit/UIKit.h>

@interface NSString (CCString)

//	ui
- (void)show_alert_title:(NSString*)title message:(NSString*)msg;
- (void)show_alert_message:(NSString*)msg;
- (void)show_alert_title:(NSString*)title;
- (void)show_alert_message:(NSString*)msg delegate:(id)an_obj;
- (void)show_alert_title:(NSString*)title delegate:(id)an_obj;
- (void)show_alert_title:(NSString*)title message:(NSString*)msg delegate:(id)an_obj;

//	application
- (BOOL)go_url;
- (BOOL)can_go_url;

//	file
- (NSString*)filename_document;
- (NSString*)filename_bundle;
- (BOOL)is_directory;
- (BOOL)file_exists;
- (BOOL)file_exists_bundle;
- (BOOL)create_dir;
- (BOOL)file_backup;
- (BOOL)file_backup_to:(NSString*)dest;

//	url
- (NSString*)url_to_filename;
- (NSString*)to_url;

//	string
- (BOOL)has_substring:(NSString*)sub;
- (NSString*)string_without:(NSString*)head to:(NSString*)tail;
- (NSString*)string_without:(NSString*)head to:(NSString*)tail except:(NSArray*)exceptions;
- (NSString*)string_between:(NSString*)head and:(NSString*)tail;

//	date and time
- (NSString*)convert_date_from:(NSString*)format_old to:(NSString*)format_new;

@end

