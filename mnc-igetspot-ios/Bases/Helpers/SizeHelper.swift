//
//  SizeHelper.swift
//  Metube
//
//  Created by Adi Putra Setiawan on 13/04/18.
//  Copyright © 2018 MNC Innovation Center. All rights reserved.
//

import UIKit

class SizeHelper {
    static var BASE_SCREEN_WIDTH:CGFloat = 320
    static var SCREEN_WIDTH:CGFloat = 0.0
    static var SCREEN_HEIGHT:CGFloat = 0.0
    static var WINDOW_OFFSET_TOP: CGFloat = 0.0
    static var WINDOW_OFFSET_BOTTOM: CGFloat = 0.0
    static var WINDOW_WIDTH:CGFloat = 0.0
    static var WINDOW_HEIGHT:CGFloat = 0.0
    
    static func calculateScreenSize() {
        SCREEN_WIDTH = UIScreen.main.bounds.width
        SCREEN_HEIGHT = UIScreen.main.bounds.height
    }
    
    static func calculateWindowSize(navigationController: UINavigationController?, tabBarController: UITabBarController?) {
        WINDOW_OFFSET_TOP = UIApplication.shared.statusBarFrame.size.height
        if navigationController != nil {
            WINDOW_OFFSET_TOP = WINDOW_OFFSET_TOP + navigationController!.navigationBar.frame.size.height
        }
        WINDOW_OFFSET_BOTTOM = 0
        if tabBarController != nil && tabBarController!.tabBarIsVisible() {
            WINDOW_OFFSET_BOTTOM = tabBarController!.tabBar.frame.size.height
        }
        WINDOW_WIDTH = UIScreen.main.bounds.size.width
        WINDOW_HEIGHT = UIScreen.main.bounds.height - WINDOW_OFFSET_TOP - WINDOW_OFFSET_BOTTOM
    }
    
    static func getActualSize(size:CGFloat) -> CGFloat {
        return size / BASE_SCREEN_WIDTH * SCREEN_WIDTH
    }
    
    static func getHeight(containerHeight:CGFloat, verticalPadding:CGFloat) -> CGFloat {
        let height:CGFloat = containerHeight - (verticalPadding * 2)
        return height
    }
    
    static func getHeightOfContainer(lastFrame: CGRect, paddingBottom: CGFloat) -> CGFloat {
        let height: CGFloat = lastFrame.origin.y + lastFrame.size.height + paddingBottom
        return height
    }
    
    static func getWidth(containerWidth:CGFloat, horizontalPadding:CGFloat) -> CGFloat {
        let width:CGFloat = containerWidth - (horizontalPadding * 2)
        return width
    }
    
    static func getWidthGrid(containerWidth:CGFloat, horizontalPadding:CGFloat, columnSpacing: CGFloat, columnCount: NSInteger) -> CGFloat {
        let spaceWidth:CGFloat = SizeHelper.getWidth(containerWidth: containerWidth, horizontalPadding: horizontalPadding)
        let totalColumnSpacing:CGFloat = CGFloat(columnCount - 1) * columnSpacing
        let width: CGFloat = (spaceWidth - totalColumnSpacing) / CGFloat(columnCount)
        return width
    }
    
    static func getWidthOfScale(height:CGFloat, realWidth:CGFloat, realHeight:CGFloat) -> CGFloat {
        let width:CGFloat = realWidth / realHeight * height
        return width
    }
    
    static func getHeightOfScale(width:CGFloat, realWidth:CGFloat, realHeight:CGFloat) -> CGFloat {
        let height:CGFloat = realHeight / realWidth * width
        return height
    }
    
    static func getOriginXAlignCenter(width:CGFloat, containerWidth:CGFloat) -> CGFloat {
        let x:CGFloat = (containerWidth - width) / 2
        return x
    }
    
    static func getOriginXAlignRight(width:CGFloat, containerWidth:CGFloat, marginRight:CGFloat) -> CGFloat {
        let x: CGFloat = containerWidth - width - marginRight
        return x
    }
    
    static func getOriginYAlignCenter(height:CGFloat, containerHeight:CGFloat) -> CGFloat {
        let y:CGFloat = (containerHeight - height) / 2
        return y
    }
    
    static func getOriginYAlignBottom(height:CGFloat, containerHeight:CGFloat, marginBottom: CGFloat) -> CGFloat {
        let y:CGFloat = containerHeight - height - marginBottom
        return y
    }
    
    static func getOriginXAfterFrame(frame:CGRect, horizontalMargin:CGFloat) -> CGFloat {
        let x:CGFloat = frame.origin.x + frame.size.width + horizontalMargin
        return x
    }
    
    static func getOriginYAfterFrame(frame:CGRect, verticalMargin:CGFloat) -> CGFloat {
        let y:CGFloat = frame.origin.y + frame.size.height + verticalMargin
        return y
    }
    
    static func getOffsetBottom(frame: CGRect) -> CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    static func getOriginYBeforeFrame(frame:CGRect, beforeFrame:CGRect, verticalMargin:CGFloat) -> CGFloat {
        let y:CGFloat = beforeFrame.origin.y - frame.size.height - verticalMargin
        return y
    }
    
    static func getPercentValue(percent: CGFloat, valueOf: CGFloat) -> CGFloat {
        return percent / 100.0 * valueOf
    }
    
}
