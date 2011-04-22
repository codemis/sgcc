//
//  BeliefsViewController.m
//  SanGabrielUnionChurch
//
//  Created by Johnathan Pulos on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BeliefsViewController.h"


@implementation BeliefsViewController

@synthesize delegate, myWebView, navBar;

- (void)dealloc {
	[delegate release];
	[myWebView release];
	[navBar release];
    [super dealloc];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	self.navBar.topItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						   target:self 
																						   action:@selector(dismissBeliefs)] autorelease];
	self.navBar.topItem.title = @"What We Believe";
	NSString *html = @"<h2>The Bible</h2><p style='font-size: 20px;line-height: 30px;'>We believe that the Scripture, both Old and New Testaments, is the inspired Word of God. We believe it is without error in the original manuscripts, and is our supreme, sufficient, and infallible authority in all matters of faith and conduct.</p><p><small>2 Timothy 3:15 – 17; 2 Peter 1:20-21; Isaiah 40:8; 1 Thessalonians 2:13; Psalm 19:7-11; Acts 20:32; Psalm 19:7-11; Deuteronomy 8:3, Romans 15:4; Hebrews 4:12</small></p><h2>The Trinity</h2> <p style='font-size: 20px;line-height: 30px;'>We believe that there is one God who is the Creator of all things, that he is infinite, perfect, and unchangeable, and that he exists eternally in a loving fellowship of three persons: Father, Son and Holy Spirit, who are co-existent, co-equal and co-eternal. We believe that each person of the Trinity exercises distinct but harmonious functions in the work of creation, providence and redemption.</p><p><small>Deuteronomy 6:4-9; Isaiah 45:5-7; Ephesians 4:5-6; Genesis 1:1 – 2:3; Genesis 1:1; Matthew 5:48; James 1:17; Matthew 28:19; Matthew 3:13 – 17; 2 Corinthians 13:14; Genesis 1:1, 26; Ephesians 1:3 – 12 </small></p><h2>God the Father</h2> <p style='font-size: 20px;line-height: 30px;'>We believe that God the Father is the first person of the Trinity. We believe that by His word and for His glory He freely created all things and by the same sovereign power sustains, directs and rules over all things and that his plans cannot be thwarted. We believe He is holy, just and good. We believe He is the author of salvation who, according to His great mercy, saves for Himself those whom he chose in Christ unto salvation from before the foundation of the world, all to the praise of His glory. </p><p><small>Genesis 1-2; 1 Chronicles 29:10-13; Psalm 103:19; Psalms 99:3; Isaiah 6:3;Deuteronomy 32:4; Psalm 100:5; Luke 18:19; John 1:12, 3:16; 1 Timothy 2:5-6; 1 Peter 1:3</small></p><h2>God the Son</h2> <p style='font-size: 20px;line-height: 30px;'>We believe that Jesus Christ is the second person of the Trinity. We believe that He is God incarnate, fully God and fully man, one Person with two natures. We believe that He upholds the universe by the word of His power. We believe He was born of a virgin, lived a sinless life, performed miracles, was crucified under Pontius Pilate, arose bodily from the dead and ascended into heaven.</p><p><small>John 20:31; Romans 9:5; John 1:14; Matthew 1:18-25, 20:28; Philippians 2:5-11; Colossians 2:9; Hebrews 1:3; John 1:1-3; Hebrews 1:2-3; Colossians 1:15 – 20; Isaiah 7:14, Luke 1:26 – 35; 2 Corinthians 5:21; 1 Peter 2:21-23; Matthew 20:28; Matthew 4:23; Mark 1:34; Matthew 27; Romans 5:6-8; 6:9, 10; Acts 1:9-11</small></p><h2>God the Spirit</h2> <p style='font-size: 20px;line-height: 30px;'>We believe that the Holy Spirit is the third person of the Trinity. We believe He was sovereignly active in creation, in the incarnation and in the inspiration of Scripture, and is active in human history. We believe He was sent by the Father and the Son to convict the world of sin, righteousness and judgment. We believe that the Holy Spirit sovereignly awakens the soul, which is dead in sin, to be made alive in Christ and seals it for the day of redemption. We believe He indwells every believer and that He is the abiding helper, teacher and guide. We believe the Holy Spirit equips and empowers believers for Christian witness and service and gives gifts for the purpose of building up of the body of Christ, the Church, and transforms the believer more and more into the likeness of Christ.</p><p><small>Genesis 1:2, 26; Matthew 1:18; 2 Peter 1:20-21 Numbers 27:18; Nehemiah 9:30; Psalm 139:7; John 14:16 - 26; 15:26-27; 16:7-14; John 16:8; John 6:63; Romans 8:10-11; Ephesians 2:1; Ephesians 4:30; Titus 3:5; Romans 8:9-11; 1 Corinthians 12:4-13; Jeremiah 31:34 (cf. Hebrews 10:15-17); Joel 2:28-32 (cf. Acts 2:14-21); Galatians 5:22-26; 1 Corinthians 12:4-11; Ephesians 4:7-12; Hebrews 2:1-4; 2 Corinthians 3:4-18; Ephesians 2:22</small></p><h2>Work of Christ</h2> <p style='font-size: 20px;line-height: 30px;'>We believe that Jesus Christ, as our representative and substitute, shed His blood on the cross as the perfect, all-sufficient sacrifice for our sins. We believe His atoning death and victorious, bodily resurrection constitute the only ground for salvation. We believe He rose from the dead and sat down at the right hand of God the Father where He continually intercedes for His people as our High Priest and Advocate.</p><p><small>Isaiah 52:13 – 53:12; 1 Peter 2:24; Mark 10:45; John 10:15; Acts 20:28; 2 Corinthians 5:21; 1 John 4:10; Matthew 28:1-6; Romans 3:21-26; 5:8; 1 Peter 3:18; Romans 1:4; 1 Corinthians 15:12-20; 1 Timothy 2:5; Hebrews 7:24-25; Ephesians 1:16 – 21; Hebrews 4:14; 9:24; 1 John 2:1</small></p><h2>The Christian Life</h2> <p style='font-size: 20px;line-height: 30px;'>We believe all are sinners who fall short of the glory of God and stand hopeless and condemned before Him. We believe a sinner is saved by grace alone through faith alone in the gospel of Jesus Christ. We believe the gospel is the good news that Jesus Christ died for our sins and rose again, conquering all of his enemies, including sin and death, so that there is no condemnation for those who believe. We believe eternal life is secured for the believer by the effectual and sovereign grace of God. We believe it is the duty and delight of all who believe to love God with all their heart, soul, mind and strength, to abide in Him, to be obedient to His Word, and to seek to live to the glory of God.</p><p><small>Romans 3:23, 6:23; Ephesians 2:1-10; 1 Corinthians 15:3-4; Romans 8:1-4; Romans 10:9-11; Matthew 22:37-38; Luke 10:27; John 14:15 – 24; 1 John 2:3-6; 1 Corinthians 6:19-20; 10:31</small></p><h2>The Church</h2> <p style='font-size: 20px;line-height: 30px;'>We believe the Church is a living spiritual body of which Christ is the head and all those who have been chosen by God for salvation and justified by His grace through saving faith in Christ are its members, marked by love for one another and the exercising of their gifts. We believe it is the Church’s joy and responsibility to fulfill the Great Commission given by our Lord to make disciples of all nations.</p><p><small>1 Corinthians 12:12-13; Colossians 1:18; Ephesians 2:11-3:12; 4:11-16; 5:22-23; Hebrews 10:23-25; Jude 20-23; Matthew 28:18-20; Acts 1:8; Romans 1:5</small></p><h2>The Return of Christ</h2> <p style='font-size: 20px;line-height: 30px;'>We believe in the personal, visible and glorious return of the Lord Jesus Christ to earth and the establishment of His kingdom. We believe His followers are to live in expectation of His imminent return. We believe in the bodily resurrection of both the saved and the lost — the saved to an endless, joyful, and living reign with Christ, and the lost to endless punishment away from the benevolent presence of God.</p><p><small>Mark 14:62; Acts 1:11; Revelation 20:1-6, 11-15; Titus 2:11-14; 1 Thessalonians 4:15; John 14:1-3; Philippians 3:20; 1 Corinthians 4:5; 2 Thessalonians 1:7-10; 2 Timothy 4:1</small></p>";
	[self.myWebView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.sgucandcs.org"]];
}

- (void) dismissBeliefs {
	if ([self.delegate 
         respondsToSelector:@selector(modalViewReadyToDismiss)] ) {
        [self.delegate modalViewReadyToDismiss];
    }
}

#pragma mark -
#pragma mark Respond to ModalViewControllerDelegate
-(void) modalViewReadyToDismiss{
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
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

@end
