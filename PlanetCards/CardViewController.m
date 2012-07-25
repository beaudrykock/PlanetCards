//
//  CardViewController.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/20/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "CardViewController.h"

@implementation CardViewController

@synthesize question_image,question_frame,question, answer_1, answer_2, answer_3, answer_4;
@synthesize buttonBackground_right, buttonBackground_wrong, buttonBackground_corrected;
@synthesize buttonArray;
@synthesize correctIncorrectView, correctIncorrectLabel, correctIncorrectImage;
@synthesize parentController;
@synthesize quizDB, difficultyView, paidVersionOnlyView;
@synthesize buttonTray, supplementalInfoText, supplementalInfoView, supplementalInfoTitle, imageContainerView, postAnswerInstructions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadButtonBackgrounds];
    
    [self stockButtonArray];
    
    [self prettifyCards];
    
    answeredCorrect = NO;
    timerExpired  =NO;
    
    // add gesture recognizer tap to the image
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSupplementalInformation:)];
    
    [self.question_image addGestureRecognizer:tap];
    
    [tap release];
    
    
    // add same to the supplementalInfoView
    UITapGestureRecognizer *tap_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSupplementalInformation:)];
    [self.supplementalInfoView addGestureRecognizer:tap_2];
    [tap_2 release];
    
    [self.imageContainerView removeFromSuperview];
    [self.view insertSubview:self.imageContainerView belowSubview:self.buttonTray];
    
    //[self prepCard];
        
    originalFrame = CGRectMake(10.0, 50.0, kCardViewWidth, kCardViewHeight);
}

-(void)setCurrentQuestionNumber:(NSInteger)questionNumber
{
    currentQuestionNumber = questionNumber;
}



-(void)loseAnAnswer
{
    
    NSInteger rightAnswerIndex = [quizDB getRightAnswerIndexForQuestion:currentQuestionNumber];
    
    UIButton *candidate = nil;
    BOOL success = NO;
    int count = 0;
    while (count<numberOfAnswers && !success) {
        if (count!=rightAnswerIndex)
        {
            candidate =[buttonArray objectAtIndex:count];
            if (![candidate isHidden])
            {
                [candidate setHidden:YES];
                success = YES;
            }
            else
            {
                count++;
            }
        }
        else
        {
            count++;
        }
            
    }
}

-(void)answerPeriodExpired
{
    answeredCorrect = NO;
    timerExpired = YES;
    
    NSInteger rightAnswerIndex = [quizDB getRightAnswerIndexForQuestion:currentQuestionNumber];
    
    UIButton *correctButton = nil;
    correctButton =[buttonArray objectAtIndex:rightAnswerIndex];
    [correctButton setBackgroundImage:buttonBackground_corrected forState:UIControlStateNormal];
    
    [self showCorrectIncorrectOverlay];
}

-(void)prepCard
{
    QuizQuestion *newQuestion = [quizDB getQuestionNumbered:currentQuestionNumber];
    numberOfAnswers = [[newQuestion quizAnswers] count];
    
    [self.question setText:[newQuestion question]];
    
    [self.supplementalInfoText setText:[newQuestion supplementalInfo]];
    
    [self hideAnswerButtons];
    //[self removeAnswerButtons];
    
    [self.difficultyView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"diff_%i",[newQuestion level]]]];
    
    if ([[newQuestion quizAnswers] count]==2)
    {
        [answer_1 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 0] answer] forState:UIControlStateNormal];
        [answer_1 setHidden:NO];
        [answer_2 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 1] answer] forState:UIControlStateNormal];
        [answer_2 setHidden:NO];
    }
    else if ([[newQuestion quizAnswers] count]==3)
    {
        [answer_1 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 0] answer] forState:UIControlStateNormal];
        [answer_1 setHidden:NO];
        [answer_2 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 1] answer] forState:UIControlStateNormal];
        [answer_2 setHidden:NO];
        [answer_3 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 2] answer] forState:UIControlStateNormal];
        [answer_3 setHidden:NO];
    }
    else
    {
        [answer_1 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 0] answer] forState:UIControlStateNormal];
        [answer_1 setHidden:NO];
        [answer_2 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 1] answer] forState:UIControlStateNormal];
        [answer_2 setHidden:NO];
        [answer_3 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 2] answer] forState:UIControlStateNormal];
        [answer_3 setHidden:NO];
        [answer_4 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 3] answer] forState:UIControlStateNormal];
        [answer_4 setHidden:NO];
    }
    
    //CGSize sizeThatFits = [self.buttonTray sizeThatFits: self.buttonTray.frame.size];
    //self.buttonTray.frame = CGRectMake(self.buttonTray.frame.origin.x, self.buttonTray.frame.origin.y, sizeThatFits.width, sizeThatFits.height);
    
    NSString *imageFilename = [newQuestion questionImageFilenameWithoutType];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png"]];
    self.question_image = [[UIImageView alloc] initWithImage:image];
    [image release];
}
                                           

-(void)prepCardForQuestionNumber:(NSInteger)questionNumber
{
    //NSLog(@"prepping card with question number %i", questionNumber);
    currentQuestionNumber = questionNumber;
    
    QuizQuestion *newQuestion = [quizDB getQuestionNumbered:currentQuestionNumber];
    numberOfAnswers = [[newQuestion quizAnswers] count];
    
    [question setText:[newQuestion question]];
    if (![[newQuestion supplementalInfo] isEqualToString:@"none"])
    {
        [self.supplementalInfoText setText:[newQuestion supplementalInfo]];
    }
    
    [self hideAnswerButtons];
    
    [self.difficultyView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"diff_%i",[newQuestion level]]]];
    
    if ([[newQuestion quizAnswers] count]==2)
    {
        [answer_1 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 0] answer] forState:UIControlStateNormal];
        [answer_1 setHidden:NO];
        [answer_2 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 1] answer] forState:UIControlStateNormal];
        [answer_2 setHidden:NO];
    }
    else if ([[newQuestion quizAnswers] count]==3)
    {
        [answer_1 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 0] answer] forState:UIControlStateNormal];
        [answer_1 setHidden:NO];
        [answer_2 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 1] answer] forState:UIControlStateNormal];
        [answer_2 setHidden:NO];
        [answer_3 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 2] answer] forState:UIControlStateNormal];
        [answer_3 setHidden:NO];
    }
    else
    {
        [answer_1 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 0] answer] forState:UIControlStateNormal];
        [answer_1 setHidden:NO];
        [answer_2 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 1] answer] forState:UIControlStateNormal];
        [answer_2 setHidden:NO];
        [answer_3 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 2] answer] forState:UIControlStateNormal];
        [answer_3 setHidden:NO];
        [answer_4 setTitle:[[[newQuestion quizAnswers] objectAtIndex: 3] answer] forState:UIControlStateNormal];
        [answer_4 setHidden:NO];
    }
    
    // CGSize sizeThatFits = [self.buttonTray sizeThatFits: self.buttonTray.frame.size];
    // self.buttonTray.frame = CGRectMake(self.buttonTray.frame.origin.x, self.buttonTray.frame.origin.y, sizeThatFits.width, sizeThatFits.height);
    
    NSString *imageFilename = [newQuestion questionImageFilenameWithoutType];
   // NSLog(@"prepping card with image filename, %@", imageFilename);
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png"]];
    [self.question_image setImage:image];
}

-(void)hideAnswerButtons
{
    [answer_1 setHidden:YES];
    [answer_2 setHidden:YES];
    [answer_3 setHidden:YES];
    [answer_4 setHidden:YES];
}

-(void)removeAnswerButtons
{
    [answer_1 removeFromSuperview];
    [answer_2 removeFromSuperview];
    [answer_3 removeFromSuperview];
    [answer_4 removeFromSuperview];
}

-(void)freezeButtons
{
    [answer_1 setEnabled:NO];
    [answer_2 setEnabled:NO];
    [answer_3 setEnabled:NO];
    [answer_4 setEnabled:NO];
}

#pragma mark - Answer response
-(IBAction)submitAnswer:(id)sender
{
    answered = YES;
    [self freezeButtons];
    NSInteger answer_number = [sender tag];
    UIButton *buttonPressed = nil;
    buttonPressed = [buttonArray objectAtIndex:answer_number];
    
    // check if right or wrong
    answeredCorrect = [quizDB checkCorrectnessForQuestion:currentQuestionNumber andAnswer:answer_number];
    
    if (answeredCorrect)
    {
        [buttonPressed setBackgroundImage:buttonBackground_right forState:UIControlStateNormal];
    }
    else
    {
        [buttonPressed setBackgroundImage:buttonBackground_wrong forState:UIControlStateNormal];
        
        NSInteger rightAnswerIndex = [quizDB getRightAnswerIndexForQuestion:currentQuestionNumber];
        
        UIButton *correctButton = nil;
        correctButton =[buttonArray objectAtIndex:rightAnswerIndex];
        [correctButton setBackgroundImage:buttonBackground_corrected forState:UIControlStateNormal];
        
        if ([Utilities vibrationOn])
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    [[self parentController] answerQuestionIsCorrect:answeredCorrect withSkip:NO];
    
    [self showCorrectIncorrectOverlay];
}

-(void)showCorrectIncorrectOverlay
{
    
    // enable touches on the image, so supplemental information can be displayed
    [self.question_image setUserInteractionEnabled:YES];
    
    // first add overlay with "correct!" or "incorrect"
    if (!answeredCorrect && !timerExpired)    
    {
        [self.correctIncorrectLabel setText:@"Incorrect"];
        NSString *imageFilename = @"overlay_incorrect";
        UIImage *imageToSet = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png"]];
        [self.correctIncorrectView setBackgroundColor:[UIColor colorWithRed:166.0/255.0 green:51.0/255.0 blue:54.0/255.0 alpha:1.0]];
        [self.correctIncorrectImage setImage:imageToSet];        
    }
    else if (timerExpired)
    {
        
        [self.correctIncorrectLabel setText:@"Out of time"];
        NSString *imageFilename = @"overlay_incorrect";
        UIImage *imageToSet = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png"]];
        [self.correctIncorrectView setBackgroundColor:[UIColor colorWithRed:166.0/255.0 green:51.0/255.0 blue:54.0/255.0 alpha:1.0]];
        [self.correctIncorrectImage setImage:imageToSet];
    }
    else {
        [self.correctIncorrectView setBackgroundColor:[UIColor colorWithRed:70.0/255.0 green:135.0/255.0 blue:10.0/255.0 alpha:1.0]];
    }
    
    // set text differently if end of quiz
    if (currentQuestionNumber==(kNumberOfQuestions-1))
    {
        [self.postAnswerInstructions setText:@"Swipe the card to finish, or tap the image to learn more"];
    }
    
    self.correctIncorrectView.frame = CGRectMake(0.0, self.buttonTray.frame.origin.y, self.correctIncorrectView.frame.size.width, self.correctIncorrectView.frame.size.height);
    
    [self.view insertSubview:self.correctIncorrectView aboveSubview:self.imageContainerView];
    CGRect targetFrame = CGRectMake(self.buttonTray.frame.origin.x, self.buttonTray.frame.origin.y-self.correctIncorrectView.frame.size.height, self.correctIncorrectView.frame.size.width, self.correctIncorrectView.frame.size.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self.correctIncorrectView setFrame:targetFrame];
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
    [UIView commitAnimations];
}

- (void)transitionDidStop:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    [correctIncorrectView setFrame:CGRectMake(-400, -400, correctIncorrectView.frame.size.width, correctIncorrectView.frame.size.height)];
}

-(IBAction)showSupplementalInformation:(id)sender
{
#ifdef LITE_VERSION
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Paid version only" message:@"Sorry, but supplemental information is only available in the paid version of PlanetCards" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
#else
    if (self.correctIncorrectView.superview)
    {
        CGRect targetFrame = CGRectMake(self.correctIncorrectView.frame.origin.x, self.correctIncorrectView.frame.origin.y+self.correctIncorrectView.frame.size.height, self.correctIncorrectView.frame.size.width, self.correctIncorrectView.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [self.correctIncorrectView setFrame:targetFrame];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removeCorrectionOverlay)];
        [UIView commitAnimations];
    }
    
    
    [self.supplementalInfoView setFrame:self.question_image.frame];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];  
    
    if (!supplementalInfoShowing)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.imageContainerView cache:YES];
        
        [self.question_image removeFromSuperview];
        [self.imageContainerView addSubview:self.supplementalInfoView];
        [self.imageContainerView sendSubviewToBack:self.question_image];
        supplementalInfoShowing = YES;
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.imageContainerView cache:YES];
        
        [self.supplementalInfoView removeFromSuperview];
        [self.imageContainerView addSubview:self.question_image];
        [self.imageContainerView sendSubviewToBack:self.supplementalInfoView];
        supplementalInfoShowing = NO;
    }
    
    [UIView commitAnimations];
#endif  
}

-(void)removeCorrectionOverlay
{
    [self.correctIncorrectView removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prettifyCards
{
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    self.view.layer.cornerRadius = 5.0f;
    question_frame.layer.cornerRadius = 5.0f;
    
    self.correctIncorrectView.layer.cornerRadius = 5.0f;
    self.correctIncorrectView.layer.masksToBounds = NO;
    self.correctIncorrectView.layer.shadowOffset = CGSizeMake(-5, 5);
    self.correctIncorrectView.layer.shadowOffset = CGSizeMake(-5, 5);
    self.correctIncorrectView.layer.shadowOpacity = 0.5;
    
    //self.view.layer.masksToBounds = NO;
    //self.view.layer.shadowOffset = CGSizeMake(-5, 5);
    //self.view.layer.shadowOffset = CGSizeMake(-5, 5);
    //self.view.layer.shadowOpacity = 0.5;
}

-(void)loadButtonBackgrounds
{
    buttonBackground_wrong = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answer_wrong_stacked" ofType:@"png"]] retain];
    buttonBackground_right = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answer_right_stacked" ofType:@"png"]] retain];
    buttonBackground_corrected = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"answer_corrected_stacked" ofType:@"png"]] retain];
}

-(void)stockButtonArray
{
    buttonArray = [[NSArray arrayWithObjects:answer_1, answer_2, answer_3, answer_4, nil] retain];
    
}

#pragma mark - Touch to drag
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
    
	//if ([touch view] != self.view) {
    // record offset from origin of view
        CGPoint location = [touch locationInView:self.view];
        offset_x = location.x;
        offset_y = location.y;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	//if ([touch view] == self.view) {
    
        CGPoint location = [touch locationInView:self.view.superview];
		CGRect frame = self.view.frame;

        frame.origin.x = location.x-offset_x;
        frame.origin.y = location.y-offset_y;
        
        self.view.frame = frame;		
		
        return;
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	//if ([touch view] == self.view) {
        if (self.view.frame.origin.x < ((self.view.frame.size.width/4.0)*-1.0))
        {
            if (!timerExpired && !answered)
                [self.parentController answerQuestionIsCorrect:NO withSkip:YES];
            [self animateCardOffscreen];  
        }
        else {
            [self restoreCardPosition];
        }
		// Disable user interaction so subsequent touches don't interfere with animation
		//self.slideView.userInteractionEnabled = NO;
		//[self animateViewOffScreen];
		return;
	//}		
}

-(void)animateCardOffscreen
{
    if (![[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
   
    self.view.layer.shouldRasterize = YES; // test
    
    CGPoint viewOrigin = CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y);
    // Set up path movement
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    CGPoint endPoint = CGPointMake(0 - kCardViewWidth, 0.0f); // changed 07/23/12 from -100.0f y
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, viewOrigin.y, endPoint.x, viewOrigin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    CABasicAnimation *partialRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    partialRotation.fromValue = [NSNumber numberWithFloat:0];
    partialRotation.toValue = [NSNumber numberWithFloat:M_PI * 45.0 / 180.0];
    partialRotation.repeatCount = 1;
    
    CAAnimationGroup *group = [CAAnimationGroup animation]; 
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setAnimations:[NSArray arrayWithObjects:pathAnimation, partialRotation, nil]];
    group.duration = 1.5f;
    group.delegate = self;
    [group setValue:@"card_removed" forKey:@"Name"];
    [group setValue:self.view forKey:@"imageViewBeingAnimated"];
    
    // UNCOMMENT FOR GAMECENTER TESTING
    //if(gameActive)
    [self.view.layer addAnimation:group forKey:@"savingAnimation"];
    
    //CGRect targetFrame = CGRectMake(-1*kCardViewWidth, self.view.frame.origin.y, kCardViewWidth, kCardViewHeight);
     //[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^
     //{
     //    [[self parentController] animateViewOutAtCardIndex: cardIndex];
         //self.view.frame = targetFrame;
     //} completion:^(BOOL finished){
         
     //}];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    NSString* name = [anim valueForKey: @"Name"];
    if ([name isEqualToString: @"card_removed"]) {
        [self.view removeFromSuperview];
        [[self parentController] cardRemovalAnimationComplete];
    }
}

-(void)restoreCardPosition
{
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^
    {
        self.view.frame = originalFrame;
    } completion:^(BOOL finished){
        
    }];
    
}

-(NSInteger)getCurrentQuestionNumber
{
    return currentQuestionNumber;
}

-(void)setCardIndex:(NSInteger)_cardIndex
{
    cardIndex = _cardIndex;
}

-(void)dealloc
{
    [super dealloc];
    [imageContainerView release];
    [supplementalInfoText release];
    [supplementalInfoTitle release];
    [supplementalInfoView release];
    [question_image release];
    [question_frame release];
    [question release];
    [answer_1 release];
    [answer_2 release];
    [answer_3 release];
    [answer_4 release];
    [buttonBackground_wrong release];
    [buttonBackground_right release];
    [buttonBackground_corrected release];
    [buttonArray release];
    [correctIncorrectLabel release];
    [correctIncorrectView release];
    [correctIncorrectImage release];
    [quizDB release];
    [buttonTray release];
    [postAnswerInstructions release];
}


@end
