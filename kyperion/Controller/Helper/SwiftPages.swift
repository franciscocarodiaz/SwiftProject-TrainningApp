//
//  SwiftPages.swift
//  SwiftPages
//
//  Created by Gabriel Alvarado on 6/27/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

import UIKit

class SwiftPages: UIView, UIScrollViewDelegate {
    
    //Items variables
    private var containerView: UIView!
    private var scrollView: UIScrollView!
    private var topBar: UIView!
    private var animatedBar: UIView!
    private var viewControllerIDs: [String] = []
    private var buttonTitles: [String] = []
    private var buttonImages: [UIImage] = []
    private var pageViews: [UIViewController?] = []
    
    //Container view position variables
    private var xOrigin: CGFloat = 0
    private var yOrigin: CGFloat = 64
    private var distanceToBottom: CGFloat = 0
    
    //Color variables
    private var animatedBarColor = UIColor(red: 28/255, green: 95/255, blue: 185/255, alpha: 1)
    private var topBarBackground = UIColor.whiteColor()
    private var buttonsTextColor = UIColor.grayColor()
    private var containerViewBackground = UIColor.whiteColor()
    private var addMarginTop = true
    private var addDoubleMarginTop = false
    
    //Item size variables
    private var topBarHeight: CGFloat = 52
    private var animatedBarHeight: CGFloat = 3
    
    //Bar item variables
    private var aeroEffectInTopBar: Bool = false //This gives the top bap a blurred effect, also overlayes the it over the VC's
    var section: Int = 0
    var VC_PROFILE: Int = 0
    var VC_PROFILE_INFO: Int = 1
    var VC_ACTIVITY: Int = 2
    var VC_ACTIVITY_GRAPHIC: Int = 3
    var VC_CALENDAR: Int = 4
    var VC_MESSAGE: Int = 5
    
    private var buttonsWithImages: Bool = false
    private var buttonsWithImagesAndTitle: Bool = false
    private var barShadow: Bool = true
    private var buttonsTextFontAndSize: UIFont = UIFont(name: "HelveticaNeue-Light", size: 14)!
    var barButtonTitle: UIButton!
    
    // MARK: - Positions Of The Container View API -
    func setOriginX (origin : CGFloat) { xOrigin = origin }
    func setOriginY (origin : CGFloat) { yOrigin = origin }
    func setDistanceToBottom (distance : CGFloat) { distanceToBottom = distance }
    
    // MARK: - API's -
    func setMarginTop (addMargin : Bool) { addMarginTop = addMargin }
    func setDoubleMarginTop (addMargin : Bool) { addDoubleMarginTop = addMargin }
    func setAnimatedBarColor (color : UIColor) { animatedBarColor = color }
    func setTopBarBackground (color : UIColor) { topBarBackground = color }
    func setButtonsTextColor (color : UIColor) { buttonsTextColor = color }
    func setContainerViewBackground (color : UIColor) { containerViewBackground = color }
    func setTopBarHeight (pointSize : CGFloat) { topBarHeight = pointSize}
    func setAnimatedBarHeight (pointSize : CGFloat) { animatedBarHeight = pointSize}
    func setButtonsTextFontAndSize (fontAndSize : UIFont) { buttonsTextFontAndSize = fontAndSize}
    func enableAeroEffectInTopBar (boolValue : Bool) { aeroEffectInTopBar = boolValue}
    func enableButtonsWithImages (boolValue : Bool) { buttonsWithImages = boolValue}
    func enableBarShadow (boolValue : Bool) { barShadow = boolValue}
    
    let arrayCalendar = ["DayCalendar", "WeekCalendarViewController"]
    let arrayGraphic = ["GraphicBeatViewController","GraphicVelocityViewController"]
    let arrayMessage = ["InboxMessagesTableViewController", "OutboxTableViewController", "TrashTableViewController"]
    
    override func drawRect(rect: CGRect)
    {
        // MARK: - Size Of The Container View -
        var pagesContainerHeight = self.frame.height - yOrigin - distanceToBottom
        var pagesContainerWidth = self.frame.width
        
        //Set the containerView, every item is constructed relative to this view
        containerView = UIView(frame: CGRectMake(xOrigin, yOrigin, pagesContainerWidth, pagesContainerHeight))
        containerView.backgroundColor = containerViewBackground
        self.addSubview(containerView)
        
        //Set the scrollview
        if (aeroEffectInTopBar) {
            scrollView = UIScrollView(frame: CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height))
        } else {
            scrollView = UIScrollView(frame: CGRectMake(0, topBarHeight, containerView.frame.size.width, containerView.frame.size.height - topBarHeight))
        }
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        containerView.addSubview(scrollView)
        
        //Set the top bar
        topBar = UIView(frame: CGRectMake(0, 0, containerView.frame.size.width, topBarHeight))
        topBar.backgroundColor = topBarBackground
        if (aeroEffectInTopBar) {
            //Create the blurred visual effect
            //You can choose between ExtraLight, Light and Dark
            topBar.backgroundColor = UIColor.clearColor()
            let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = topBar.bounds
            blurView.translatesAutoresizingMaskIntoConstraints()
            topBar.addSubview(blurView)
        }
        containerView.addSubview(topBar)
        
        //Set the top bar buttons
        var buttonsXPosition: CGFloat = 0
        
        var buttonNumber = 0
        
        //Check to see if the top bar will be created with images ot text
        if buttonsWithImagesAndTitle {
            var width = containerView.frame.size.width/(CGFloat)(viewControllerIDs.count)
            
            for item in buttonTitles
            {
                var buttonView : UIView = UIView(frame: CGRectMake(buttonsXPosition, 0, width, topBarHeight))
                
                var barButton: UIButton!
                barButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                barButton.frame = CGRectMake(0, 0, width, topBarHeight-14)
                
                barButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                barButton.setImage(buttonImages[buttonNumber], forState: .Normal)
                barButton.backgroundColor = UIColor.clearColor()
                //barButton.titleLabel!.font = buttonsTextFontAndSize
                //barButton.setTitle(buttonTitles[buttonNumber], forState: UIControlState.Normal)
                //barButton.setTitleColor(buttonsTextColor, forState: UIControlState.Normal)
                barButton.tag = buttonNumber
                barButton.addTarget(self, action: "barButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                buttonView.addSubview(barButton)
                
                
                barButtonTitle = UIButton(frame: CGRectMake(0, topBarHeight-14, width, 14))
                barButtonTitle.backgroundColor = UIColor.clearColor()
                barButtonTitle.titleLabel!.font = buttonsTextFontAndSize
                barButtonTitle.setTitle(item, forState: UIControlState.Normal)
                barButtonTitle.setTitleColor(buttonsTextColor, forState: UIControlState.Normal)
                
                barButtonTitle.tag = buttonNumber
                barButtonTitle.addTarget(self, action: "barButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
                buttonView.addSubview(barButtonTitle)
                /*
                var spacing = 0.0
                let imageSize = CGSize(width: width, height: topBarHeight)
                barButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, width, 10)
                let titleSize = barButton.titleLabel!.frame.size
                barButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, width, topBarHeight)
                
                // reset contentInset, so intrinsicContentSize() is still accurate
                let trueContentSize = CGRectUnion(barButton.titleLabel!.frame, barButton.imageView!.frame).size
                let oldContentSize = self.intrinsicContentSize()
                let heightDelta = trueContentSize.height - oldContentSize.height
                let widthDelta = trueContentSize.width - oldContentSize.width
                barButton.contentEdgeInsets = UIEdgeInsetsMake(heightDelta/2.0, widthDelta/2.0, heightDelta/2.0, -widthDelta/2.0)
                */
                topBar.addSubview(buttonView)
                buttonsXPosition = width + buttonsXPosition
                buttonNumber++
            }
            
            
        }else if (!buttonsWithImages) {
            for item in buttonTitles
            {
                var barButton: UIButton!
                barButton = UIButton(frame: CGRectMake(buttonsXPosition, 0, containerView.frame.size.width/(CGFloat)(viewControllerIDs.count), topBarHeight))
                barButton.backgroundColor = UIColor.clearColor()
                barButton.titleLabel!.font = buttonsTextFontAndSize
                barButton.setTitle(buttonTitles[buttonNumber], forState: UIControlState.Normal)
                barButton.setTitleColor(buttonsTextColor, forState: UIControlState.Normal)
                barButton.tag = buttonNumber
                barButton.addTarget(self, action: "barButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                topBar.addSubview(barButton)
                buttonsXPosition = containerView.frame.size.width/(CGFloat)(viewControllerIDs.count) + buttonsXPosition
                buttonNumber++
            }
        } else {
            for item in buttonImages
            {
                var barButton: UIButton!
                barButton = UIButton(frame: CGRectMake(buttonsXPosition, 0, containerView.frame.size.width/(CGFloat)(viewControllerIDs.count), topBarHeight))
                barButton.backgroundColor = UIColor.clearColor()
                barButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                barButton.setImage(item, forState: .Normal)
                barButton.tag = buttonNumber
                barButton.addTarget(self, action: "barButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                topBar.addSubview(barButton)
                buttonsXPosition = containerView.frame.size.width/(CGFloat)(viewControllerIDs.count) + buttonsXPosition
                buttonNumber++
            }
        }
        
        //Set up the animated UIView
        animatedBar = UIView(frame: CGRectMake(0, topBarHeight - animatedBarHeight + 1, (containerView.frame.size.width/(CGFloat)(viewControllerIDs.count))*0.8, animatedBarHeight))
        animatedBar.center.x = containerView.frame.size.width/(CGFloat)(viewControllerIDs.count * 2)
        animatedBar.backgroundColor = animatedBarColor
        containerView.addSubview(animatedBar)
        
        //Add the bar shadow (set to true or false with the barShadow var)
        if (barShadow) {
            var shadowView = UIView(frame: CGRectMake(0, topBarHeight, containerView.frame.size.width, 4))
            var gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = shadowView.bounds
            gradient.colors = [UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.28).CGColor, UIColor.clearColor().CGColor]
            shadowView.layer.insertSublayer(gradient, atIndex: 0)
            containerView.addSubview(shadowView)
        }
        
        let pageCount = viewControllerIDs.count
        
        //Fill the array containing the VC instances with nil objects as placeholders
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        //Defining the content size of the scrollview
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageCount),
            height: 1.0)
        
        //Load the pages to show initially
        loadVisiblePages()
    }
    
    // MARK: - Initialization Functions -
    func initializeWithVCIDsArrayAndButtonTitlesArray (VCIDsArray: [String], buttonTitlesArray: [String])
    {
        //Important - Titles Array must Have The Same Number Of Items As The viewControllerIDs Array
        if VCIDsArray.count == buttonTitlesArray.count {
            viewControllerIDs = VCIDsArray
            buttonTitles = buttonTitlesArray
            buttonsWithImages = false
        } else {
            print("Initilization failed, the VC ID array count does not match the button titles array count.")
        }
    }
    
    func initializeWithVCIDsArrayAndButtonImagesArray (VCIDsArray: [String], buttonImagesArray: [UIImage])
    {
        //Important - Images Array must Have The Same Number Of Items As The viewControllerIDs Array
        if VCIDsArray.count == buttonImagesArray.count {
            viewControllerIDs = VCIDsArray
            buttonImages = buttonImagesArray
            buttonsWithImages = true
        } else {
            print("Initilization failed, the VC ID array count does not match the button images array count.")
        }
    }
    
    func initializeWithVCIDsArrayAndButtonImagesArrayWithTitle (VCIDsArray: [String], buttonImagesArray: [UIImage], buttonTitlesArray: [String])
    {
        //Important - Images Array must Have The Same Number Of Items As The viewControllerIDs Array
        if VCIDsArray.count == buttonImagesArray.count {
            viewControllerIDs = VCIDsArray
            buttonImages = buttonImagesArray
            buttonTitles = buttonTitlesArray
            buttonsWithImagesAndTitle = true
        } else {
            print("Initilization failed, the VC ID array count does not match the button images array count.")
        }
    }
    
    func loadPage(page: Int)
    {
        if page < 0 || page >= viewControllerIDs.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        //Use optional binding to check if the view has already been loaded
        if let pageView = pageViews[page]
        {
            // Do nothing. The view is already loaded.
        } else
        {
            //print("Loading Page \(page)")
            //The pageView instance is nil, create the page
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            //frame.origin.y = 0.0
            frame.origin.y = 0.0 - topBarHeight*1.25
            if !addMarginTop {
                frame.origin.y = 0.0
            }
            
            
            //Create the variable that will hold the VC being load
            var newPageView: UIViewController
            
            //Look for the VC by its identifier in the storyboard and add it to the scrollview
            newPageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(viewControllerIDs[page]) as! UIViewController
            
            if contains(arrayCalendar, viewControllerIDs[page]) {
                frame.origin.y = 0.0  - topBarHeight*2
            }else if contains(arrayGraphic, viewControllerIDs[page]) {
                frame.origin.y = 0.0
            }else if contains(arrayMessage, viewControllerIDs[page]) {
                frame.origin.y = 0.0  - topBarHeight*2
            }
            /*
            if viewControllerIDs[page] == "GraphicVelocityViewController" || viewControllerIDs[page] == "GraphicBeatViewController" {
                
            }
            */
            newPageView.view.frame = frame
            newPageView.navigationItem.title = buttonTitles[page]
            scrollView.addSubview(newPageView.view)
            
            //Replace the nil in the pageViews array with the VC just created
            pageViews[page] = newPageView
        }
    }
    
    func loadVisiblePages()
    {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
    }
    
    func barButtonAction(sender: UIButton?)
    {
        var index: Int = sender!.tag
        let pagesScrollViewSize = containerView.frame.size
        
        switch section {
        case VC_PROFILE:
            [scrollView .setContentOffset(CGPointMake(pagesScrollViewSize.width * (CGFloat)(index), -(topBarHeight+12)), animated: true)]
        case VC_PROFILE_INFO:
            [scrollView .setContentOffset(CGPointMake(pagesScrollViewSize.width * (CGFloat)(index), 0), animated: true)]
        case VC_ACTIVITY:
            [scrollView .setContentOffset(CGPointMake(pagesScrollViewSize.width * (CGFloat)(index), 0), animated: true)]
        case VC_ACTIVITY_GRAPHIC:
            [scrollView .setContentOffset(CGPointMake(pagesScrollViewSize.width * (CGFloat)(index), -2), animated: true)]
        case VC_CALENDAR:
            [scrollView .setContentOffset(CGPointMake(pagesScrollViewSize.width * (CGFloat)(index), -topBarHeight*2), animated: true)]
        case VC_MESSAGE:
            [scrollView .setContentOffset(CGPointMake(pagesScrollViewSize.width * (CGFloat)(index), -topBarHeight*2), animated: true)]
        default:
            [scrollView .setContentOffset(CGPointMake(pagesScrollViewSize.width * (CGFloat)(index), topBarHeight), animated: true)]
        }
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        // Load the pages that are now on screen
        loadVisiblePages()
        
        //The calculations for the animated bar's movements
        //The offset addition is based on the width of the animated bar (button width times 0.8)
        var offsetAddition = (containerView.frame.size.width/(CGFloat)(viewControllerIDs.count))*0.1
        animatedBar.frame = CGRectMake((offsetAddition + (scrollView.contentOffset.x/(CGFloat)(viewControllerIDs.count))), animatedBar.frame.origin.y, animatedBar.frame.size.width, animatedBar.frame.size.height);
    }
    
}