#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface QingtiDashboardController : NSViewController
@end

@implementation QingtiDashboardController
- (void)loadView {
    NSRect frame = NSMakeRect(0, 0, 380, 650);
    WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
    NSURL *page = [[NSBundle mainBundle] URLForResource:@"avocado-todo" withExtension:@"html"];
    if (page != nil) {
        [webView loadFileURL:page allowingReadAccessToURL:[page URLByDeletingLastPathComponent]];
    }
    self.view = webView;
}
@end

@interface QingtiAppDelegate : NSObject <NSApplicationDelegate>
@property(nonatomic, strong) NSStatusItem *statusItem;
@property(nonatomic, strong) NSPopover *popover;
@end

@implementation QingtiAppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];

    self.popover = [[NSPopover alloc] init];
    self.popover.behavior = NSPopoverBehaviorTransient;
    self.popover.contentSize = NSMakeSize(380, 650);
    self.popover.contentViewController = [[QingtiDashboardController alloc] init];

    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.button.title = @"🥑";
    self.statusItem.button.toolTip = @"青提待办";
    self.statusItem.button.target = self;
    self.statusItem.button.action = @selector(togglePopover:);
}

- (void)togglePopover:(id)sender {
    if (self.popover.isShown) {
        [self.popover performClose:sender];
    } else if (self.statusItem.button != nil) {
        [self.popover showRelativeToRect:self.statusItem.button.bounds
                                  ofView:self.statusItem.button
                           preferredEdge:NSRectEdgeMinY];
    }
}
@end

@interface QingtiApplication : NSApplication
@property(nonatomic, strong) QingtiAppDelegate *retainedDelegate;
@end

@implementation QingtiApplication
- (instancetype)init {
    self = [super init];
    if (self) {
        self.retainedDelegate = [[QingtiAppDelegate alloc] init];
        self.delegate = self.retainedDelegate;
    }
    return self;
}
@end

int main(int argc, const char *argv[]) {
    return NSApplicationMain(argc, argv);
}
