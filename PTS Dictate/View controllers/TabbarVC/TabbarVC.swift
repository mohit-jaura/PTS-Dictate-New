//
//  TabbarVC.swift
//  PTS Dictate
//
//  Created by Paras Kamboj on 25/08/22.
//

import UIKit


class TabbarVC: UITabBarController, UITabBarControllerDelegate {
    
    var thirdTabbarItemImageView: UIImageView!
    var viewControllerToSelect: UIViewController?
    
    let tabbarNames : [String] = ["Existing\rDictations","Uploads\rin progress","Record","Settings","Logout"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
 
        let thirdItemView = self.tabBar.subviews[2]
        self.thirdTabbarItemImageView = thirdItemView.subviews.first as? UIImageView
        self.thirdTabbarItemImageView.contentMode = .center
        self.navigationController?.addCustomBottomLine(color: .black, height: 2.0)
        additionalSafeAreaInsets.bottom = UIDevice.current.hasNotch ? 0 : 12

        self.tabBar.layer.borderWidth = 1.0
        self.tabBar.layer.borderColor = UIColor.lightGray.cgColor
        self.tabBar.clipsToBounds = false
        
//        let topBorder = CALayer()
//
//           let borderHeight: CGFloat = 2
//
//           topBorder.borderWidth = borderHeight
//        topBorder.borderColor = UIColor.red.cgColor
//        topBorder.frame = CGRect(x: 0, y: -1, width: self.view.frame.width, height: borderHeight)
//
//        self.tabBar.layer.addSublayer(topBorder)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillLayoutSubviews() {
      
        // access to list of tab bar items
        if let items = self.tabBar.items {
            for (ind, itemt) in items.enumerated() {
                if ind == 2{
                    return
                }
                // here customise image insets top and bottom
                itemt.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -5, right: 0)
                let viewTabBar = itemt.value(forKey: "view") as? UIView
                if viewTabBar?.subviews.count == 2 {
                    // here customise the label
                    
                    if let label = viewTabBar?.subviews[1] as? UILabel {
                        label.numberOfLines = 2
                        label.textAlignment = .center
//                        label.lineBreakMode = .byWordWrapping
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            label.frame = CGRect(x: label.frame.minX, y: label.frame.minY, width: ind == 0 ? UIScreen.main.bounds.width/9.8 : 44, height: 25)
                            label.text = self.tabbarNames[ind]
                            viewTabBar?.layoutIfNeeded()
                            viewTabBar?.setNeedsLayout()
                            viewTabBar?.layoutSubviews()
                        }
                    }
                }
            }
        }
    }

    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.2, 0.9, 1.1, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
    private func animate(_ imageView: UIImageView) {
        UIView.animate(withDuration: 0.1, animations: {
            imageView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3.0, options: .curveEaseInOut, animations: {
                imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let currentIndex = tabBar.items?.firstIndex(of: item)
        let tabbarItemTag = item.tag
        switch tabbarItemTag {
        case 0:
            break
        case 2:
            if currentIndex != selectedIndex {
                animate(thirdTabbarItemImageView)
            }
        default:
            break
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "logout"{
            print("logout")
            CommonFunctions.showAlert(view: viewController, title: "PTS Dictate", message: "Are you sure you want to Logout?", completion: {
                (result) in
                if result{
                    print("Tapped Yes")
                    CoreData.shared.deleteProfile()
                    AppDelegate.sharedInstance().moveToLoginVC()
                }else{
                    print("Tapped No")
                }
            })
            return false
        }
        return true
    }
}

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context!.setFillColor(color.cgColor)
        context!.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
