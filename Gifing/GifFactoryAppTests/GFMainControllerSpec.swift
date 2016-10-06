//
//  GFMainControllerSpec.swift
//  GifFactoryAppTests
//
//  Created by Storixs.
//  Copyright © 2016 Storix. All rights reserved.
//

import Quick
import Nimble

@testable import GifFactoryApp

class GFMainScreenViewControllerSpec: QuickSpec {
  override func spec() {
    var viewController: GFMainScreenViewController!
    beforeEach {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      viewController =
        storyboard.instantiateViewControllerWithIdentifier(
          GFMainScreenViewController.storyboardId) as! GFMainScreenViewController
    }
    
    describe("viewDidLoad") {
      beforeEach {
        // Directly call the lifecycle event.
        viewController.viewDidLoad()
      }
      
      it("sets backgroundAlertDismissingObserver") {
        expect(viewController._backgroundAlertDismissingObserver).toNot(beNil())
      }
      
      it("loads animationUrls") {
        expect(viewController.animationUrls).toNot(beNil())
      }
    }
    
    describe("viewDidAppear") {
      beforeEach {
        // Access the view to trigger Lifecycle Events.
         let _ =  viewController.view
      }
      
      it("reloads savedAnimationsCollectionView") {
        expect(viewController.savedAnimationsCollectionView.numberOfItemsInSection(0)).to(equal(viewController.animationUrls!.count))
      }
    }
  }
  
}
